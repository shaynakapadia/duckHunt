/************************************************************************
Core Game control logic
Tulika Gupta and Shayna Kapadia, Spring 2019
Duck Hunt
************************************************************************/

module Control (
    input  logic Clk,
    input  logic Reset,
    input  logic start,
    input  logic flew_away,
    input  logic bird_shot,
    input  logic shot,
    // output int   score,
    // output logic release_bird,
    // output logic game_over,
    output [1:0] state
);



logic [19:0] score_in, score_out;
logic [1:0]  shots_in, shots_out;
logic [1:0]  get_in, get_out;
logic loadscore, loadshots, loadget;

reg_20 score(.*, .Load(loadscore), .D(score_in), .Data_Out(score_out));
reg_2  shots(.*, .Load(loadshots), .D(shots_in), .Data_Out(shots_out));
reg_2  get_aways(.*, .Load(loadget), .D(get_in), .Data_Out(get_out));

enum logic [2:0] { Start, P1, P2, P2_1, P2_2, P2_3, P3, Done } State, Next_State;

always_ff @ (posedge Clk)
  begin
    if(Reset)
      State <= Start;
    else
      State <= Next_State;
  end

always_comb
begin
    // Default: Next state is the same as the current state
    Next_State = State;

    //Default values for outputs
    //Everything set to 0
    state = 2'b00;
    loadscore = 1'b0;
    loadshots = 1'b0;
    loadget = 1'b0;
    shots_in = 2'b00;
    get_in = 2'b00;
    score_in = 20'h0;
    //The state definitions begin here
    unique case(State)
      Start:
        begin
          if(start)
            Next_State = P1;
          else
            Next_State = Start;
        end
      P1: Next_State = P2;
      P2:
        begin
          if(bird_shot)
            Next_State = P2_1;
          else if(flew_away)
            Next_State = P2_2;
          else if(shots_out == 3)
            Next_State = P2_3;
          else
            Next_State = P2;
        end
      P2_1: Next_State = P3;
      P2_2: Next_State = P3;
      P2_3: Next_State = P3;
      P3:
        begin
          if(get_out == 2'b11)
            Next_State = Done;
          else
            Next_State = P1;
        end
      Done:
        Next_State = Done;
    endcase
    //Now, we assign outputs and set variables for these states

    case(State)
      Start:
        begin
          state = 2'b00;
          shots_in = 2'b00;
          get_in = 2'b00;
          score_in = 20'h0;
          loadscore = 1'b1;
          loadshots = 1'b1;
          loadget = 1'b1;
        end
      P1:
        begin
          state = 2'b01;
          shots_in = 2'b00;
          loadshots = 1'b1;
        end
      P2:
        begin
          state = 2'b10;
          if(shot)
            begin
              shots_in = shots_out + 2'b01;
              loadshots = 1'b1;
            end
        end
      P2_1:
        begin
          state = 2'b10;
          score_in = score_out + 50;
          loadscore = 1'b1;
        end
      P2_2:
        begin
          state = 2'b10;
          get_in = get_out + 1;
          loadget = 1'b1;
        end
      P2_3:
        begin
          state = 2'b10;
          // get_in = get_out + 1;
          // loadget = 1'b1;
        end
      P3:
        begin
          state = 2'b10;
        end
      Done:
        begin
          state = 2'b11;
        end
      default:
        begin
          state = 2'b00;

        end
    endcase

end
endmodule
