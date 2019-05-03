module mux2_1 // nine to one mux
	(
						input s,
						input [31:0] c0,
						input [31:0] c1,
						output logic [31:0] out
						);

always_comb
		begin
			case(s)
				1'b0 : out = c0;
				1'b1 : out = c1;
				default  : out = 32'd0;
			endcase
		end
endmodule
