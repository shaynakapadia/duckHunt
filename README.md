# duckHunt
final project for ECE 385 at UIUC

# Description
duckHunt is an old NES gun shooter video game. The premise of the game is to shoot as many ducks as you can. We decided to modernize this game by recreating it with a WiFi Gun Controller. 

# How it works
The gun controller is equipped with a accelerometer/gyroscope and ESP8266 WiFi module. We fixed the accelerometer/gyroscope readings to be fixed between 640x480, the size of our screen. The ESP8266 would then send these readings to another ESP8266 connected to the Altera DE2-115 FPGA board. The FPGA board receives these signals through its GPIO pins and updates its internal value for the cursor each time it receives a new coordinate. The game logic and grahpics are implemented entirely in hardware logic. There is no NIOS processor used. The game state is changed and maintained using an FSM that takes in inputs from the other modules that keep track of if a birds been shot, if a shot missed, if there are no shots left, etc. 

