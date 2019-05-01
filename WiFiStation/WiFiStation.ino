#include <ESP8266WiFi.h>


const char* host = "192.168.4.1";
WiFiClient c; 
String values="";

int x_coord, y_coord, trigger;

/*Pin 1 is TX, and Pin 3 is RX, and Pin 17 is ADC*/
int Pins[] = {4, 5, 2, 16, 0, 15, 13, 12, 14, 1, 3};
int x[9];
int y[9];
int isX;

/*Some time constraints*/
unsigned long curr_time;
unsigned long last_time;
unsigned long wait_time;

void toBin(unsigned int num, char ar){
  if(ar == 'x'){
    for(int i=0; i<9; i++){
      x[i] = bitRead(num, i);
    }
  }
  else{
    for(int i=0; i<9; i++){
      y[i] = bitRead(num, i);
    } 
  }
}

void setup()
{

  //********** CHANGE PIN FUNCTION  TO GPIO **********
  //GPIO 1 (TX) swap the pin to a GPIO.
  pinMode(1, FUNCTION_3); 
  //GPIO 3 (RX) swap the pin to a GPIO.
  pinMode(3, FUNCTION_3); 
  //**************************************************  
  
  Serial.begin(115200);
  Serial.println();

  /* Setting up Wifi Station  */

  WiFi.mode(WIFI_STA);
  WiFi.begin("Controller");

  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println();

  Serial.print("Connected, IP address: ");
  Serial.println(WiFi.localIP());

  /* Setting the variables for sending the data to the FPGA */
  x_coord = 0;
  y_coord = 0;
  trigger = 0;
  isX = 1;

  for(int i =0; i < 11; i++){
      pinMode(Pins[i], OUTPUT);
    }
  for(int i = 0; i < 9; i++){
      x[i] = 0;
      y[i] = 0;
    }
    
  wait_time  = 6; //sets to wait about 6 milliseconds
  last_time = millis();
}

void loop() {

  /*Connecting to the Access Point and receiving coordinate data*/
  c.connect(host, 80); //? Serial.println("Yay!") : Serial.println("Nope :(");
  values = c.readStringUntil('\r');

  /* Parsing the data to integers */ 
  x_coord = (values.substring(0,3)).toInt();
  y_coord = (values.substring(3,6)).toInt();
  trigger = (values.substring(6)).toInt();
  
   /* Convert the data into binary and place into respective arrays */
  toBin(x_coord, 'x');
  toBin(y_coord, 'y');

  /* Depending on the value put in last, load the x or y coordinates into the pins */
  curr_time = millis();
  if(curr_time-last_time > wait_time){
    last_time = curr_time;
    if(isX){
      for(int i = 0; i< 9; i++){
        digitalWrite(Pins[i], x[i]);
      }
    isX = 0;
    }
    else{
      for(int i = 0; i< 9; i++){
        digitalWrite(Pins[i], y[i]);
      }
    isX = 1;    
    }
  }
  /* Write Trigger Pin */  
  digitalWrite(Pins[9], trigger);
  digitalWrite(Pins[10], isX);
  //Serial.println(values);
  
  c.stop();
}
