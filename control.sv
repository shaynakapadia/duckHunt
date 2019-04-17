/************************************************************************
Core Game control logic

Tulika Gupta and Shayna Kapadia, Spring 2019

Duck Hunt
************************************************************************/

module Control (
    input  logic CLK,
    input  logic RESET,
    input  logic bird_shot,
    input  logic shot,
    input  logic flew_away,
    input  logic stop,
    output int   score,
    output logic display_start
    output logic release_bird,
    output logic game_over
);

int score, shot_count, get_aways;
logic display_start, release_bird, game_over;

enum logic [2:0] { Start, P1, P2, P2_1, P2_2, P2_3, P3, Done } State, Next_State;

always_ff @ (posedge Clk)
  begin
    if(RESET)
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
    score = 0;
    display_start = 1'b0;
    release_bird  = 1'b0;
    game_over     = 1'b0;

    //The state definitions begin here
    unique case(State)
    Start:
      if(start)
        Next_State = P1;
    P1: Next_State = P2;
    P2:
      if(bird_shot)
        Next_State = P2_1;
      else if(flew_away)
        Next_State = P2_2;
      else if(shot_count == 3)
        Next_State = P2_3;
    P2_1: Next_State = P3;
    P2_2: Next_State = P3;
    P2_3: Next_State = P3;
    P3:
      if(game_over)
        Next_State = Done;
      else
        Next_State = P1;
    Done:
      Next_State = Done;

    //Now, we assign outputs and set variables for these states

    case(State)
      Start:
        begin
          display_start = 1'b1;
          shot_count = 0;
          get_aways = 0;
          score = 0;
        end


      P1:
        begin
          release_bird = 1'b1;
          shot_count = 0;
        end

      P2:
        begin
          if(shot)
            shot_count = shot_count + 1;
        end
      P2_1:
        begin
          score = score + 50;
        end
      P2_2:
        begin
          if(shot_count != 3)
            get_aways = get_aways + 1;
        end
      P2_3:
        begin
          get_aways = get_aways + 1;
        end
      P3:
        begin
          if(get_aways >= 3)
            game_over = 1'b1;
        end
      Done: ;
      default:
        begin
          display_start = 1'b0;
          release_bird = 1'b1;
          game_over = 1'b0;
        end

end
endmodule
