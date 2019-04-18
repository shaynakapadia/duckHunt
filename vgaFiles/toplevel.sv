//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module toplevel( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             //output logic [6:0]  HEX0, HEX1,
             // VGA Interface
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // // CY7C67200 Interface
             // inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             // output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             // output logic        OTG_CS_N,     //CY7C67200 Chip Select
             //                     OTG_RD_N,     //CY7C67200 Write
             //                     OTG_WR_N,     //CY7C67200 Read
             //                     OTG_RST_N,    //CY7C67200 Reset
             // input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );

   logic Reset_h, Clk, is_duck;
	 logic [9:0] DrawX, DrawY;
   logic [18:0] duck_addr;

    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end


     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab9_soc nios_system(
                             .clk_clk(Clk),
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR),
                             .sdram_wire_ba(DRAM_BA),
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),
                             .sdram_wire_cs_n(DRAM_CS_N),
                             .sdram_wire_dq(DRAM_DQ),
                             .sdram_wire_dqm(DRAM_DQM),
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N),
                             .sdram_clk_clk(DRAM_CLK)
    );

    // Use PLL to generate the 25MHZ VGA_CLK.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    VGA_controller vga_controller_instance(.Clk(Clk), .Reset(Reset_h), .VGA_HS(VGA_HS),
		 .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N),
		 .DrawX(DrawX), .DrawY(DrawY));

    color_mapper color_instance(.Clk(Clk), .is_duck(is_duck), .DrawX(DrawX), .DrawY(DrawY),
	 .duck_addr(duck_addr), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));

    duck duck_instance(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(DrawX),
		.DrawY(DrawY), .is_duck(is_duck), .duck_addr(duck_addr));

//    ball ball_instance(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(DrawX),
//		.DrawY(DrawY), .is_ball(is_ball));
//    // Display keycode on hex display
//    HexDriver hex_inst_0 (keycode[3:0], HEX0);
//    HexDriver hex_inst_1 (keycode[7:4], HEX1);

    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
