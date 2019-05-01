module getCoordinates(
  input clk,
  input [35:0] GPIO,
  output [10:0] cursor_x,
  output [10:0] cursor_y,
  output shot
  );
  always @(posedge clk)
    begin
      shot = GPIO[9];
    end
  always @(posedge GPIO[10])
    begin
      cursor_x = GPIO[8:0]
    end
  always @ (negedge GPIO[10])
   begin
     cursor_y = GPIO[8:0]
   end
endmodule
