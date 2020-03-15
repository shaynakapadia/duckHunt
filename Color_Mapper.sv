//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (
							  input 					Clk,
							  input           is_duck, is_dog, is_score, is_cursor, is_grass, is_numshot, is_numbirds, is_gameover,
								input 					shot, num_shots,
								input 			 [2:0] state,
							  input        [9:0] DrawX, DrawY,       // Current pixel coordinates
						    input        [15:0] duck_addr,
								input 			 [13:0] dog_addr,
								input 			 [11:0] score_addr, numbirds_addr, numshot_addr,
								input 			 [16:0] grass_addr, gameover_addr,
							  output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
	 logic [7:0] Red, Green, Blue;
	 logic [18:0] back_addr, start_addr;
	 logic [3:0] index, duck_index, dog_index, score_index, grass_index, back_index, start_index, numbirds_index, numshot_index, over_index;
	 logic [23:0] color, dog_color, duck_color, score_color, grass_color, back_color, start_color, numbirds_color, numshot_color, over_color;

    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
		// assign duck_color = 24'h00ffff;
		// assign grass_color = 24'hF442EE;
		// assign score_color = 24'hFFF0F0;
		// assign dog_color = 24'hF0F0F0;
		// assign dog_color  = 24'h0000ff;
		assign back_addr = (DrawY*(10'd640)) + DrawX;

		dogROM dog(.Clk(Clk), .read_address(dog_addr), .data_Out(dog_index));
		duckROM duck(.Clk(Clk), .read_address(duck_addr), .data_Out(duck_index));

		numbersROM score_nums(.Clk(Clk), .read_address(score_addr), .data_Out(score_index));
		numbersROM bird_nums(.Clk(Clk), .read_address(numbirds_addr), .data_Out(numbirds_index));
		numbersROM shot_nums(.Clk(Clk), .read_address(numshot_addr), .data_Out(numshot_index));

		grassROM grass(.Clk(Clk), .read_address(grass_addr), .data_Out(grass_index));
		backgroundROM background(.Clk(Clk), .read_address(back_addr), .data_Out(back_index));
		startscreenROM start(.Clk(Clk), .read_address(back_addr), .data_Out(start_index));
		gameoverROM gameOver(.Clk(Clk), .read_address(gameover_addr), .data_Out(over_index));


		paletteROM dogPalette(.Clk(Clk), .read_address(dog_index), .data_Out(dog_color));
		paletteROM duckPalette(.Clk(Clk), .read_address(duck_index), .data_Out(duck_color));

		paletteROM numsScorePalette(.Clk(Clk), .read_address(score_index), .data_Out(score_color));
		paletteROM numsBirdsPalette(.Clk(Clk), .read_address(numbirds_index), .data_Out(numbirds_color));
		paletteROM numsShotsPalette(.Clk(Clk), .read_address(numshot_index), .data_Out(numshot_color));

		paletteROM grassPalette(.Clk(Clk), .read_address(grass_index), .data_Out(grass_color));
		paletteROM backPalette(.Clk(Clk), .read_address(back_index), .data_Out(back_color));
		paletteROM startPalette(.Clk(Clk), .read_address(start_index), .data_Out(start_color));
		paletteROM overPalette(.Clk(Clk), .read_address(over_index), .data_Out(over_color));

    // Assign color based on is_ball signal
    always_comb begin
			if(state == 3'b000) begin
				Red = start_color[23:16];
				Green = start_color[15:8];
				Blue = start_color[7:0];
				end
			else if( (state == 3'b010) || (state == 3'b001) || (state == 3'b100) || (state == 3'b101) || (state == 3'b110) ) begin
				//---------------------------------------------------------------------------------------------------
					// always display the cursor first
					if(is_cursor) begin
						if(shot && num_shots <= 6) begin
							Red = 8'h00;
							Green = 8'h00;
							Blue = 8'h00;
						end
						else begin
							Red = 8'hff;
							Green = 8'hff;
							Blue = 8'hff;
						end
					end
			 //---------------------------------------------------------------------------------------------------
					// if only is grass is on and it is not the background, display the grass
					else if(is_grass && (grass_color != 24'hF442EE) && ~is_duck && ~is_dog) begin
						Red = grass_color[23:16];
						Green = grass_color[15:8];
						Blue = grass_color[7:0];
					end
					//---------------------------------------------------------------------------------------------------
					// if both the grass and the dog are on
					else if(is_grass && is_dog) begin
						// pring grass over dog
						if( (dog_color != 24'hF442EE) && (grass_color != 24'hF442EE) ) begin
							Red = grass_color[23:16];
							Green = grass_color[15:8];
							Blue = grass_color[7:0];
						end
						// if its the dog background, print the grass
						else if(dog_color == 24'hF442EE && (grass_color != 24'hF442EE)) begin
							Red = grass_color[23:16];
							Green = grass_color[15:8];
							Blue = grass_color[7:0];
						end
						//if its the grass background, print the dog
						else if(dog_color != 24'hF442EE && (grass_color == 24'hF442EE)) begin
							Red = dog_color[23:16];
							Green = dog_color[15:8];
							Blue = dog_color[7:0];
						end
						// if they are both background, print the background
						else begin
							Red = back_color[23:16];
							Green = back_color[15:8];
							Blue = back_color[7:0];
						end
					end
					//---------------------------------------------------------------------------------------------------
					else if(is_grass && is_duck) begin
						// pring grass over duck
						if( (duck_color != 24'hF442EE) && (grass_color != 24'hF442EE) ) begin
							Red = grass_color[23:16];
							Green = grass_color[15:8];
							Blue = grass_color[7:0];
						end
						// if its the duck background, print the grass
						else if(duck_color == 24'hF442EE && (grass_color != 24'hF442EE)) begin
							Red = grass_color[23:16];
							Green = grass_color[15:8];
							Blue = grass_color[7:0];
						end
						//if its the grass background, print the duck
						else if(duck_color != 24'hF442EE && (grass_color == 24'hF442EE)) begin
							Red = duck_color[23:16];
							Green = duck_color[15:8];
							Blue = duck_color[7:0];
						end
						// if they are both background, print the background
						else begin
							Red = back_color[23:16];
							Green = back_color[15:8];
							Blue = back_color[7:0];
						end
					end
					//---------------------------------------------------------------------------------------------------
					else if(is_duck && duck_color != 24'hF442EE) begin
						Red = duck_color[23:16];
					  Green = duck_color[15:8];
					  Blue = duck_color[7:0];
					end
					//---------------------------------------------------------------------------------------------------
					else if(is_dog && dog_color != 24'hF442EE) begin
						Red = dog_color[23:16];
					  Green = dog_color[15:8];
					  Blue = dog_color[7:0];
					end
					//---------------------------------------------------------------------------------------------------
					else if(is_numbirds && (numbirds_color != 24'hF442EE)) begin
							Red = 24'hffffff;
							Green = 24'hffffff;
							Blue = 24'hffffff;
					end
				  else if(is_score && (score_color != 24'hF442EE)) begin
							Red = 24'hffffff;
							Green = 24'hffffff;
							Blue = 24'hffffff;
					end
					else if(is_numshot && (numshot_color != 24'hF442EE)) begin
							Red = 24'hffffff;
							Green = 24'hffffff;
							Blue = 24'hffffff;
					end
					//---------------------------------------------------------------------------------------------------
					else begin
						Red = back_color[23:16];
						Green = back_color[15:8];
						Blue = back_color[7:0];
					end
					//---------------------------------------------------------------------------------------------------
				end
		else if(state == 3'b011) begin
			if(is_gameover && (over_color != 24'hF442EE) ) begin
				Red = over_color[23:16];
				Green = over_color[15:8];
				Blue = over_color[7:0];
			end
			else begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
			end
		end
		else begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
			end

    end

endmodule

// else begin
// 	if ( (is_duck && ~is_dog) &&  duck_color != 24'hF442EE) begin
//        Red = duck_color[23:16];
//        Green = duck_color[15:8];
//        Blue = duck_color[7:0];
//      end
// 	else if ((~is_duck && is_dog) && dog_color != 24'hF442EE) begin
// 			 	Red = dog_color[23:16];
// 			 	Green = dog_color[15:8];
// 			 	Blue = dog_color[7:0];
// 		  end
// 	else if ((is_duck && is_dog))
// 		begin
// 			if ((duck_color == 24'hF442EE) && (dog_color == 24'hF442EE) ) begin
// 					Red = 8'h00;
// 					Green = 8'h00;
// 					Blue = 8'hf0;
// 				end
// 			else if(dog_color == 24'hF442EE) begin
// 					Red = duck_color[23:16];
//           Green = duck_color[15:8];
//           Blue = duck_color[7:0];
// 				end
// 			else begin
// 					Red = dog_color[23:16];
// 					Green = dog_color[15:8];
// 					Blue = dog_color[7:0];
// 				end
// 		end
