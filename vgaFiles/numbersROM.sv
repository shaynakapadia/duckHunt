
module  numberROM(
									input [11:0] read_address,
									input Clk,
									output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 2,560 addresses (needs 11 bits to address)
logic [3:0] mem [0:2559];

initial
begin
	 $readmemh("numbers.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
