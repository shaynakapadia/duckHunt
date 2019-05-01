module get_index( input [31:0] value,
                  input [3:0] mod,
                  output [31:0] index
  );


  always_comb begin
    if(mod == 3'b000)
      index = value % 10;
    else if(mod == 4'b0001)
      index = (value / 10) % 10;
    else if(mod == 4'b0010)
      index = (value / 100) % 10;
    else if(mod == 4'b0011)
      index = (value / 1000) % 10;
    else if(mod == 4'b0100)
      index = (value / 10000) % 10;
    else if(mod == 4'b0101)
      index = (value / 100000) % 10;
    else if(mod == 4'b0110)
      index = (value / 1000000) % 10;
    else if(mod == 4'b0111)
      index = (value / 10000000) % 10;
    else if(mod == 4'b1000)
      index = (value / 100000000) % 10;
    else
      index = value;
  end
endmodule
