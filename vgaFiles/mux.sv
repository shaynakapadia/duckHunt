module mux16_1 // 16 to one mux
	(
						input AVL_CS,
						input [3:0] s,
						input [31:0] c0,
						input [31:0] c1,
						input [31:0] c2,
						input [31:0] c3,
						input [31:0] c4,
						input [31:0] c5,
						input [31:0] c6,
						input [31:0] c7,
						input [31:0] c8,
						input [31:0] c9,
						input [31:0] c10,
						input [31:0] c11,
						input [31:0] c12,
						input [31:0] c13,
						input [31:0] c14,
						input [31:0] c15,
						output logic [31:0] out
						);

always_comb begin
	if(1)
		begin
			case(s)
				4'b0000 : out = c0;
				4'b0001 : out = c1;
				4'b0010 : out = c2;
				4'b0011 : out = c3;
				4'b0100 : out = c4;
				4'b0101 : out = c5;
				4'b0110 : out = c6;
				4'b0111 : out = c7;
				4'b1000 : out = c8;
				4'b1001 : out = c9;
				4'b1010 : out = c10;
				4'b1011 : out = c11;
				4'b1100 : out = c12;
				4'b1101 : out = c13;
				4'b1110 : out = c14;
				4'b1111 : out = c15;
				default : out = 32'b0;
			endcase
	end
	else
		begin
			out = 32'b0;
		end
end
endmodule

module mux9_1 // nine to one mux
	(
						input [3:0] s,
						input [127:0] c0,
						input [127:0] c1,
						input [127:0] c2,
						input [127:0] c3,
						input [127:0] c4,
						input [127:0] c5,
						input [127:0] c6,
						input [127:0] c7,
						input [127:0] c8,
						output logic [127:0] out
						);

always_comb
		begin
			case(s)
				4'b1001 : out = c0;
				4'b1000 : out = c1;
				4'b0111 : out = c2;
				4'b0110 : out = c3;
				4'b0101 : out = c4;
				4'b0100 : out = c5;
				4'b0011 : out = c6;
				4'b0010 : out = c7;
				4'b0001 : out = c8;
				default : out = 128'b0;
			endcase
		end
endmodule

module mux4_1 // nine to one mux
	(
						input [1:0] s,
						input [31:0] c0,
						input [31:0] c1,
						input [31:0] c2,
						input [31:0] c3,
						output logic [31:0] out
						);

always_comb
		begin
			case(s)
				4'b0000 : out = c0;
				4'b0001 : out = c1;
				4'b0010 : out = c2;
				4'b0011 : out = c3;
				default : out = 32'b0;
			endcase
		end
endmodule
