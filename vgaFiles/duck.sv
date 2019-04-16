module  duck( input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_duck,             // Whether current pixel belongs to Duck or background
               output logic [18:0] read_address,
               output logic [23:0] duck_color
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
parameter [9:0] Duck_X_Size = 10'd19;        // Duck X size
parameter [9:0] Duck_Y_Size = 10'd15;        // Duck X size

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
        Duck_X_Motion <= 10'd0;
        Duck_Y_Motion <= 10'd0;
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
      // for now keep duck stable, do not change motion
    end

end

// Compute whether the pixel corresponds to Duck or background
/* Since the multiplicants are required to be signed, we have to first cast them
   from logic to int (signed by default) before they are multiplied. */
int DistX, DistY, Size;

assign DistX = DrawX - Duck_X_Pos;
assign DistY = DrawY - Duck_Y_Pos;
assign Size = Duck_Size;

assign read_address =  19'd550 + (DistY*19'd38) + DistX;
duckROM duckdown(.*, .data_Out(duck_color));

always_comb begin
    is_duck = 1'b0;
    if (DistX <= Duck_X_Size)
    begin
      if(DistY <= Duck_Y_Size)
      begin
        if(duck_color != 24'h00ff00)
        begin
          is_duck = 1'b1;
        end
      end
    end
end


endmodule
