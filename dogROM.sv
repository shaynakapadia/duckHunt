
module  dogROM(
									input [13:0] read_address,
									input Clk,
									output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 8,192 addresses (needs 13 bits to address)
logic [3:0] mem [0:8191];

initial
begin
	 $readmemh("dog.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
