
module toplevel( input               CLOCK_50,
                 input        [3:0]  KEY,          //bit 0 is set up as Reset
                 output logic [7:0]  VGA_R,        //VGA Red
                                     VGA_G,        //VGA Green
                                     VGA_B,        //VGA Blue
                 output logic        VGA_CLK,      //VGA Clock
                                     VGA_SYNC_N,   //VGA Sync signal
                                     VGA_BLANK_N,  //VGA Blank signal
                                     VGA_VS,       //VGA virtical sync signal
                                     VGA_HS,       //VGA horizontal sync signal
                 output logic [6:0]  HEX0,
                 output logic [6:0]  HEX1,
                 output logic [6:0]  HEX2,
                 output logic [6:0]  HEX3,
                 output logic [6:0]  HEX4,
                 output logic [6:0]  HEX5,
                 output logic [6:0]  HEX6,
                 output logic [6:0]  HEX7
                    );

   logic Reset_h, Clk, Button1_h, Button2_h, Button3_h;
   logic is_duck, is_dog;
   logic flew_away, bird_shot;
   logic no_shots_left, no_birds_left;
   logic new_duck;
   logic reset_shots, reset_score, reset_birds;
   logic [1:0] state;
	 logic [31:0] num_shots, score, num_birds;
   logic [9:0] DrawX, DrawY;
   logic [15:0] duck_addr;
   logic [13:0] dog_addr;


    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
        Button1_h <= ~(KEY[1]);
        Button2_h <= ~(KEY[2]);
        Button3_h <= ~(KEY[3]);
    end

    // Control unit gamecontroller
    control gamecontroller(.Clk(Clk), .Reset(Reset_h), .start(Button1_h),
    .no_shots_left(no_shots_left), .flew_away(flew_away), .game_over(no_birds_left),
    .bird_shot(bird_shot), .new_duck(new_duck), .reset_shots(reset_shots),
    .reset_score(reset_score), .reset_birds(reset_birds), .state(state));

    shotKeeper shotshandler(.Clk(Clk), .Reset(reset_shots), .shot(Button2_h), .state(state),
    .no_shots_left(no_shots_left), .num_shots(num_shots));

    scoreKeeper scorehandler(.Clk(Clk), .Reset(reset_score), .bird_shot(bird_shot),
    .state(state), .score(score));

    birdKeeper birdhandler(.Clk(Clk), .Reset(reset_birds), .flew_away(flew_away),
    .state(state), .no_birds_left(no_birds_left), .num_birds(num_birds));

    duck duck_instance(.Clk(Clk), .Reset(Reset_h), .shot(Button3_h),
    .new_duck(new_duck), .frame_clk(VGA_VS), .state(state), .DrawX(DrawX),
    .DrawY(DrawY), .is_duck(is_duck), .flew_away(flew_away), .bird_shot(bird_shot),
    .duck_addr(duck_addr));

    dog dog_instance(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),
    .DrawX(DrawX), .DrawY(DrawY), .is_dog(is_dog), .dog_addr(dog_addr));

    // Use PLL to generate the 25MHZ VGA_CLK.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    VGA_controller vga_controller_instance(.Clk(Clk), .Reset(Reset_h), .VGA_HS(VGA_HS),
		 .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N),
		 .DrawX(DrawX), .DrawY(DrawY));

    color_mapper color_instance(.Clk(Clk), .is_duck(is_duck), .is_dog(is_dog),
    .DrawX(DrawX), .DrawY(DrawY), .duck_addr(duck_addr), .dog_addr(dog_addr),
    .state(state), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));


    hexdriver hexdrv0 (
    	.In(score[3:0]),
       .Out(HEX0)
    );
    hexdriver hexdrv1 (
    	.In(score[7:4]),
       .Out(HEX1)
    );
    hexdriver hexdrv2 (
    	.In(score[11:8]),
       .Out(HEX2)
    );
    hexdriver hexdrv3 (
    	.In(score[15:12]),
       .Out(HEX3)
    );

    hexdriver hexdrv4 (
      .In(num_shots[3:0]),
       .Out(HEX4)
    );
    hexdriver hexdrv5 (
      .In(num_shots[7:4]),
       .Out(HEX5)
    );
    hexdriver hexdrv6 (
      .In(num_birds[3:0]),
       .Out(HEX6)
    );
    hexdriver hexdrv7 (
      .In(num_birds[7:4]),
       .Out(HEX7)
    );
endmodule
