module shotKeeper(
                    input shot, Clk, Reset,
                    input [2:0] state,
                    output logic no_shots_left,
                    output logic [31:0] num_shots
);

logic shot_edge, shot_sync_f, Load;
logic [31:0] D, Data_Out;

always @(posedge Clk) begin
    if (Reset) begin
        shot_sync_f <= 1'b0;
    end else begin
        shot_sync_f <= shot;
    end
end

assign shot_edge = shot & ~shot_sync_f; // Detects rising edge
assign num_shots = Data_Out;
assign D = Data_Out + 32'd1;

always_comb begin
  if(shot_edge && (Data_Out < 32'd100))
    Load = 1'b1;
  else
    Load = 1'b0;
  if(Data_Out >= 32'd100)
    no_shots_left = 1'b1;
  else
    no_shots_left = 1'b0;
end
reg_32 shots(.*);
endmodule
