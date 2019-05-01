module dmux1_16(
                input [3:0] AVL_ADDR,
                input AVL_WRITE, AVL_CS,
                output logic Load_0, Load_1, Load_2, Load_3, Load_4, Load_5, Load_6, Load_7,
					 output logic Load_14);

always_comb begin

  Load_0 = 1'b0;
  Load_1 = 1'b0;
  Load_2 = 1'b0;
  Load_3 = 1'b0;
  Load_4 = 1'b0;
  Load_5 = 1'b0;
  Load_6 = 1'b0;
  Load_7 = 1'b0;
//  Load_8 = 1'b0;
//  Load_9 = 1'b0;
//  Load_10 = 1'b0;
//  Load_11 = 1'b0;
//  Load_12 = 1'b0;
//  Load_13 = 1'b0;
  Load_14 = 1'b0;
//  Load_15 = 1'b0;

  if(AVL_WRITE & AVL_CS) begin
    case(AVL_ADDR)

      4'b0000 : Load_0 = 1'b1;
      4'b0001 : Load_1 = 1'b1;
      4'b0010 : Load_2 = 1'b1;
      4'b0011 : Load_3 = 1'b1;
      4'b0100 : Load_4 = 1'b1;
      4'b0101 : Load_5 = 1'b1;
      4'b0110 : Load_6 = 1'b1;
      4'b0111 : Load_7 = 1'b1;
//		4'b1000 : Load_8 = 1'b1;
//    4'b1001 : Load_9 = 1'b1;
//    4'b1010 : Load_10 = 1'b1;
//    4'b1011 : Load_11 = 1'b1;
//    4'b1100 : Load_12 = 1'b1;
//    4'b1101 : Load_13 = 1'b1;
      4'b1110 : Load_14 = 1'b1;
//    4'b1111 : Load_15 = 1'b1;
		default : ;

    endcase
  end
end
endmodule


module dmux1_9(
                input [3:0] Round,
                output logic Load_0, Load_1, Load_2, Load_3, Load_4, Load_5, Load_6, Load_7, Load_8, Load_9, Load_10);

always_comb begin

  Load_0 = 1'b0;
  Load_1 = 1'b0;
  Load_2 = 1'b0;
  Load_3 = 1'b0;
  Load_4 = 1'b0;
  Load_5 = 1'b0;
  Load_6 = 1'b0;
  Load_7 = 1'b0;
  Load_8 = 1'b0;
  Load_9 = 1'b0;
  Load_10 = 1'b0;
	case(Round)
		4'b1010 : Load_0 = 1'b1;
		4'b1001 : Load_1 = 1'b1;
		4'b1000 : Load_2 = 1'b1;
		4'b0111 : Load_3 = 1'b1;
		4'b0110 : Load_4 = 1'b1;
		4'b0101 : Load_5 = 1'b1;
		4'b0100 : Load_6 = 1'b1;
		4'b0011 : Load_7 = 1'b1;
		4'b0010 : Load_8 = 1'b1;
		4'b0001 : Load_9 = 1'b1;
		4'b0000 : Load_10 = 1'b1;
		default : ;
	endcase
  end
endmodule
