module score_display( input       Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					     input [2:0]	 state,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [31:0]  score,
               output logic [31:0] index1, index2, index3, index4,
               output logic  is_score,             // Whether current pixel belongs to Num or background
               output logic [11:0] score_addr
               );

logic [31:0] index5, index6, index7, index8, index9;

logic [9:0] Num_X_Pos = 10'd480;
logic [9:0] Num_Y_Pos = 10'd417;

logic [9:0] Sprite_X_Size = 10'd130;
logic [9:0] Score_X_Size = 10'd117;
logic [9:0] Num_X_Size = 10'd13;        // Num X size
logic [9:0] Num_Y_Size = 10'd16;        // Num Y size

int DistX, DistY, Size;
logic [31:0] addr;
assign DistX = DrawX - Num_X_Pos;
assign DistY = DrawY - Num_Y_Pos;

get_index one(   .value(score),   .mod(4'b0000), .index(index1));
get_index two(   .value(score),   .mod(4'b0001), .index(index2));
get_index three( .value(score),   .mod(4'b0010), .index(index3));
get_index four(  .value(score),   .mod(4'b0011), .index(index4));
get_index five(  .value(score),   .mod(4'b0100), .index(index5));
get_index six(   .value(score),   .mod(4'b0101), .index(index6));
get_index seven( .value(score),   .mod(4'b0110), .index(index7));
get_index eight( .value(score),   .mod(4'b0111), .index(index8));
get_index nine(  .value(score),   .mod(4'b1000), .index(index9));

always_comb begin
if(DistY <= 16 && DistY >=0) begin
  if( (DistX >= 0) && (DistX <= 12 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index9*Num_X_Size;
  else if( (DistX >= 13) && (DistX <= 25 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index8*Num_X_Size - 10'd13;
  else if( (DistX >= 26) && (DistX <= 38 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index7*Num_X_Size - 10'd26;
  else if( (DistX >= 39) && (DistX <= 51 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index6*Num_X_Size - 10'd39;
  else if( (DistX >= 52) && (DistX <= 64 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index5*Num_X_Size - 10'd52;
  else if( (DistX >= 65) && (DistX <= 77 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index4*Num_X_Size - 10'd65;
  else if( (DistX >= 78) && (DistX <= 90 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index3*Num_X_Size - 10'd78;
  else if( (DistX >= 91) && (DistX <= 103 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index2*Num_X_Size - 10'd91;
  else if( (DistX >= 104) && (DistX <= 116 ) )
    addr = (DistY)*(Sprite_X_Size) + DistX + index1*Num_X_Size - 10'd104;
  else
    addr =  32'h0;
end
else
  addr =   32'h0;
end

always_comb begin
	if(addr <= 32'h7ff)
		begin
			score_addr = addr[11:0];
 		end
  else if(addr[31] == 1'b1)
    begin
      score_addr = 12'h0;
    end
 	else
 		begin
 			score_addr = 12'h0;
    end
end

always_comb begin
   if((DistX < Score_X_Size) && (DistY < Num_Y_Size))
     is_score = 1'b1;
   else
     is_score = 1'b0;

end

endmodule
