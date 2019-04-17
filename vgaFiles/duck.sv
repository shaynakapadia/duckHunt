module  duck( input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_duck,             // Whether current pixel belongs to Duck or background
               output logic [23:0] duck_color
              );

logic [9:0] Duck_X_Pos, Duck_X_Motion, Duck_Y_Pos, Duck_Y_Motion;
logic [9:0] Duck_X_Pos_in, Duck_X_Motion_in, Duck_Y_Pos_in, Duck_Y_Motion_in;

parameter [9:0] Duck_X_Center = 10'd320;  // Center position on the X axis
parameter [9:0] Duck_Y_Center = 10'd240;  // Center position on the Y axis
// parameter [9:0] Duck_X_Min = 10'd0;       // Leftmost point on the X axis
// parameter [9:0] Duck_X_Max = 10'd639;     // Rightmost point on the X axis
// parameter [9:0] Duck_Y_Min = 10'd0;       // Topmost point on the Y axis
// parameter [9:0] Duck_Y_Max = 10'd479;     // Bottommost point on the Y axis
// parameter [9:0] Duck_X_Step = 10'd1;      // Step size on the X axis
// parameter [9:0] Duck_Y_Step = 10'd1;      // Step size on the Y axis
parameter [9:0] Duck_X_Size = 10'd38;        // Duck X size
parameter [9:0] Duck_Y_Size = 10'd30;        // Duck X size

logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end

// Update registers
always_ff @ (posedge Clk)
begin
    if (Reset)
    begin
        Duck_X_Pos <= Duck_X_Center;
        Duck_Y_Pos <= Duck_Y_Center;
    end
    else
    begin
        Duck_X_Pos <= Duck_X_Pos_in;
        Duck_Y_Pos <= Duck_Y_Pos_in;
        Duck_X_Motion <= 10'd0;
        Duck_Y_Motion <= 10'd0;
    end
end

always_comb
begin
    // By default, keep motion and position unchanged
    Duck_X_Pos_in = Duck_X_Pos;
    Duck_Y_Pos_in = Duck_Y_Pos;
    Duck_X_Motion_in = Duck_X_Motion;
    Duck_Y_Motion_in = Duck_Y_Motion;

    // Update position and motion only at rising edge of frame clock
    if (frame_clk_rising_edge)
    begin

    end

end

// Compute whether the pixel corresponds to Duck or background
/* Since the multiplicants are required to be signed, we have to first cast them
   from logic to int (signed by default) before they are multiplied. */
int DistX, DistY, Size;
logic [31:0] addr;
logic [18:0] duck_addr;
assign DistX = DrawX - Duck_X_Pos;
assign DistY = DrawY - Duck_Y_Pos;

//assign addr = 32'd550 + (DistY*32'd38) + DistX;
assign addr =  DistY*Duck_X_Size + DistX;

always_comb begin
	if(addr <= 32'h7ffff)
		begin
			duck_addr = addr[18:0];
		end
  else if(addr[31] == 1'b1)
    begin
      duck_addr = 19'h0;
    end
	else
		begin
			duck_addr = 19'h0;
		end
end

duckyROM duckdown(.Clk(Clk), .read_address(duck_addr), .data_Out(duck_color));

always_comb begin

    if ((DistX < Duck_X_Size) && (DistY < Duck_Y_Size) && (duck_color != 24'h00ff00))
      is_duck = 1'b1;
    else
      is_duck = 1'b0;

end


endmodule
