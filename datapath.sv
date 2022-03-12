`include "defines.sv"

/****************/
/**** Module ****/
/****************/

module datapath(clk, reset, ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5,
                current_ledr, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4, current_hex5);

    /* Input Signals */
    input clk, reset, ledr_en, hex_en;
    input[6:0] next_hex0, next_hex1, next_hex2,
               next_hex3, next_hex4, next_hex5;

    /* Output Signals */
    inout[9:0] current_ledr;
    output[6:0] current_hex0, current_hex1, current_hex2,
                current_hex3, current_hex4, current_hex5;

    /* Internal Signal */
    wire[9:0] write_ledr;

    /* Instantiate Modules. */
    hex_driver HEX0_DISPLAY(.clk(clk), .reset(reset), .en(hex_en), .in(next_hex0), .out(current_hex0));
    hex_driver HEX1_DISPLAY(.clk(clk), .reset(reset), .en(hex_en), .in(next_hex1), .out(current_hex1));
    hex_driver HEX2_DISPLAY(.clk(clk), .reset(reset), .en(hex_en), .in(next_hex2), .out(current_hex2));
    hex_driver HEX3_DISPLAY(.clk(clk), .reset(reset), .en(hex_en), .in(next_hex3), .out(current_hex3));
    hex_driver HEX4_DISPLAY(.clk(clk), .reset(reset), .en(hex_en), .in(next_hex4), .out(current_hex4));
    hex_driver HEX5_DISPLAY(.clk(clk), .reset(reset), .en(hex_en), .in(next_hex5), .out(current_hex5));

    tristate_driver #(10) WRITE_DRIVER(
        .in(current_ledr), .en(ledr_en), .out(write_ledr)
    );

    /* We Are Using A reg10 Like Module To Instantiate The LEDR Handler. */
    ledr_driver LEDR_DISPLAY(
        .clk(clk), .reset(reset), .en(ledr_en), .in(write_ledr), .out(current_ledr)
    );
endmodule : datapath

/*****************/
/* Helper Module */
/*****************/

module tristate_driver(in, en, out);
    parameter n = 16; /* 16-Bit Data */

    input [(n-1):0] in;
    input en;
    output [(n-1):0] out;

    assign out = en ? in : {n{1'bz}};
endmodule : tristate_driver
