`include "defines.sv"

/*****************/
/**** Modules ****/
/*****************/

module hex_driver(clk, reset, en, in, out);

    /* Input Signals */
    input clk, reset, en;
    input[6:0] in;

    /* Output Signal */
    output reg[6:0] out;

    always @(posedge clk) begin
        if (reset) out <= `HEX_OFF;
        else if (~reset && en) out <= in;
        else out <= out;
    end
endmodule : hex_driver

module ledr_driver(clk, reset, en, in, out);

    /* Input Signals */
    input clk, reset, en;
    input[9:0] in;

    /* Output Signals */
    output reg[9:0] out;

    /* Internal Signal */
    logic[9:0] next;

    /* Current LEDR Logic (Sequential, Synchronous). */
    always @(posedge clk) begin
        if (reset) out <= `LEDR_0;
        else if (~reset && en) out <= next;
        else out <= out;
    end

    /* Next LEDR Logic (Combinational). */
    always @(*) begin
        case(in)
            /* LEDR Counter. */
            `LEDR_0 : next = `LEDR_1;
            `LEDR_1 : next = `LEDR_2;
            `LEDR_2 : next = `LEDR_3;
            `LEDR_3 : next = `LEDR_4;
            `LEDR_4 : next = `LEDR_5;
            `LEDR_5 : next = `LEDR_6;
            `LEDR_6 : next = `LEDR_7;
            `LEDR_7 : next = `LEDR_8;
            `LEDR_8 : next = `LEDR_9;
            `LEDR_9 : next = `LEDR_10;

            /* LEDR Effects. */
            `LEDR_10 : next = `LEDR_1A;
            `LEDR_1A : next = `LEDR_1B;
            `LEDR_1B : next = `LEDR_2A;
            `LEDR_2A : next = `LEDR_2B;
            `LEDR_2B : next = `LEDR_2C;
            `LEDR_2C : next = `LEDR_ON;
            `LEDR_ON : next = `LEDR_1A;

            default : next = next;
        endcase
    end
endmodule : ledr_driver