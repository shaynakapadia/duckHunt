/* This driver reads quaternion data from the MPU6060 and sends
   Open Sound Control messages.

  GY-521  NodeMCU
  MPU6050 devkit 1.0
  board   Lolin         Description
  ======= ==========    ====================================================
  VCC     VU (5V USB)   Not available on all boards so use 3.3V if needed.
  GND     G             Ground
  SCL     D1 (GPIO05)   I2C clock
  SDA     D2 (GPIO04)   I2C data
  XDA     not connected
  XCL     not connected
  AD0     not connected
  INT     D8 (GPIO15)   Interrupt pin
*/
/*
  The module has also been modified to work as an access point that takes the data from
  the gyroscope as well as the trigger button output, condenses it into one string and 
  sends it to the next WiFi Module.
*/

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

// I2Cdev and MPU6050 must be installed as libraries, or else the .cpp/.h files
// for both classes must be in the include path of your project
#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

//Declare the devices and stuff
MPU6050 mpu;
WiFiServer server(80);


// MPU control/status vars
bool dmpReady = false;  // set true if DMP init was successful
uint8_t mpuIntStatus;   // holds actual interrupt status byte from MPU
uint8_t devStatus;      // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize;    // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount;     // count of all bytes currently in FIFO
uint8_t fifoBuffer[64]; // FIFO storage buffer

// orientation/motion vars
Quaternion q;           // [w, x, y, z]         quaternion container
VectorInt16 aa;         // [x, y, z]            accel sensor measurements
VectorInt16 aaReal;     // [x, y, z]            gravity-free accel sensor measurements
VectorInt16 aaWorld;    // [x, y, z]            world-frame accel sensor measurements
VectorFloat gravity;    // [x, y, z]            gravity vector
float ypr[3];           // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector

//Measured coordinate variables
float yaw, pitch, roll;
int x, y;

//Trigger pressed variable
int trigger;
int trigger_prev;


//time constraints
unsigned long my_time;
long debounce = 200;
unsigned long dif; 

//WiFi variables
int temp =0;
String s;


#define INTERRUPT_PIN 15 // use pin 15 on ESP8266
#define TRIGGER_PIN 12   // pin 12 as the trigger

const char DEVICE_NAME[] = "mpu6050";

// ================================================================
// ===               INTERRUPT DETECTION ROUTINE                ===
// ================================================================

volatile bool mpuInterrupt = false;     // indicates whether MPU interrupt pin has gone high
void dmpDataReady() {
  mpuInterrupt = true;
}

//Simple function to pad with zeroes

String Pad(int num){
  String ans;
  if(num < 10){
    ans = "00"+String(num);
    } 
  else if(num < 100){
    ans = "0"+String(num);
    }
  else{
    ans = String(num);
    } 
  return ans;
}

void mpu_setup()
{
  // join I2C bus (I2Cdev library doesn't do this automatically)
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
  Wire.begin();
  Wire.setClock(400000); // 400kHz I2C clock. Comment this line if having compilation difficulties
#elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
  Fastwire::setup(400, true);
#endif

  // initialize device
  Serial.println(F("Initializing I2C devices..."));
  mpu.initialize();
  pinMode(INTERRUPT_PIN, INPUT);

  // verify connection
  Serial.println(F("Testing device connections..."));
  Serial.println(mpu.testConnection() ? F("MPU6050 connection successful") : F("MPU6050 connection failed"));

  // load and configure the DMP
  Serial.println(F("Initializing DMP..."));
  devStatus = mpu.dmpInitialize();

  // supply your own gyro offsets here, scaled for min sensitivity
  // We'll use the additional script to find the offset 
  mpu.setXGyroOffset(70);
  mpu.setYGyroOffset(22);
  mpu.setZGyroOffset(65);
  mpu.setZAccelOffset(1141); // 1688 factory default for my test chip

  // make sure it worked (returns 0 if so)
  if (devStatus == 0) {
    // turn on the DMP, now that it's ready
    Serial.println(F("Enabling DMP..."));
    mpu.setDMPEnabled(true);

    // enable Arduino interrupt detection
    Serial.println(F("Enabling interrupt detection (Arduino external interrupt 0)..."));
    attachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN), dmpDataReady, RISING);
    mpuIntStatus = mpu.getIntStatus();

    // set our DMP Ready flag so the main loop() function knows it's okay to use it
    Serial.println(F("DMP ready! Waiting for first interrupt..."));
    dmpReady = true;

    // get expected DMP packet size for later comparison
    packetSize = mpu.dmpGetFIFOPacketSize();
  } else {
    // ERROR!
    // 1 = initial memory load failed
    // 2 = DMP configuration updates failed
    // (if it's going to break, usually the code will be 1)
    Serial.print(F("DMP Initialization failed (code "));
    Serial.print(devStatus);
    Serial.println(F(")"));
  }
}

void setup(void)
{
  Serial.begin(115200);
  Serial.println(F("\nOrientation Sensor OSC output")); Serial.println();
  pinMode(TRIGGER_PIN, INPUT_PULLUP);
  trigger = HIGH;
  trigger_prev = HIGH;
  mpu_setup();
  
  //WiFi module setup here
  Serial.print("Configuring access point...");
  /* You can remove the password parameter if you want the AP to be open. */
  WiFi.mode(WIFI_AP);
  WiFi.softAP("Controller");
  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
  server.begin();
}

void mpu_loop()
{
  // if programming failed, don't try to do anything
  if (!dmpReady) return;

  // wait for MPU interrupt or extra packet(s) available
  if (!mpuInterrupt && fifoCount < packetSize) return;

  // reset interrupt flag and get INT_STATUS byte
  mpuInterrupt = false;
  mpuIntStatus = mpu.getIntStatus();

  // get current FIFO count
  fifoCount = mpu.getFIFOCount();

  // check for overflow (this should never happen unless our code is too inefficient)
  if ((mpuIntStatus & 0x10) || fifoCount == 1024) {
    // reset so we can continue cleanly
    mpu.resetFIFO();
    Serial.println(F("FIFO overflow!"));

    // otherwise, check for DMP data ready interrupt (this should happen frequently)
  } 
  else if (mpuIntStatus & 0x02) {
    // wait for correct available data length, should be a VERY short wait
    while (fifoCount < packetSize) fifoCount = mpu.getFIFOCount();

    // read a packet from FIFO
    mpu.getFIFOBytes(fifoBuffer, packetSize);

    // track FIFO count here in case there is > 1 packet available
    // (this lets us immediately read more without waiting for an interrupt)
    fifoCount -= packetSize;
    // display Euler angles in degrees
    mpu.dmpGetQuaternion(&q, fifoBuffer);
    mpu.dmpGetGravity(&gravity, &q);
    mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
    //Serial.print("ypr\t");
    //Serial.print(ypr[0] * 180/M_PI);
    //mpu.dmpGetQuaternion(&q, fifoBuffer);
    mpu.dmpGetAccel(&aa, fifoBuffer);
    //mpu.dmpGetGravity(&gravity, &q);
    //mpu.dmpGetLinearAccel(&aaReal, &aa, &gravity);
    //Serial.print("areal\t");
    /*
     *ypr[0] -> yaw   : Side to side
     *ypr[1] -> pitch : nose up or tail up
     *ypr[2] -> roll  : anitclockwise or clockwise turning
     *Roll is used in our cose to check how the controller is being held
     *The yaw and pitch determine where on the screen the pointer is pointing
     *Calculations to estimate position on a 640*480 screen are made based on 
     *what looked right
    */
    yaw   = ypr[0] * 180/M_PI;
    pitch = ypr[1] * 180/M_PI;
    roll  = (ypr[2] * 180/M_PI);
    /*
     * The X coordinate is calculated using the pitch
     * The Y coordinate depends on the orietation of the accelerometer
     * Currently, the Y is calculated using the roll
     * There are some boundary conditions set for if the cursor goes out of the egde
    */
    x = yaw*4+160;
    y = roll*8+240;
    if(x > 320){
      x = 320;
    }
    if(x < 0){
      x = 0;
    }

    if(y > 480){
      y = 480;
    }
    if(y < 0){
      y = 0;
    }
//    Serial.print(ypr[0] * 180/M_PI);
//    Serial.print("\t");
//    Serial.print((ypr[1] * 180/M_PI));
//    Serial.print("\t");
//    Serial.print(ypr[2] * 180/M_PI);
//    Serial.print("\t");
//    Serial.print(x);
//    Serial.print("\t");
//    Serial.println(y);
  }
}

/**************************************************************************/
/*
    Arduino loop function, called once 'setup' is complete (your own code
    should go here)
*/
/**************************************************************************/
void loop(void)
{
  trigger = digitalRead(TRIGGER_PIN);  
  if(trigger == LOW && trigger_prev == HIGH && (millis() - my_time) > debounce){
 // Serial.print("Trigger value:");
 // Serial.println(trigger);
    my_time = millis();
    trigger_prev = LOW;
  }
  else{
    trigger_prev = HIGH;
  }
 mpu_loop();

 //Once completeand variables are set, put them in the string and send
//
 WiFiClient c = server.available();
 s = Pad(x) + Pad(y) + String(trigger)+ "\r";
 c.print(s);
 Serial.println(s);
}
