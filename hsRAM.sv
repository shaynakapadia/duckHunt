module hsRAM(
    input [31:0] data_In,
		input [1:0] write_address, read_address,
		input we, Clk,
		output logic [31:0] data_Out
);

// mem has width of 32 bits and a total of 10 addresses
logic [31:0] mem [0:2];

initial
begin
	 $readmemh("sprite_bytes/highscores.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule

);
