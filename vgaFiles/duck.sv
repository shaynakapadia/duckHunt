module  duck( input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_duck,             // Whether current pixel belongs to Duck or background
               output logic  duck_dead           //checks if duck is dead
               output logic [18:0] duck_center    // the location of the center of the duck
              );

logic [9:0] Duck_X_Pos, Duck_X_Motion, Duck_Y_Pos, Duck_Y_Motion;
logic [9:0] Duck_X_Pos_in, Duck_X_Motion_in, Duck_Y_Pos_in, Duck_Y_Motion_in;

parameter [9:0] Duck_X_Center = 10'd320;  // Center position on the X axis
parameter [9:0] Duck_Y_Center = 10'd240;  // Center position on the Y axis
// parameter [9:0] Duck_X_Min = 10'd0;       // Leftmost point on the X axis
// parameter [9:0] Duck_X_Max = 10'd639;     // Rightmost point on the X axis
// parameter [9:0] Duck_Y_Min = 10'd0;       // Topmost point on the Y axis
// parameter [9:0] Duck_Y_Max = 10'd479;     // Bottommost point on the Y axis
// parameter [9:0] Duck_X_Step = 10'd1;      // Step size on the X axis
// parameter [9:0] Duck_Y_Step = 10'd1;      // Step size on the Y axis
parameter [9:0] Duck_Size = 10'd4;        // Duck size

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
        Duck_X_Pos <= Duck_X_Center;
        Duck_Y_Pos <= Duck_Y_Center;
    end
    else
    begin
        Duck_X_Pos <= Duck_X_Pos_in;
        Duck_Y_Pos <= Duck_Y_Pos_in;
        Duck_X_Motion <= Duck_X_Motion_in;
        Duck_Y_Motion <= Duck_Y_Motion_in;
    end
end

always_comb
begin
    // By default, keep motion and position unchanged
    Duck_X_Pos_in = Duck_X_Pos;
    Duck_Y_Pos_in = Duck_Y_Pos;
    Duck_X_Motion_in = Duck_X_Motion;
    Duck_Y_Motion_in = Duck_Y_Motion;

    // Update position and motion only at rising edge of frame clock
    if (frame_clk_rising_edge)
    begin

    end

end

// Compute whether the pixel corresponds to Duck or background
/* Since the multiplicants are required to be signed, we have to first cast them
   from logic to int (signed by default) before they are multiplied. */
int DistX, DistY, Size;
assign DistX = DrawX - Duck_X_Pos;
assign DistY = DrawY - Duck_Y_Pos;
assign Size = Duck_Size;
always_comb begin
    if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) )
        is_duck = 1'b1;
    else
        is_duck = 1'b0;
end


endmodule
