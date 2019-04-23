module random(
  input Clk,
  input Reset,

  output logic [9:0] data
);

logic [9:0] data_next;

always @* begin
  data_next[9] = data[9]^data[1];
  data_next[8] = data[8]^data[0];
  data_next[7] = data[7]^data_next[4];
  data_next[6] = data[6]^data_next[3];
  data_next[5] = data[5]^data_next[2];
  data_next[4] = data[4]^data[1];
  data_next[3] = data[3]^data[0];
  data_next[2] = data[2]^data_next[4];
  data_next[1] = data[1]^data_next[3];
  data_next[0] = data[0]^data_next[2];
end

always @(posedge Clk or negedge Reset)
  if(!Reset)
    data <= 5'h1f;
  else
    data <= data_next;

endmodule
