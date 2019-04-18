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
							  input        [9:0] DrawX, DrawY,       // Current pixel coordinates
						     input        [18:0] duck_addr,
							  output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );

    logic [7:0] Red, Green, Blue;
	 logic [3:0] index;
	 logic [23:0] duck_color;
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

		spriteROM duck(.Clk(Clk), .read_address(duck_addr), .data_Out(index));
		paletteROM palette(.Clk(Clk), .read_address(index), .data_Out(duck_color));


    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_duck == 1'b1 && duck_color != 24'hff0000)
          begin
            Red = duck_color[23:16];
            Green = duck_color[15:8];
            Blue = duck_color[7:0];
          end
        else
          begin
              // Background with nice color gradient
              Red = 8'h00;
              Green = 8'h00;
              Blue = 8'hff;
          end
    end

		
endmodule
