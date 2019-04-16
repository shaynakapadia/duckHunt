/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
//DUCKDOWN
module  duckyROM(
									input [18:0] read_address,
									input Clk,

									output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:1139];

initial
begin
	 $readmemh("sprite_bytes/ducky.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
