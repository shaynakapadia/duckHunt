module  duck( input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input         new_round,
					     input [2:0]	 state,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_duck,             // Whether current pixel belongs to Duck or background
               output logic  flew_away,
				       output logic  duck_ded_done,
               output logic [9:0] duck_x, duck_y,
               output logic [15:0] duck_addr
              );

logic [31:0] seed;
logic [9:0] Duck_X_Pos, Duck_X_Motion, Duck_Y_Pos, Duck_Y_Motion, Duck_Y_Random;
logic [9:0] Duck_X_Pos_in, Duck_X_Motion_in, Duck_Y_Pos_in, Duck_Y_Motion_in;
logic [2:0] which_duck, which_duck_in;
int counter, counter_in, facing, facing_in, counter2, counter2_in, counter3, counter3_in, counter4, counter4_in, count4_cmp;
logic new_duck, new_duck_in, releasey, releasey_in;

// counter switches between the 3 flapping duck sprites to create the flapping duck animaiton
// counter2 switches between the left and right ded duck
// counter3 is used to change the boundaries on the duck
// counter4 decides when to release the upper boundary on the duck.

logic [9:0] Duck_X_Start = 10'd500;  // Center position on the X axis
logic [9:0] Duck_Y_Start = 10'd245;  // Center position on the Y axis
logic [9:0] Duck_X_Min;       // Leftmost point on the X axis
logic [9:0] Duck_X_Max;     // Rightmost point on the X axis
logic [9:0] Duck_Y_Min;       // Topmost point on the Y axis
logic [9:0] Duck_Y_Max = 10'd245;     // Bottommost point on the Y axis
logic [9:0] Duck_X_Step;      // Step size on the X axis
logic [9:0] Duck_Y_Step;      // Step size on the Y axis
logic [9:0] Duck_X_Size = 10'd64;        // Duck X size
logic [9:0] Duck_Y_Size = 10'd64;        // Duck Y size
logic [9:0] Sprite_X_Size = 10'd320;        // Sprite X size


assign duck_x = Duck_X_Pos;
assign duck_y = Duck_Y_Pos;

random seed_generator(.Clk(new_duck), .Reset(Reset), .seed(32'd7898789),
.max(32'd4294967295), .min(32'd0), .data(seed));

random duckXMax(.Clk(new_duck), .Reset(Reset), .seed(32'd789 & seed),
.max(32'd639), .min(32'd320), .data(Duck_X_Max));

random duckXMin(.Clk(new_duck), .Reset(Reset), .seed(32'd433 & seed),
.max(32'd170), .min(32'd40), .data(Duck_X_Min));

random duckYMin(.Clk(new_duck), .Reset(Reset), .seed(32'd789 & seed),
.max(32'd100), .min(32'd2), .data(Duck_Y_Random));

random duckXspeed(.Clk(new_duck), .Reset(Reset), .seed(32'd7523 & seed),
.max(32'd4), .min(32'd1), .data(Duck_X_Step));

random duckYspeed(.Clk(new_duck), .Reset(Reset), .seed(32'd3123 & seed),
.max(32'd4), .min(32'd1), .data(Duck_Y_Step));

random duckYrelease(.Clk(new_round), .Reset(Reset), .seed(32'd843423 & seed),
.max(32'd700), .min(32'd250), .data(count4_cmp));

mux2_1 duckypicker(.s(releasey), .c0(Duck_Y_Random), .c1(32'd1), .out(Duck_Y_Min));

logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end


// Update registers
always_ff @ (posedge Clk)
begin
    if (Reset || (state == 3'b001) )
    begin
        Duck_X_Pos <= Duck_X_Start;
        Duck_Y_Pos <= Duck_Y_Start;
        Duck_X_Motion <= 1'b1;
        Duck_Y_Motion <= 1'b1;
        which_duck <= 3'b000;
        counter <= 10'd0;
        counter2 <= 10'd0;
        counter3 <= 10'd0;
        counter4 <= 10'd0;
        facing <= 10'd64;
        new_duck <= 1'b0;
        releasey <= 1'b0;
    end
    else if(state == 3'b100)
    begin
      Duck_X_Pos <= Duck_X_Pos_in;
      Duck_Y_Pos <= Duck_Y_Pos_in;
      Duck_X_Motion <= 1'b0;
      Duck_Y_Motion <= 1'b1;
      which_duck <= which_duck_in;
      counter <= 10'd0;
      counter2 <= counter2_in;
      counter3 <= counter3_in;
      counter4 <= counter4_in;
      facing <= facing_in;
      new_duck <= new_duck_in;
      releasey <= releasey_in;
    end
    else if(state == 3'b010) begin
      Duck_X_Pos <= Duck_X_Pos_in;
      Duck_Y_Pos <= Duck_Y_Pos_in;
      Duck_X_Motion <= Duck_X_Motion_in;
      Duck_Y_Motion <= Duck_Y_Motion_in;
      which_duck <= which_duck_in;
      counter <= counter_in;
      counter2 <= 10'd0;
      counter3 <= counter3_in;
      counter4 <= counter4_in;
      facing <= facing_in;
      new_duck <= new_duck_in;
      releasey <= releasey_in;
    end
    else
    begin
        Duck_X_Pos <= Duck_X_Pos_in;
        Duck_Y_Pos <= Duck_Y_Pos_in;
        Duck_X_Motion <= Duck_X_Motion_in;
        Duck_Y_Motion <= Duck_Y_Motion_in;
        which_duck <= which_duck_in;
        counter <= counter_in;
        counter2 <= counter2_in;
        counter3 <= counter3_in;
        counter4 <= counter4_in;
        facing <= facing_in;
        new_duck <= new_duck_in;
        releasey <= releasey_in;
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
	  counter2_in = counter2;
	  counter3_in = counter3;
    counter4_in = counter4;
	  new_duck_in = new_duck;
    releasey_in = releasey;
    facing_in = facing;
    flew_away = 1'b0;
    duck_ded_done = 1'b0;

    // Update position, motion, and duck frame only at rising edge of frame clock
    if (frame_clk_rising_edge && state == 3'b010)
      begin
        if(state == 3'b010)
          begin
          // ---------------------------------------------------------------------------
          // This portion of the code iterates through the three duck sprites to animate the duck
              counter_in = counter + 10'd1;
              counter4_in = counter4 + 10'd1;
              //counter3 is used to change the boundaries on the duck
              if(counter3_in % 300 == 0)
                new_duck_in = ~new_duck;
              else
                new_duck_in = new_duck;
              //if counter gets to high, reset it
              if(counter3_in > 10000000)
                counter3_in = 10'd0;
              else
                counter3_in = counter3 + 10'd1;
          // ---------------------------------------------------------------------------
              // this code switches between the 3 flapping duck sprites to create the flapping duck animaiton
              if(counter_in > 10'd4)
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
          // this decides when to release the upper boundary on the duck. if the counter is lower than the compare value, dont release.
            if(counter4_in >= count4_cmp) begin
              releasey_in = 1'b1;
            end
            else begin
              releasey_in = 1'b0;
            end
          // ---------------------------------------------------------------------------
          // This code is what sets the motion of the duck and sets its x and y boundaries
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
              else if ( (Duck_Y_Pos <= Duck_Y_Min) )
                begin
                  if(Duck_Y_Min == 10'd1) begin
                    flew_away = 1'b1;
                    Duck_Y_Motion_in = 10'd0;
                  end
                  else
                    Duck_Y_Motion_in = Duck_Y_Step;

                end
              // if(shot && ~flew_away) begin
              //   bird_shot = 1'b1;
              // end
          end
        // ---------------------------------------------------------------------------
        // Update the duck's position with its motion
        Duck_X_Pos_in = Duck_X_Pos + Duck_X_Motion;
        Duck_Y_Pos_in = Duck_Y_Pos + Duck_Y_Motion;
      end

      else if(frame_clk_rising_edge && state == 3'b100)
        begin
          counter2_in = counter2 + 10'd1;
          Duck_X_Motion_in = 10'd0;

          // This puts duck shot on for 10 counts, then switches to duck ded
          if(counter2_in <= 10'd15)
            begin
              which_duck_in = 3'b011;
              Duck_Y_Motion_in = 10'd0;
            end
          else
            begin
              Duck_Y_Motion_in = 10'd3;
              which_duck_in = 3'b100;
            end
          // ---------------------------------------------------------------------------
          // This switches between the left and right ded duck
          if( (counter2_in > 10'd15) && (counter2_in % 10'd10 == 0))
            begin
              if(facing == 10'd64)
                facing_in = 10'd0;
              else
                facing_in = 10'd64;
            end
          // when the duck reaches the Y max, it will send the duck_ded_done signal to move onto a new duck, and stop duck from moving
          if( Duck_Y_Pos >= Duck_Y_Max )
            begin
              Duck_Y_Motion_in = 10'd0;
              duck_ded_done = 1'b1;
            end
          // Update the duck's position with its motion
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


// always_comb begin
//
//     if ((DistX < Duck_X_Size) && (DistY < Duck_Y_Size))
//       is_duck = 1'b1;
//     else
//       is_duck = 1'b0;
//
// end
int DistXi, DistYi, Sizei;
assign DistXi = DrawX - Duck_X_Pos;
assign DistYi = DrawY - Duck_Y_Pos;
assign Sizei = 10'd32;
always_comb begin
    if ( ( DistXi*DistXi + DistYi*DistYi) <= (Sizei*Sizei) )
        is_duck = 1'b1;
    else
        is_duck = 1'b0;
    /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while
       the single line is quite powerful descriptively, it causes the synthesis tool to use up three
       of the 12 available multipliers on the chip! */
end

endmodule
