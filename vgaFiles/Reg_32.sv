
module reg_32a(input  logic CLK, RESET, Load,
				  input  logic [3:0] AVL_BYTE_EN,
              input  logic [31:0]  D,
              output logic [31:0]  Data_Out);

    always_ff @ (posedge CLK)
    begin
	 	 if (RESET) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			begin
				Data_Out <= 32'h0;
			end
		 else if (Load)
			begin
				Data_Out[31:0] <= D[31:0];
//				case(AVL_BYTE_EN)
//					4'b1111 : Data_Out <= D ;
//					4'b1100 : Data_Out[31:16] <= D[31:16] ;
//					4'b0011 : Data_Out[15:0] <= D[15:0] ;
//					4'b1000 : Data_Out[31:24] <= D[31:24] ;
//					4'b0100 : Data_Out[23:16] <= D[23:16] ;
//					4'b0010 : Data_Out[15:8] <= D[15:8] ;
//					4'b0001 : Data_Out[7:0] <= D[7:0] ;
//					default : Data_Out <= D;
//				endcase
			end
    end

endmodule


module reg_32temp(input  logic CLK, RESET, Load,
	 						input [1:0] word,
              input  logic [31:0]  D,
              output logic [127:0]  Data_Out);

    always_ff @ (posedge CLK)
    begin
	 	 if (RESET) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			begin
				Data_Out <= 32'h0;
			end
		 else if (Load)
			begin
				case(word)
						2'b00   :   Data_Out[31:0] <= D;
						2'b01   :   Data_Out[63:32] <= D;
						2'b10   :	Data_Out[95:64] <= D;
						2'b11   :   Data_Out[127:96] <= D;
						default :   Data_Out[127:0] <= Data_Out[127:0];
				endcase
			end
    end

endmodule

module reg_128temp(input  logic CLK, RESET, Load,
              input  logic [127:0]  D,
              output logic [127:0]  Data_Out);

    always_ff @ (posedge CLK)
    begin
	 	 if (RESET) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			begin
				Data_Out <= 128'h0;
			end
		 else if (Load)
			begin
				 Data_Out[127:0] <= D[127:0];
			end
    end

endmodule
