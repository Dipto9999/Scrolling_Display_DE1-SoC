module scrolling_display (input CLOCK_50, input [3:0] KEY, 
                          output [9:0] LEDR, 
                          output [6:0] HEX5, output [6:0] HEX4, output [6:0] HEX3,
                          output [6:0] HEX2, output [6:0] HEX1, output [6:0] HEX0);

    // Declare local signals to be used between the modules. 
    logic clock, resetb;
    logic loop_enable, display_enable;
    logic [9:0] loop_count;
    logic [6:0] next_display1, next_display2, next_display3,
                next_display4, next_display5, next_display6;   
                
    assign clock = KEY[0];
    assign resetb = KEY[3];              

    ////// Instantiate the Modules as Shown in the Block Diagram ////// 

    statemachine StateMachine (.clock(clock), .resetb(resetb), 
                     .incremented_count(LEDR), 
                     .current_display1(HEX0), .current_display2(HEX1), .current_display3(HEX2),
                     .current_display4(HEX3), .current_display5(HEX4),
                     .loop_enable(loop_enable), .display_enable(display_enable), 
                     .loop_count(loop_count),
                     .load_display1(next_display1), .load_display2(next_display2), .load_display3(next_display3),
                     .load_display4(next_display4), .load_display5(next_display5), .load_display6(next_display6));
    
    datapath DataPath (.clock(clock), .resetb(resetb), 
                 .loop_enable(loop_enable), .display_enable(display_enable),
                 .loop_count(loop_count),
                 .load_display1(next_display1), .load_display2(next_display2), .load_display3(next_display3), 
                 .load_display4(next_display4), .load_display5(next_display5), .load_display6(next_display6),
                 .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), 
                 .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), 
                 .LEDR(LEDR));
endmodule