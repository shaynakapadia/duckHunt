/************************************************************************
Core Game control logic
Tulika Gupta and Shayna Kapadia, Spring 2019
Duck Hunt
************************************************************************/

module Control (
    input  logic CLK,
    input  logic RESET,
    input  logic Button1,
    input logic Button2,
    output [1:0] state
);


enum logic [1:0] { Start, Game, Done } State, Next_State;

always_ff @ (posedge CLK)
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

    //The state definitions begin here
    unique case(State)
      Start:
        begin
          if(Button1)
            Next_State = Game;
        end
      Game:
        begin
          if(Button2)
            Next_State = Done;
        end
      Done:
        Next_State = Done;
    endcase

    //Now, we assign outputs and set variables for these states
    case(State)
      Start: state = 2'b00;
      Game: state = 2'b01;
      Done: state = 2'b10;
      default: state = 2'b00;
	 endcase
end
endmodule
