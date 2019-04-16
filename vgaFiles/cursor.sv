module  cursor( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [7:0]	 keycode,            // holds location of mouse cursor
               output logic  is_cursor             // Whether current pixel belongs to cursor or background
              );
endmodule
