module mux2_1 // nine to one mux
	(
						input [1:0] s,
						input [3:0] c0,
						input [3:0] c1,
						output logic [3:0] out
						);

always_comb
		begin
			case(s)
				2'b00 : out = 4'h0;
				2'b01 : out = c0;
				2'b10 : out = c1;
				default  : out = c0;
			endcase
		end
endmodule
