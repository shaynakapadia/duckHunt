module  duckROM(
									input [15:0] read_address,
									input Clk,
									output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 40,960 addresses (needs 16 bits to address)
logic [3:0] mem [0:40959];

initial
begin
	 $readmemh("duck.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
