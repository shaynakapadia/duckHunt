module reg_20(input  logic Clk, Reset, Load,
              input  logic [19:0]  D,
              output logic [19:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			begin
				Data_Out <= 19'h0;
			end
		 else if (Load)
			begin
				 Data_Out[19:0] <= D[19:0];
			end
    end

endmodule

module reg_2(input  logic Clk, Reset, Load,
              input  logic [1:0]  D,
              output logic [1:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			begin
				Data_Out <= 2'h0;
			end
		 else if (Load)
			begin
				 Data_Out[1:0] <= D[1:0];
			end
    end

endmodule
