//*********************************
// random module by Uma and Shayna <3

module random(
					input Clk, Reset, 
					input [31:0] seed,
					input [31:0] max, min,
					output logic [31:0] data
);

logic [31:0] data_next;

always_comb begin
data_next[0]  = !data[0];
data_next[1]  = ~&{data[2] ^ seed[1]};
data_next[2]  = !data[3];
data_next[3]  = !data[4]  ^  seed[25];
data_next[4]  = !data[5]  ^  seed[8];
data_next[5]  = !data[6]  ^  data[4];
data_next[6]  = !data[7]  ^  data[17];
data_next[7]  = !data[8];
data_next[8]  = !data[9]  ^  data[10];
data_next[9]  = !data[10] ^  data[31];
data_next[10] = !data[11];
data_next[11] = !data[12];
data_next[12] = !data[13] ^  data[10];
data_next[13] = !data[14];
data_next[14] = !data[15] ^  data[7];
data_next[15] = !data[16] ^  data[23];
data_next[16] = !data[17] ^  data[6];
data_next[17] = !data[18];
data_next[18] = !data[19];
data_next[19] = !data[20] ^  data[9];
data_next[20] = !data[21] ^  data[12];
data_next[21] = !data[22];
data_next[22] = !data[23];
data_next[23] = !data[24];
data_next[24] = !data[25];
data_next[25] = !data[26];
data_next[26] = !data[27] ^  data[2];
data_next[27] = !data[28];
data_next[28] = !data[29];
data_next[29] = !data[30];
data_next[30] = !data[31];
data_next[31] = !data[1];


if(data_next > max)
begin
data_next = data_next % max;
end

if(data_next < min)
begin
data_next = min + data_next;
end



end

always @(posedge Clk)
  if(Reset)
    data <= 32'hffffffff;
  else
    data <= data_next;

endmodule
