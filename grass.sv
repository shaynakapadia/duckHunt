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
               output logic [16:0] grass_addr
              );

    parameter [9:0] grass_X_Size = 10'd640;        // grass size
    // Compute whether the pixel corresponds to grass or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size, addr;
    assign DistX = DrawX - 10'd0;
    assign DistY = DrawY - 10'd240;
    assign Size = grass_X_Size;

    assign addr =  (DistY)*(grass_X_Size) + DistX;

    always_comb begin
    	if(addr <= 32'h1ffff)
    		begin
    			grass_addr = addr[16:0];
    		end
      else if(addr[31] == 1'b1)
        begin
          grass_addr = 17'h0;
        end
    	else
    		begin
    			grass_addr = 17'h0;
    		end
    end

    always_comb begin
        if ( (DistX < 10'd640) && (DistY < 10'd234) )
            is_grass = 1'b1;
        else
            is_grass = 1'b0;
    end

endmodule
