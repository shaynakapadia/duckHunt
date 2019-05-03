module testbench ();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
	// Avalon Clock Input
logic CLOCK_50;
logic [3:0]  KEY;
logic [7:0]  VGA_R;        //VGA Red
logic [7:0]  VGA_G;        //VGA Green
logic [7:0]  VGA_B;        //VGA Blue
logic        VGA_CLK;      //VGA Clock
logic VGA_SYNC_N;   //VGA Sync signal
logic VGA_BLANK_N;  //VGA Blank signal
logic VGA_VS;       //VGA virtical sync signal
logic VGA_HS;
logic [6:0]  HEX0;
logic [6:0]  HEX1;
logic [6:0]  HEX2;
logic [6:0]  HEX3;
logic [6:0]  HEX4;
logic [6:0]  HEX5;
logic [6:0]  HEX6;
logic [6:0]  HEX7;


toplevel testmod(.*);
// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program

always begin : CLOCK_GENERATION

#1 CLOCK_50 = ~CLOCK_50;
VGA_VS = ~VGA_VS;

end

initial begin : CLOCK_INITIALIZATION
		CLOCK_50 = 0;
		VGA_VS = 0;
end

initial begin: TEST_VECTORS

KEY = 4'b1111;

#6
KEY = 4'b1110;

#2
KEY = 4'b1111;

#4
KEY = 4'b1101;

#4
KEY = 4'b1111;

#8
KEY = 4'b0111;



end
endmodule
