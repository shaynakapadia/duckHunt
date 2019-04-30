# Duck Hunt

This is Duck Hunt built for the Altera DE2-115 board. We used Quartus, NIOS II and the Arduino IDE to build this game. The hardware is written in System Verilog and C.<br />
The objective of this game is to shoot ducks as they appear one by one on the screen. You get 3 shots for each duck. Your goal is to shoot as many ducks as you can. If over the course of the game you miss 3 ducks and let them fly away or you run out shots for a duck, it's game over for you!<br />
To shoot the ducks, we have designed a gun that uses the accelerometer and gyroscope to get our raw position, sends it to the ESP8266 and is then converted to readable coordinates which map to the VGA screen. This data along with the trigger data is then sent to the next ESP8266 which puts these values into the its digital output pins and from there to the DE2 board GPIO pins.<br />
We used the ECE385 Helper Tools to generate the sprites, where we made sprite sheets for each character in different positions for animation, and our background screens as separate sprite sheets as well.
The Game control logic puts all of this together with the help of a Finite State Machine. We also implement score counting and display the score along with the number of shots left on the gameplay screen.  <br />
