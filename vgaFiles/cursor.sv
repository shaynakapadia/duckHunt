module  cursor(input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_cursor           // Whether current pixel belongs to cursor or background
              );

    parameter [9:0] Cursor_X_Center = 10'd100;  // Center position on the X axis
    parameter [9:0] Cursor_Y_Center = 10'd100;  // Center position on the Y axis
    parameter [9:0] Cursor_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Cursor_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Cursor_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Cursor_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Cursor_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Cursor_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Cursor_Size = 10'd2;        // Cursor size

    logic [9:0] Cursor_X_Pos, Cursor_X_Motion, Cursor_Y_Pos, Cursor_Y_Motion;
    logic [9:0] Cursor_X_Pos_in, Cursor_X_Motion_in, Cursor_Y_Pos_in, Cursor_Y_Motion_in;

    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
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
            Cursor_X_Pos <= Cursor_X_Center;
            Cursor_Y_Pos <= Cursor_Y_Center;
            Cursor_X_Motion <= 10'd0;
            Cursor_Y_Motion <= 10'd0;
        end
        else
        begin
            Cursor_X_Pos <= Cursor_X_Pos_in;
            Cursor_Y_Pos <= Cursor_Y_Pos_in;
            Cursor_X_Motion <= Cursor_X_Motion_in;
            Cursor_Y_Motion <= Cursor_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////

    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Cursor_X_Pos_in = Cursor_X_Pos;
        Cursor_Y_Pos_in = Cursor_Y_Pos;
        Cursor_X_Motion_in = Cursor_X_Motion;
        Cursor_Y_Motion_in = Cursor_Y_Motion;

       // Update position and motion only at rising edge of frame clock
       //  if (frame_clk_rising_edge)
       //  begin
       //
       //  end

    end

    // Compute whether the pixel corresponds to cursor or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Cursor_X_Pos;
    assign DistY = DrawY - Cursor_Y_Pos;
    assign Size = Cursor_Size;
    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) )
            is_cursor = 1'b1;
        else
            is_cursor = 1'b0;
        /* The cursor's (pixelated) circle is generated using the standard circle formula.  Note that while
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end

endmodule
