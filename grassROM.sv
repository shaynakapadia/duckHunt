module  grassROM(
									input [16:0] read_address,
									input Clk,
									output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 76,800 addresses (needs 16 bits to address)
logic [3:0] mem [0:76799];

initial
begin
	 $readmemh("grass.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
