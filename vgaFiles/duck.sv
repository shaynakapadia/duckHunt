module  duck( input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_duck,             // Whether current pixel belongs to ball or background
               output logic  duck_dead           //checks if duck is dead
               output logic [18:0] duck_center    // the location of the center of the duck
              );


parameter [9:0] Duck_X_Center = 10'd320;  // Center position on the X axis
parameter [9:0] Duck_Y_Center = 10'd240;  // Center position on the Y axis
parameter [9:0] Duck_X_Min = 10'd0;       // Leftmost point on the X axis
parameter [9:0] Duck_X_Max = 10'd639;     // Rightmost point on the X axis
parameter [9:0] Duck_Y_Min = 10'd0;       // Topmost point on the Y axis
parameter [9:0] Duck_Y_Max = 10'd479;     // Bottommost point on the Y axis
parameter [9:0] Duck_X_Step = 10'd1;      // Step size on the X axis
parameter [9:0] Duck_Y_Step = 10'd1;      // Step size on the Y axis
parameter [9:0] Duck_Size = 10'd4;        // Ball size



endmodule
