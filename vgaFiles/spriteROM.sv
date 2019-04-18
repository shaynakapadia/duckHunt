/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
//DUCKDOWN
module  spriteROM(
									input [18:0] read_address,
									input Clk,
									output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 824,320 addresses
logic [3:0] mem [0:122879];

initial
begin
	 $readmemh("spritesheetFINAL.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
