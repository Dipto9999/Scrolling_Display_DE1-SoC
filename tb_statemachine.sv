`timescale 1ps/1ps

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

module tb_statemachine();
    // Input Signals for StateMachine TB.
    logic TB_CLOCK, TB_RESET;
    logic [6:0] TB_HEX0, TB_HEX1, TB_HEX2,
                TB_HEX3, TB_HEX4; 
    logic [9:0] TB_LEDR;

    // Output Signals for StateMachine TB.
    logic TB_LOOP_EN, TB_DISPLAY_EN;
    logic [6:0] TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3,
                TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6;
    logic [9:0] TB_LOOP_COUNT;

    // Instantiate the StateMachine Module.
    statemachine DUT (.clock(TB_CLOCK), .resetb(TB_RESET), 
                     .incremented_count(TB_LEDR),
                     .current_display1(TB_HEX0), .current_display2(TB_HEX1), .current_display3(TB_HEX2),
                     .current_display4(TB_HEX3), .current_display5(TB_HEX4),
                     .loop_enable(TB_LOOP_EN), .display_enable(TB_DISPLAY_EN), 
                     .loop_count(TB_LOOP_COUNT),
                     .load_display1(TB_LOAD_DISPLAY1), .load_display2(TB_LOAD_DISPLAY2), .load_display3(TB_LOAD_DISPLAY3),
                     .load_display4(TB_LOAD_DISPLAY4), .load_display5(TB_LOAD_DISPLAY5), .load_display6(TB_LOAD_DISPLAY6));
    
    // Cycle the Clock.
    initial begin
        TB_CLOCK = 0;
        forever #1 TB_CLOCK = ~ TB_CLOCK;
    end

    initial begin
        ///////////////////////////////////////////////////////////////////////////////////////
        //////// Start Tests With a Clean 10 Count Iteration of the Scrolling Display. //////// 
        ///////////////////////////////////////////////////////////////////////////////////////
        
        // Assert the Reset Signal.
        TB_RESET <= 0;

        // Incremented Count Initialized as 0 (Overwritten by led_handler.sv).
        TB_LEDR <= `Count_0;

        // Initialize the HEX Displays (Done by datapath.sv).
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move 1 Clock Cycle to Negedge Clock.
        #2;

        // StateMachine Should Be in ResetState. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b0, `Count_0,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move 1 Clock Cycle to Negedge Clock.
        #2;

        // StateMachine Should Be in ResetState. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b0, `Count_0,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Deassert the Reset Signal.
        TB_RESET <= 1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // StateMachine Should Be in HardwareOffState. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_A_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_C, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case B of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_P, `Display_C, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case C of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_E, `Display_P, `Display_C, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case D of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case E of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_0,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        ////////////////////////////////////////////////////////////////
        //////// 1 Iteration Should Be Completed At This Stage. //////// 
        ////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_1,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_2;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 2 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_2,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end    

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_3;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 3 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end    

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_3,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_4;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 4 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_4,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_5;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 5 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_5,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_5,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_5,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_5,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_5,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_5,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_5,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_5,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_6;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 6 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_6,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_6,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_6,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_6,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_6,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_6,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_6,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_6,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_7;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 7 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_7,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_7,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_7,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_7,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_7,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_7,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_7,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_7,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_8;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 8 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_8,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_8,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_8,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_8,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_8,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_8,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_8,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_8,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_9;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 9 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_9,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_9,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_9,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_9,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_9,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_9,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_9,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_9,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_10;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 10 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_N_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_OFF, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_O_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_P_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_Q_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_R_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_10,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end    

        // Move to Posedge Clock.
        #1;

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_1A;   

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_S_V_State (Case S of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_1A,
                `Display_b, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_1B; 

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_b;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_T_W_State (Case T of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_1B,
                `Display_y, `Display_b, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_2A;  

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_y;
        TB_HEX1 <= `Display_b;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;
      
        // StateMachine Should Be in DisplayCase_U_X_State (Case U of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_2A,
                `Display_e, `Display_y, `Display_b, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_2B;  

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_e;
        TB_HEX1 <= `Display_y;
        TB_HEX2 <= `Display_b;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_S_V_State (Case V of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_2B,
                `Display_b, `Display_e, `Display_y, 
                `Display_b, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_2C;  

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_b;
        TB_HEX1 <= `Display_e;
        TB_HEX2 <= `Display_y;
        TB_HEX3 <= `Display_b;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;   

        // StateMachine Should Be in DisplayCase_T_W_State (Case W of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_2C,
                `Display_y, `Display_b, `Display_e, 
                `Display_y, `Display_b, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Incremented Count Changed to Create Flickering Light Effect.
        TB_LEDR <= `All_Lights_ON;    

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_y;
        TB_HEX1 <= `Display_b;
        TB_HEX2 <= `Display_e;
        TB_HEX3 <= `Display_y;
        TB_HEX4 <= `Display_b;

        // Move to Negedge Clock.
        #1;   

        // StateMachine Should Be in DisplayCase_U_X_State (Case X of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `All_Lights_ON,
                `Display_e, `Display_y, `Display_b, 
                `Display_e, `Display_y, `Display_b})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;   

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_1B; 

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_e;
        TB_HEX1 <= `Display_y;
        TB_HEX2 <= `Display_b;
        TB_HEX3 <= `Display_e;
        TB_HEX4 <= `Display_y;

        // Move to Negedge Clock.
        #1;   

        // StateMachine Should Be in DisplayCase_Y_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_1B,
                `Display_OFF, `Display_e, `Display_y, 
                `Display_b, `Display_e, `Display_y})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;   

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_2A; 
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_e;
        TB_HEX2 <= `Display_y;
        TB_HEX3 <= `Display_b;
        TB_HEX4 <= `Display_e;

        // Move to Negedge Clock.
        #1;        

        // StateMachine Should Be in DisplayCase_Z_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_2A,
                `Display_OFF, `Display_OFF, `Display_e, 
                `Display_y, `Display_b, `Display_e})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;       

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_2B;  

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_e;
        TB_HEX3 <= `Display_y;
        TB_HEX4 <= `Display_b;

        // Move to Negedge Clock.
        #1;           

        // StateMachine Should Be in DisplayCase_a_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_2B,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_e, `Display_y, `Display_b})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;     

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `Flickering_Skip_2C;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_e;
        TB_HEX4 <= `Display_y;

        // Move to Negedge Clock.
        #1;        

        // StateMachine Should Be in DisplayCase_b_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Flickering_Skip_2C,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_e, `Display_y})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;     

        // Incremented Count Changed to Create Flickering Light Effect. 
        TB_LEDR <= `All_Lights_ON;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_e;

        // Move to Negedge Clock.
        #1;          

        // StateMachine Should Be in DisplayCase_c_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `All_Lights_ON,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_e})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;     

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;   

        // StateMachine Should Be in DisplayCase_R_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `All_Lights_ON,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.",
                "TB_LOOP_EN : ", TB_LOOP_EN, 
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, 
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, 
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, 
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4,
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5,
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that the State Transitions are functioning as intended. /////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        //////// Reset State Machine After Interrupted 5 Count Iteration of the Scrolling Display. //////// 
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        // Assert Reset Signal.
        TB_RESET <= 0;

        // Incremented Count Initialized as 0. 
        TB_LEDR <= `Count_0;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // StateMachine Should Be in ResetState. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b0, `Count_0,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move 1 Clock Cycle to Negedge Clock.
        #2;

        // StateMachine Should Be in ResetState. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b0, `Count_0,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Deassert the Reset Signal.
        TB_RESET <= 1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // StateMachine Should Be in HardwareOffState. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_A_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_C, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case B of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_P, `Display_C, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end 

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case C of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_E, `Display_P, `Display_C, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case D of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_OFF;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case E of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_0,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_0,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        ////////////////////////////////////////////////////////////////
        //////// 1 Iteration Should Be Completed At This Stage. //////// 
        ////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_1,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_1,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_2;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 2 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_2,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_2,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end    

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_3;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 3 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end    

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_3,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_3,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_4;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        /////////////////////////////////////////////////////////////////
        //////// 4 Iterations Should Be Completed At This Stage. //////// 
        /////////////////////////////////////////////////////////////////

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_B_J_State (Case J of Original Design). 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_P, `Display_C, `Display_1, 
                `Display_1, `Display_3, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_P;
        TB_HEX1 <= `Display_C;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_3;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_C_K_State (Case K of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_E, `Display_P, `Display_C, 
                `Display_1, `Display_1, `Display_3})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_E;
        TB_HEX1 <= `Display_P;
        TB_HEX2 <= `Display_C;
        TB_HEX3 <= `Display_1;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_D_L_State (Case L of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_N, `Display_E, `Display_P, 
                `Display_C, `Display_1, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_N;
        TB_HEX1 <= `Display_E;
        TB_HEX2 <= `Display_P;
        TB_HEX3 <= `Display_C;
        TB_HEX4 <= `Display_1;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_E_M_State (Case M of Original Design).
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_OFF, `Display_N, `Display_E, 
                `Display_P, `Display_C, `Display_1})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_OFF;
        TB_HEX1 <= `Display_N;
        TB_HEX2 <= `Display_E;
        TB_HEX3 <= `Display_P;
        TB_HEX4 <= `Display_C;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_F_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_3, `Display_OFF, `Display_N, 
                `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_3;
        TB_HEX1 <= `Display_OFF;
        TB_HEX2 <= `Display_N;
        TB_HEX3 <= `Display_E;
        TB_HEX4 <= `Display_P;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_G_State.
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_1, `Display_3, `Display_OFF, 
                `Display_N, `Display_E, `Display_P})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end  

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_3;
        TB_HEX2 <= `Display_OFF;
        TB_HEX3 <= `Display_N;
        TB_HEX4 <= `Display_E;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_H_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b1, `Count_4,
                `Display_1, `Display_1, `Display_3, 
                `Display_OFF, `Display_N, `Display_E})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;
    
        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_1;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_3;
        TB_HEX3 <= `Display_OFF;
        TB_HEX4 <= `Display_N;

        // Move to Negedge Clock.
        #1;

        // StateMachine Should Be in DisplayCase_I_State. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b1, 1'b1, `Count_4,
                `Display_C, `Display_1, `Display_1, 
                `Display_3, `Display_OFF, `Display_N})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move to Posedge Clock.
        #1;

        // Incremented Count Increased by 1. 
        TB_LEDR <= `Count_5;

        // Change the HEX Displays Based on the Loaders.
        TB_HEX0 <= `Display_C;
        TB_HEX1 <= `Display_1;
        TB_HEX2 <= `Display_1;
        TB_HEX3 <= `Display_3;
        TB_HEX4 <= `Display_OFF;

        // Assert Reset Signal.
        TB_RESET <= 0;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // StateMachine Should Be in ResetState. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b0, `Count_0,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        // Move 1 Clock Cycle to Negedge Clock.
        #2;

        // StateMachine Should Be in ResetState. 
        assert ({TB_LOOP_EN, TB_DISPLAY_EN, TB_LOOP_COUNT, 
                 TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3, 
                 TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6} 
            == {1'b0, 1'b0, `Count_0,
                `Display_OFF, `Display_OFF, `Display_OFF, 
                `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LOOP_EN : ", TB_LOOP_EN, "\n",
                "TB_DISPLAY_EN : ", TB_DISPLAY_EN, "\n", 
                "TB_LOOP_COUNT : ", TB_LOOP_COUNT, "\n",
                "TB_LOAD_DISPLAY1 : ", TB_LOAD_DISPLAY1, "\n", 
                "TB_LOAD_DISPLAY2 : ", TB_LOAD_DISPLAY2, "\n",
                "TB_LOAD_DISPLAY3 : ", TB_LOAD_DISPLAY3, "\n",
                "TB_LOAD_DISPLAY4 : ", TB_LOAD_DISPLAY4, "\n",
                "TB_LOAD_DISPLAY5 : ", TB_LOAD_DISPLAY5, "\n",
                "TB_LOAD_DISPLAY6 : ", TB_LOAD_DISPLAY6);
            $stop; // Stop Simulation.
        end   

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that the Reset Signal is connected as intended. /////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        $display("End of Testbench");	
    end
endmodule