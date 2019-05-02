module  dog( input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_dog,             // Whether current pixel belongs to Dog or background
               output logic [13:0] dog_addr
              );

logic [9:0] Dog_X_Pos, Dog_X_Motion, Dog_Y_Pos, Dog_Y_Motion;
logic [9:0] Dog_X_Pos_in, Dog_X_Motion_in, Dog_Y_Pos_in, Dog_Y_Motion_in;
logic [1:0] which_dog, which_dog_in;
int counter, counter_in;

parameter [9:0] Dog_X_Center = 10'd320;  // Center position on the X axis
parameter [9:0] Dog_Y_Center = 10'd240;  // Center position on the Y axis
parameter [9:0] Dog_X_Min = 10'd1;       // Leftmost point on the X axis
parameter [9:0] Dog_X_Max = 10'd575;     // Rightmost point on the X axis
// parameter [9:0] Dog_Y_Min = 10'd0;       // Topmost point on the Y axis
// parameter [9:0] Dog_Y_Max = 10'd479;     // Bottommost point on the Y axis
parameter [9:0] Dog_X_Step = 10'd1;      // Step size on the X axis
// parameter [9:0] Dog_Y_Step = 10'd1;      // Step size on the Y axis
parameter [9:0] Dog_X_Size = 10'd64;        // Dog X size
parameter [9:0] Dog_Y_Size = 10'd64;        // Dog Y size
parameter [9:0] Sprite_X_Size = 10'd128;        // Sprite X size


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
        Dog_X_Pos <= Dog_X_Center;
        Dog_Y_Pos <= Dog_Y_Center;
        which_dog <= 2'b00;
        counter <= 10'd0;
    end
    else
    begin
        Dog_X_Pos <= Dog_X_Pos_in;
        Dog_Y_Pos <= Dog_Y_Pos_in;
        Dog_X_Motion <= Dog_X_Motion_in;
        Dog_Y_Motion <= 10'd0;
        which_dog <= which_dog_in;
        counter <= counter_in;
    end
end

always_comb
begin
    // By default, keep motion and position unchanged
    Dog_X_Pos_in = Dog_X_Pos;
    Dog_Y_Pos_in = Dog_Y_Pos;
    Dog_X_Motion_in = Dog_X_Motion;
    Dog_Y_Motion_in = Dog_Y_Motion;
    which_dog_in = which_dog;
	  counter_in = counter;

    // Update position, motion, and dog frame only at rising edge of frame clock
    if (frame_clk_rising_edge)
      begin
    // // ---------------------------------------------------------------------------
    // // This portion of the code iterates through the three dog sprites to animate the dog
    //     counter_in = counter + 10'd1;
    //     if(counter_in > 10'd10)
    //       begin
    //         counter_in = 10'd0;
    //         if(which_dog == 2'b11)
    //             which_dog_in = 2'b00;
    //         else
    //           which_dog_in = which_dog + 2'b01;
    //       end
    //     else
    //       which_dog_in = which_dog;
    // // ---------------------------------------------------------------------------
    // // This code is what sets the motion of the dog and prevents it from going off the screen
    //     if( Dog_X_Pos >= Dog_X_Max )
    //       begin
    //         Dog_X_Motion_in = (~(Dog_X_Step) + 1'b1);
    //       end
    //     else if ( Dog_X_Pos <= Dog_X_Min )
    //     begin
    //       Dog_X_Motion_in = Dog_X_Step;
    //     end
    // // ---------------------------------------------------------------------------
    //     // Update the ball's position with its motion
    //     Dog_X_Pos_in = Dog_X_Pos + Dog_X_Motion;
      end

end

// Compute whether the pixel corresponds to Dog or background
/* Since the multiplicants are required to be signed, we have to first cast them
   from logic to int (signed by default) before they are multiplied. */
int DistX, DistY, Size;
logic [31:0] addr;
assign DistX = DrawX - Dog_X_Pos;
assign DistY = DrawY - Dog_Y_Pos;

//assign addr = 32'd550 + (DistY*32'd38) + DistX;
assign addr =  (DistY)*(Sprite_X_Size) + DistX + which_dog*Dog_X_Size;

always_comb begin
	dog_addr = addr[13:0];
end

// spriteROM dog(.Clk(Clk), .read_address(dog_addr), .data_Out(dog_index));
// paletteROM palette(.Clk(Clk), .read_address(dog_index), .data_Out(dog_color));

// dogyROM dogy(.Clk(Clk), .read_address(dog_addr), .data_Out(dog_color));

always_comb begin

    if ((DistX < Dog_X_Size) && (DistY < Dog_Y_Size))
      is_dog = 1'b1;
    else
      is_dog = 1'b0;

end


endmodule
