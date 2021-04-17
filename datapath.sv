// Define Macros for Displays.
`define Display_OFF 7'b1111111
`define Display_ON 7'b0000000

`define Display_C 7'b1000110
`define Display_P 7'b0001100
`define Display_E 7'b0000110
`define Display_N 7'b1001000
`define Display_3 7'b0110000
`define Display_1 7'b1111001

`define Display_b 7'b0000011
`define Display_y 7'b0010001
`define Display_e 7'b0000100

module datapath (input clock, input resetb, 
                 input loop_enable, display_enable,
                 input [9:0] loop_count,
                 input [6:0] load_display1, input [6:0] load_display2, input [6:0] load_display3, 
                 input [6:0] load_display4, input [6:0] load_display5, input [6:0] load_display6,
                 output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2, 
                 output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5, 
                 output [9:0] LEDR);

    ////// Instantiate the Modules as Shown in the Block Diagram ////// 

    // We are using reg7 modules to instantiate the Display 1 .. Display 6.
    reg7 Display1(.enable(display_enable), .input_display(load_display1), .clk(clock), .reset(resetb), .stored_display(HEX0));
    reg7 Display2(.enable(display_enable), .input_display(load_display2), .clk(clock), .reset(resetb), .stored_display(HEX1));
    reg7 Display3(.enable(display_enable), .input_display(load_display3), .clk(clock), .reset(resetb), .stored_display(HEX2));
    reg7 Display4(.enable(display_enable), .input_display(load_display4), .clk(clock), .reset(resetb), .stored_display(HEX3));
    reg7 Display5(.enable(display_enable), .input_display(load_display5), .clk(clock), .reset(resetb), .stored_display(HEX4));
    reg7 Display6(.enable(display_enable), .input_display(load_display6), .clk(clock), .reset(resetb), .stored_display(HEX5)); 

    // We are using a reg10 like module to instantiate the LED Handler. 
    led_handler LED_Handler (.enable(loop_enable), .input_display(loop_count), .clk(clock), .reset(resetb), .stored_display(LEDR));
endmodule

// Even though the HEX Display is changed on every clock cycle for our purposes (i.e. reduntant), 
// we are implementing the means to modify the design with an enable signal. 
module reg7 (input enable, input [6:0] input_display, input clk, input reset, output reg [6:0] stored_display);
    always @(posedge clk) begin
        if (reset == 0) begin 
            stored_display <= `Display_OFF;
        end else begin 
            if (enable == 1) 
                stored_display <= input_display;
            else 
                stored_display <= stored_display;
        end
    end
endmodule

