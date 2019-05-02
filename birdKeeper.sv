module birdKeeper(
                    input flew_away, Clk, Reset,
                    input [2:0] state,
                    output logic no_birds_left,
                    output logic [31:0] num_birds
);

logic flew_away_edge, flew_away_sync_f, Load;
logic [31:0] D, Data_Out;

always @(posedge Clk) begin
    if (Reset) begin
        flew_away_sync_f <= 1'b0;
    end else begin
        flew_away_sync_f <= flew_away;
    end
end

assign flew_away_edge = flew_away & ~flew_away_sync_f; // Detects rising edge
assign num_birds = Data_Out;
assign D = Data_Out + 32'd1;

always_comb begin
  if(flew_away_edge)
    Load = 1'b1;
  else
    Load = 1'b0;
  if(Data_Out >= 32'd3)
    no_birds_left = 1'b1;
  else
    no_birds_left = 1'b0;
end
reg_32 birds(.*);
endmodule
