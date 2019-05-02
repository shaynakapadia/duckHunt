module highscore(
  input Clk,
  input [31:0] score,
  input [2:0] state
  );

logic we;
logic[1:0] write_address, read_address;
logic[31:0] smallest_score;
assign read_address = 4'd9;

hsRAM hs(.Clk(), .data_In(score), .write_address(write_address),
 .read_address(), .we(we), .data_Out(smallest_score));

always_comb begin
  if (state == 3'b011) begin //State Done
    if (smallest_score[31:0] > score[31:0]) begin
      write_address = 2'd2;
      we = 1'b1;
    end
    else begin
      we = 1'b0;
      write_address = 2'b0;
    end
  end

end
endmodule
