// Define Macros for States.
`define ResetState 5'b00000

// DE1-SoC HEX Calibration States
`define HardwareOffState 5'b00001

// ScrollingDisplay States
`define DisplayCase_A_State 5'b00010

`define DisplayCase_B_J_State 5'b00011
`define DisplayCase_C_K_State 5'b00100
`define DisplayCase_D_L_State 5'b00101
`define DisplayCase_E_M_State 5'b00110

`define DisplayCase_F_State 5'b00111
`define DisplayCase_G_State 5'b01000 
`define DisplayCase_H_State 5'b01001
`define DisplayCase_I_State 5'b01010

// End of ScrollingDisplay States
`define DisplayCase_N_State 5'b01011
`define DisplayCase_O_State 5'b01100
`define DisplayCase_P_State 5'b01101
`define DisplayCase_Q_State 5'b01110

// DoneState
`define DisplayCase_R_State 5'b01111

// "byebye" Message States
`define DisplayCase_S_V_State 5'b10000 
`define DisplayCase_T_W_State 5'b10001
`define DisplayCase_U_X_State 5'b10010

// End of "byebye" Message States
`define DisplayCase_Y_State 5'b10011
`define DisplayCase_Z_State 5'b10100
`define DisplayCase_a_State 5'b10101
`define DisplayCase_b_State 5'b10110
`define DisplayCase_c_State 5'b10111

// Define Macros for Displays.
`define Display_OFF 7'b1111111

`define Display_C 7'b1000110
`define Display_P 7'b0001100
`define Display_E 7'b0000110
`define Display_N 7'b1001000
`define Display_3 7'b0110000
`define Display_1 7'b1111001

`define Display_b 7'b0000011
`define Display_y 7'b0010001
`define Display_e 7'b0000100

module statemachine (input clock, input resetb, 
                     input [9:0] incremented_count, 
                     input [6:0] current_display1, input [6:0] current_display2, input [6:0] current_display3,
                     input [6:0] current_display4, input [6:0] current_display5, 
                     output loop_enable, output display_enable, 
                     output [9:0] loop_count,
                     output [6:0] load_display1, output [6:0] load_display2, output [6:0] load_display3,
                     output [6:0] load_display4, output [6:0] load_display5, output [6:0] load_display6);

    logic [4:0] current_state, next_state;
    
    // These Output Signals will be modified based on the Current State.
    logic reg_loop_enabler, reg_display_enabler;
    logic [9:0] reg_loop_counter;
    logic [6:0] reg_display1_loader, reg_display2_loader, reg_display3_loader,
                reg_display4_loader, reg_display5_loader, reg_display6_loader;

    // Current State Logic (Sequential, Synchronous)
    always @ (posedge clock) begin
        if (resetb == 0) begin
            current_state <= `ResetState;
        end else if (resetb == 1) begin
            current_state <= next_state;
        end
    end

    // Output and Next State Logic (Combinational)
    always @(*) begin
        case (current_state) 
            // Register Values
            `ResetState :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b0;

                    reg_loop_counter = 10'b0000000000;

                    reg_display6_loader = `Display_OFF;
                    reg_display5_loader = `Display_OFF;
                    reg_display4_loader = `Display_OFF;
                    reg_display3_loader = `Display_OFF;
                    reg_display2_loader = `Display_OFF;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end
            `HardwareOffState :
                begin
                    // This is an additional ResetState like configuration.
                    // It allows a more seemless Scrolling Display to be loaded to the DE1-SoC.
                    // By default, all the HEX Displays are turned On.
                    
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = 10'b0000000000;

                    reg_display6_loader = `Display_OFF;
                    reg_display5_loader = `Display_OFF;
                    reg_display4_loader = `Display_OFF;
                    reg_display3_loader = `Display_OFF;
                    reg_display2_loader = `Display_OFF;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;                      
                end
            `DisplayCase_A_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_C;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_B_J_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_P;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_C_K_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_E;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_D_L_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_N;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_E_M_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = (loop_count < 10'b1000000000) ? current_state + 5'b00001 : `DisplayCase_N_State;                      
                end
            `DisplayCase_F_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_3;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_G_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_1;

                    next_state = current_state + 5'b00001;  
                end  
            `DisplayCase_H_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_1;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_I_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    // Loop count should be incremented at the next clock cycle.
                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_C;

                    next_state = `DisplayCase_B_J_State;  
                end  
            `DisplayCase_N_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_O_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_P_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_Q_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_R_State :
                begin
                    reg_loop_enabler = 1'b0;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = (loop_count == 10'b1000000000) ? current_state + 5'b00001 : current_state;  
                end
            `DisplayCase_S_V_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_b;

                    next_state = current_state + 5'b00001;                      
                end
            `DisplayCase_T_W_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_y;

                    next_state = current_state + 5'b00001;                      
                end
            `DisplayCase_U_X_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_e;

                    next_state = (current_display5 == `Display_OFF) ? 
                        `DisplayCase_S_V_State : current_state + 5'b00001;                      
                end       
            `DisplayCase_Y_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_Z_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end     
            `DisplayCase_a_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end          
            `DisplayCase_b_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = current_state + 5'b00001;  
                end
            `DisplayCase_c_State :
                begin
                    reg_loop_enabler = 1'b1;
                    reg_display_enabler = 1'b1;

                    reg_loop_counter = incremented_count;

                    // Shift Displays to the Left
                    reg_display6_loader = current_display5;
                    reg_display5_loader = current_display4;
                    reg_display4_loader = current_display3;
                    reg_display3_loader = current_display2;
                    reg_display2_loader = current_display1;

                    reg_display1_loader = `Display_OFF;

                    next_state = `DisplayCase_R_State;  
                end
            default :
                begin
                    reg_loop_enabler = reg_loop_enabler;
                    reg_display_enabler = reg_display_enabler;

                    reg_loop_counter = reg_loop_counter;

                    reg_display6_loader = reg_display6_loader;
                    reg_display5_loader = reg_display5_loader;
                    reg_display4_loader = reg_display4_loader;
                    reg_display3_loader = reg_display3_loader;
                    reg_display2_loader = reg_display2_loader;

                    reg_display1_loader = reg_display1_loader;

                    next_state = next_state;                      
                end
        endcase
    end
    
    assign loop_enable = reg_loop_enabler;
    assign display_enable = reg_display_enabler;

    assign loop_count = reg_loop_counter;
    
    assign load_display1 = reg_display1_loader;
    assign load_display2 = reg_display2_loader;
    assign load_display3 = reg_display3_loader;
    assign load_display4 = reg_display4_loader;
    assign load_display5 = reg_display5_loader;
    assign load_display6 = reg_display6_loader;
endmodule