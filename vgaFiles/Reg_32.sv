module reg_32(input  logic Clk, Reset, Load,
              input  logic [31:0]  D,
              output logic [31:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			begin
				Data_Out <= 31'h0;
			end
		 else if (Load)
			begin
				 Data_Out[31:0] <= D[31:0];
			end
    end

endmodule
