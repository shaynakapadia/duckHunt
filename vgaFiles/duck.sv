module  duck( input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_duck,             // Whether current pixel belongs to Duck or background
               output logic [15:0] duck_addr
              );

logic [9:0] Duck_X_Pos, Duck_X_Motion, Duck_Y_Pos, Duck_Y_Motion;
logic [9:0] Duck_X_Pos_in, Duck_X_Motion_in, Duck_Y_Pos_in, Duck_Y_Motion_in;
logic [2:0] which_duck, which_duck_in;
int counter, counter_in, facing, facing_in;

parameter [9:0] Duck_X_Center = 10'd320;  // Center position on the X axis
parameter [9:0] Duck_Y_Center = 10'd240;  // Center position on the Y axis
parameter [9:0] Duck_X_Min = 10'd1;       // Leftmost point on the X axis
parameter [9:0] Duck_X_Max = 10'd575;     // Rightmost point on the X axis
parameter [9:0] Duck_Y_Min = 10'd0;       // Topmost point on the Y axis
parameter [9:0] Duck_Y_Max = 10'd245;     // Bottommost point on the Y axis
parameter [9:0] Duck_X_Step = 10'd1;      // Step size on the X axis
parameter [9:0] Duck_Y_Step = 10'd1;      // Step size on the Y axis
parameter [9:0] Duck_X_Size = 10'd64;        // Duck X size
parameter [9:0] Duck_Y_Size = 10'd64;        // Duck Y size
parameter [9:0] Sprite_X_Size = 10'd320;        // Sprite X size


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
        Duck_X_Motion <= 1'b1;
        Duck_Y_Motion <= 1'b1;
        which_duck <= 3'b000;
        counter <= 10'd0;
        facing <= 10'd64;
    end
    else
    begin
        Duck_X_Pos <= Duck_X_Pos_in;
        Duck_Y_Pos <= Duck_Y_Pos_in;
        Duck_X_Motion <= Duck_X_Motion_in;
        Duck_Y_Motion <= Duck_Y_Motion_in;
        which_duck <= which_duck_in;
        counter <= counter_in;
        facing <= facing_in;
    end
end

always_comb
begin
    // By default, keep motion and position unchanged
    Duck_X_Pos_in = Duck_X_Pos;
    Duck_Y_Pos_in = Duck_Y_Pos;
    Duck_X_Motion_in = Duck_X_Motion;
    Duck_Y_Motion_in = Duck_Y_Motion;
    which_duck_in = which_duck;
	  counter_in = counter;
    facing_in = facing;

    // Update position, motion, and duck frame only at rising edge of frame clock
    if (frame_clk_rising_edge)
      begin
    // ---------------------------------------------------------------------------
    // This portion of the code iterates through the three duck sprites to animate the duck
        counter_in = counter + 10'd1;
        if(counter_in > 10'd10)
          begin
            counter_in = 10'd0;
            if(which_duck >= 3'b010)
                which_duck_in = 3'b000;
            else
              which_duck_in = which_duck + 3'b001;
          end
        else
          which_duck_in = which_duck;
    // ---------------------------------------------------------------------------
    // This code will set the path of the duck in a zig zag motion

    // ---------------------------------------------------------------------------
    // This code is what sets the motion of the duck and prevents it from going off the screen
        if( Duck_X_Pos >= Duck_X_Max )
          begin
            Duck_X_Motion_in = (~(Duck_X_Step) + 1'b1);
            facing_in = 10'd0;
          end
        else if ( Duck_X_Pos <= Duck_X_Min )
          begin
            Duck_X_Motion_in = Duck_X_Step;
            facing_in = 10'd64;
          end
        if( Duck_Y_Pos >= Duck_Y_Max )
          begin
            Duck_Y_Motion_in = (~(Duck_Y_Step) + 1'b1);
          end
        else if ( Duck_Y_Pos <= Duck_Y_Min )
          begin
            // Duck_Y_Motion_in = 10'd0;
            // Duck_X_Motion_in = 10'd0;
          end
    // ---------------------------------------------------------------------------
        // Update the ball's position with its motion
        Duck_X_Pos_in = Duck_X_Pos + Duck_X_Motion;
        Duck_Y_Pos_in = Duck_Y_Pos + Duck_Y_Motion;
      end

end

// Compute whether the pixel corresponds to Duck or background
/* Since the multiplicants are required to be signed, we have to first cast them
   from logic to int (signed by default) before they are multiplied. */
int DistX, DistY, Size;
logic [31:0] addr;
assign DistX = DrawX - Duck_X_Pos;
assign DistY = DrawY - Duck_Y_Pos;

//assign addr = 32'd550 + (DistY*32'd38) + DistX;
assign addr =  (DistY + facing)*(Sprite_X_Size) + DistX + which_duck*Duck_X_Size;

always_comb begin
	if(addr <= 32'hffff)
		begin
			duck_addr = addr[15:0];
		end
  else if(addr[31] == 1'b1)
    begin
      duck_addr = 16'h0;
    end
	else
		begin
			duck_addr = 16'h0;
		end
end

// spriteROM duck(.Clk(Clk), .read_address(duck_addr), .data_Out(duck_index));
// paletteROM palette(.Clk(Clk), .read_address(duck_index), .data_Out(duck_color));

// duckyROM ducky(.Clk(Clk), .read_address(duck_addr), .data_Out(duck_color));

always_comb begin

    if ((DistX < Duck_X_Size) && (DistY < Duck_Y_Size))
      is_duck = 1'b1;
    else
      is_duck = 1'b0;

end


endmodule
