
module  startscreenROM(
									input [18:0] read_address,
									input Clk,
									output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 307,200 addresses (needs 19 bits to address)
logic [3:0] mem [0:307199];

initial
begin
	 $readmemh("start_screen.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
