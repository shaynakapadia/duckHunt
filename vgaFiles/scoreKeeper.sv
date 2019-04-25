module scoreKeeper(
                    input bird_shot, Clk, Reset,
                    input [1:0] state,
                    output logic [31:0] score
);

logic bird_shot_edge, bird_shot_sync_f, Load;
logic [31:0] D, Data_Out;

always @(posedge Clk) begin
    if (Reset) begin
        bird_shot_sync_f <= 1'b0;
    end else begin
        bird_shot_sync_f <= bird_shot;
    end
end

assign bird_shot_edge = bird_shot & ~bird_shot_sync_f; // Detects rising edge
assign score = Data_Out;
assign D = Data_Out + 32'd50;

always_comb begin
  if(bird_shot_edge)
    Load = 1'b1;
  else
    Load = 1'b0;
end
reg_32 scorecount(.*);
endmodule
