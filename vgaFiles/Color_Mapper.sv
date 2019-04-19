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
							  input           is_duck,
								input 					is_dog,
								input 			 [1:0] state,
							  input        [9:0] DrawX, DrawY,       // Current pixel coordinates
						    input        [15:0] duck_addr,
								input 			 [13:0] dog_addr,
							  output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );

	 logic is_background;
	 logic [7:0] Red, Green, Blue;
	 logic [3:0] index, duck_index, dog_index;
	 logic [23:0] color, dog_color, duck_color;
	 // logic [1:0] is_what;
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

		//assign is_what = {is_duck, is_dog};

		dogROM dog(.Clk(Clk), .read_address(dog_addr), .data_Out(dog_index));
		duckROM duck(.Clk(Clk), .read_address(duck_addr), .data_Out(duck_index));


		//mux2_1 indexMUX( .s(is_what), .c0(dog_index), .c1(duck_index), .out(index));

		paletteROM dogPalette(.Clk(Clk), .read_address(dog_index), .data_Out(dog_color));
		paletteROM duckPalette(.Clk(Clk), .read_address(duck_index), .data_Out(duck_color));

    // Assign color based on is_ball signal
    always_comb
    begin
			case(state)
				2'b00: begin
									Red = 8'h00;
									Green = 8'h00;
									Blue = 8'hf0;
							 end
				2'b01:
							begin
				//---------------------------------------------------------------------------------------------------
					// state GAME
				 				if ( (is_duck && ~is_dog) &&  duck_color != 24'hF442EE)
					        begin
					          Red = duck_color[23:16];
					          Green = duck_color[15:8];
					          Blue = duck_color[7:0];
					        end
								else if ((~is_duck && is_dog) && dog_color != 24'hF442EE)
									begin
					 				 	Red = dog_color[23:16];
					 				 	Green = dog_color[15:8];
					 				 	Blue = dog_color[7:0];
					 			  end
								else if ((is_duck && is_dog))
									begin
										if ((duck_color == 24'hF442EE) && (dog_color == 24'hF442EE) )
											begin
												Red = 8'h00;
												Green = 8'h00;
												Blue = 8'hf0;
											end
										else if(dog_color == 24'hF442EE)
											begin
												Red = duck_color[23:16];
							          Green = duck_color[15:8];
							          Blue = duck_color[7:0];
											end
										else
											begin
												Red = dog_color[23:16];
												Green = dog_color[15:8];
												Blue = dog_color[7:0];
											end
									end
				        else
				          begin
				              // Background with nice color gradient
				              Red = 8'h00;
				              Green = 8'h00;
				              Blue = 8'hf0;
				          end
			//---------------------------------------------------------------------------------------------------
						end
		2'b10:
			begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
			end
		default: begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'h00;
					end
	  endcase
    end


endmodule
