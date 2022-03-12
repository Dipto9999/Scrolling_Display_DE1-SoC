`include "defines.sv"

/****************/
/**** Module ****/
/****************/

module toplevel(KEY, LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

    /* Input Signals */
    input[3:0] KEY;

    /* Output Signals */
    output[9:0] LEDR;
    output[6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    /* Internal Signals */
    logic clk, reset;
    logic ledr_en, hex_en;
    logic[6:0] next_hex0, next_hex1, next_hex2,
               next_hex3, next_hex4, next_hex5;

    assign clk = ~KEY[0];
    assign reset = ~KEY[3];

    /* Instantiate StateMachine. */
    statemachine CONTROLLER(
        /* Input Signals */
        .clk(clk), .reset(reset),
        .current_ledr(LEDR), .current_hex0(HEX0), .current_hex1(HEX1), .current_hex2(HEX2),
        .current_hex3(HEX3), .current_hex4(HEX4), .current_hex5(HEX5),
        /* Output Signals */
        .ledr_en(ledr_en), .hex_en(hex_en),
        .next_hex0(next_hex0), .next_hex1(next_hex1), .next_hex2(next_hex2),
        .next_hex3(next_hex3), .next_hex4(next_hex4), .next_hex5(next_hex5)
    );

    /* Instantiate DataPath. */
    datapath DP(
        /* Input Signals */
        .clk(clk), .reset(reset),
        .ledr_en(ledr_en), .hex_en(hex_en),
        .next_hex0(next_hex0), .next_hex1(next_hex1), .next_hex2(next_hex2),
        .next_hex3(next_hex3), .next_hex4(next_hex4), .next_hex5(next_hex5),
        /* Output Signals */
        .current_ledr(LEDR), .current_hex0(HEX0), .current_hex1(HEX1), .current_hex2(HEX2),
        .current_hex3(HEX3), .current_hex4(HEX4), .current_hex5(HEX5)
    );
endmodule : toplevel