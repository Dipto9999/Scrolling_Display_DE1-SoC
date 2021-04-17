// Define Macros for One Hot Loop Counter
`define Count_0 10'b0000000000
`define Count_1 10'b0000000001
`define Count_2 10'b0000000010
`define Count_3 10'b0000000100
`define Count_4 10'b0000001000
`define Count_5 10'b0000010000
`define Count_6 10'b0000100000
`define Count_7 10'b0001000000
`define Count_8 10'b0010000000
`define Count_9 10'b0100000000
`define Count_10 10'b1000000000

// Define Macros for Flickering Lights
`define Flickering_Skip_1A 10'b1010101010
`define Flickering_Skip_1B 10'b0101010101
`define Flickering_Skip_2A 10'b0010010010
`define Flickering_Skip_2B 10'b0100100100
`define Flickering_Skip_2C 10'b1001001001
`define All_Lights_ON 10'b1111111111

// We will light up the next LEDR at the start of every phrase loop. 
module led_handler (input enable, input [9:0] input_display, input clk, input reset, output reg [9:0] stored_display);
    always @ (posedge clk) begin
        if (reset == 0) begin
            stored_display <= `Count_0;
        end else begin
            if (enable == 1) begin
                case (input_display)
                    // Implement as One Hot Signal
                    `Count_0 : stored_display <= `Count_1;
                    `Count_1 : stored_display <= `Count_2;
                    `Count_2 : stored_display <= `Count_3;
                    `Count_3 : stored_display <= `Count_4;
                    `Count_4 : stored_display <= `Count_5;
                    `Count_5 : stored_display <= `Count_6;
                    `Count_6 : stored_display <= `Count_7;
                    `Count_7 : stored_display <= `Count_8;
                    `Count_8 : stored_display <= `Count_9;
                    `Count_9 : stored_display <= `Count_10;
                    // Flicker Lights When Scrolling Display Finished
                    `Count_10 : stored_display <= `Flickering_Skip_1A;
                    `Flickering_Skip_1A : stored_display <= `Flickering_Skip_1B;
                    `Flickering_Skip_1B : stored_display <= `Flickering_Skip_2A;                     
                    `Flickering_Skip_2A : stored_display <= `Flickering_Skip_2B;
                    `Flickering_Skip_2B : stored_display <= `Flickering_Skip_2C;
                    `Flickering_Skip_2C : stored_display <= `All_Lights_ON;
                    `All_Lights_ON : stored_display <= `Flickering_Skip_1B;
                    default : stored_display <= stored_display;
                endcase
            end else
                stored_display <= stored_display;
        end
    end
endmodule