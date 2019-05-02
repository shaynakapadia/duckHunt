module sort(
        input Clk,
        input [2:0]state,

        output sort_done;
  );
logic sort_done;
logic [1:0] read_address, write_address;
logic [31:0] temp [0:2];
logic [31:0] score, sore_out;
int counter_in;
logic [31:0] score1, score2, score3;

hsRAM hs(.Clk(), .data_In(score), .write_address(write_address),
 .read_address(read_address), .we(we), .data_Out(score_out));

// assign [31:0] score = 32'b0;
// assign [31:0] score_out = 32'b0;
// assign [31:0] score1 = 32'b0;
// assign [31:0] score2 = 32'b0;
// assign [31:0] score3 = 32'b0;
// assign [31:0] temp[0] = 32'b0;
// assign [31:0] temp[1] = 32'b0;
// assign [31:0] temp[2] = 32'b0;
// assign we = 1'b0;
// assign sort_done = 1'b0;
// assign read_address = 2'b11;
// assign write_address = 2'b11;


always @ (posedge Clk ) begin
  if (state != 3'b011) begin
      counter <= 0;
  end
  counter <= counter_in;
end
always_comb begin
/*Initializations done here */
  [31:0] score = 32'b0;
  [31:0] score_out = 32'b0;
  [31:0] score1 = 32'b0;
  [31:0] score2 = 32'b0;
  [31:0] score3 = 32'b0;
  [31:0] temp[0] = 32'b0;
  [31:0] temp[1] = 32'b0;
  [31:0] temp[2] = 32'b0;
  we = 1'b0;
  sort_done = 1'b0;
  read_address = 2'b11;
  write_address = 2'b11;
/* Set counter_in */
  counter_in = counter + 1;

/* Reading the scores in */
  case (counter_in)
    6'd2:
    begin
      read_address = 3'd0;
      score1 = score_out;
    end
    6'd10:
    begin
      read_address = 3'd1;
      score2 = score_out;
    end
    6'd20:
    begin
      read_address = 3'd2;
      score3 = score_out;
    end
  endcase

/* Logic to check where the scores will go */

  if (counter_in > 30)
    begin
      if(score3 > score2)
        begin
          if (score3 > score1)
          begin
            temp[0] = score3;
            temp[1] = score1;
            temp[2] = score2;
          end
          else
          begin
            temp[0] = score1;
            temp[1] = score3;
            temp[2] = score2;
          end
        end
      else
        begin
          temp[0] = score1;
          temp[1] = score2;
          temp[2] = score3;
        end
    end
/* Putting scores in the right order back into highscores.txt */
  else if(counter_in == 50)
    begin
      score = temp[0];
      write_address = 2'd0;
      we = 1'b1;
    end
  else if (counter_in == 60)
    begin
      score = temp[1];
      write_address = 2'd1;
      we = 1'b1;
    end
  else if (counter_in == 70)
    begin
      score = temp[2];
      write_address = 2'd2;
      we = 1'b1;
    end
  else if (counter_in == 80) begin
    sort_done = 1'b1;
  end
end

endmodule
