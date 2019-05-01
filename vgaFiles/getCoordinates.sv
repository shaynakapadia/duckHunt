module getCoordinates(
  input Clk,
  input [35:0] GPIO,
  output [8:0] cursor_x,
  output [8:0] cursor_y,
  output shot
  );
  always @(posedge Clk)
    begin
      shot = GPIO[9];
    end
  always @(negedge GPIO[10])
    begin
      cursor_x = GPIO[8:0];
    end
  always @ (posedge GPIO[10])
   begin
     cursor_y = GPIO[8:0];
   end
endmodule
