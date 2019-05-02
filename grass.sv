//-------------------------------------------------------------------------
//    grass.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  grass ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_grass,             // Whether current pixel belongs to grass or background
               output logic [13:0] grass_addr
              );

    parameter [9:0] grass_Size = 10'd640;        // grass size
    grass_Y_Pos = 10'd245;
    grass_X_Pos = 10'd0;
    // Compute whether the pixel corresponds to grass or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - grass_X_Pos;
    assign DistY = DrawY - grass_Y_Pos;
    assign Size = grass_Size;

    assign addr =  (DistY)*(grass_Size) + DistX;

    always_comb begin
    	if(addr <= 32'hffff)
    		begin
    			grass_addr = addr[17:0];
    		end
      else if(addr[31] == 1'b1)
        begin
          grass_addr = 16'h0;
        end
    	else
    		begin
    			grass_addr = 16'h0;
    		end
    end

    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) )
            is_grass = 1'b1;
        else
            is_grass = 1'b0;
        /* The grass's (pixelated) circle is generated using the standard circle formula.  Note that while
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end

endmodule
