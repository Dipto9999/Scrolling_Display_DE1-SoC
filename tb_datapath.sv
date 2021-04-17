`timescale 1ps/1ps

// Define Macros for Displays.
`define Display_C 7'b1000110
`define Display_P 7'b0001100
`define Display_E 7'b0000110
`define Display_N 7'b1001000
`define Display_OFF 7'b1111111
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

module tb_datapath();
    // Input Signals for Datapath TB.
    logic TB_CLOCK, TB_RESET;
    logic TB_LOOP_EN, TB_DISPLAY_EN;
    logic [6:0] TB_LOAD_DISPLAY1, TB_LOAD_DISPLAY2, TB_LOAD_DISPLAY3,
                TB_LOAD_DISPLAY4, TB_LOAD_DISPLAY5, TB_LOAD_DISPLAY6;
    logic [9:0] TB_LOOP_COUNT;

    // Output Signals for Datapath TB.
    logic [6:0] TB_HEX0, TB_HEX1, TB_HEX2, 
                TB_HEX3, TB_HEX4, TB_HEX5; 
    logic [9:0] TB_LEDR;

    // Instantiate the Datapath Module.
    datapath DUT (.clock(TB_CLOCK), .resetb(TB_RESET), 
                 .loop_enable(TB_LOOP_EN), .display_enable(TB_DISPLAY_EN),
                 .loop_count(TB_LOOP_COUNT),
                 .load_display1(TB_LOAD_DISPLAY1), .load_display2(TB_LOAD_DISPLAY2), .load_display3(TB_LOAD_DISPLAY3), 
                 .load_display4(TB_LOAD_DISPLAY4), .load_display5(TB_LOAD_DISPLAY5), .load_display6(TB_LOAD_DISPLAY6),
                 .HEX0(TB_HEX0), .HEX1(TB_HEX1), .HEX2(TB_HEX2), 
                 .HEX3(TB_HEX3), .HEX4(TB_HEX4), .HEX5(TB_HEX5), 
                 .LEDR(TB_LEDR));
    
    // Cycle the Clock.
    initial begin
        TB_CLOCK = 0;
        forever #1 TB_CLOCK = ~ TB_CLOCK;
    end

    initial begin
        // Assert the Reset Signal (Done by statemachine.sv).
        TB_RESET <= 0;

        // Deassert the Display Enable Signal (Done by statemachine.sv).
        TB_DISPLAY_EN <= 0;

        // Deassert the Loop Enable Signal (Done by statemachine.sv).
        TB_LOOP_EN <= 0;

        // Initialize the Loop Counter (Done by statemachine.sv -> Should be Overwritten by led_handler.sv).
        TB_LOOP_COUNT <= `Count_0;

        // Display Loaders are Off (Done by statemachine.sv).
        TB_LOAD_DISPLAY1 <= `Display_OFF;
        TB_LOAD_DISPLAY2 <= `Display_OFF;
        TB_LOAD_DISPLAY3 <= `Display_OFF;
        TB_LOAD_DISPLAY4 <= `Display_OFF;
        TB_LOAD_DISPLAY5 <= `Display_OFF;
        TB_LOAD_DISPLAY6 <= `Display_OFF;

        // Move 1 Clock Cycle to Posedge Clock.
        #3;

        // Assert the Display Enable Signal.
        TB_DISPLAY_EN <= 1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // All Displays and LEDR should be Off. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Try to Break the Loop Counter.
        TB_LOOP_COUNT <= `Count_5;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // All Displays and LEDR should be Off. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Deassert the Reset Signal.
        TB_RESET <= 1;

        // Reinitialize the Loop Counter.
        TB_LOOP_COUNT <= `Count_0;

        // Move to Posedge Clock.
        #2;

        // Deassert the Display Enable Signal.
        TB_DISPLAY_EN <= 0;

        // Display Loaders are based on Case A of Design. 
        TB_LOAD_DISPLAY1 <= `Display_C;
        TB_LOAD_DISPLAY2 <= `Display_OFF;
        TB_LOAD_DISPLAY3 <= `Display_OFF;
        TB_LOAD_DISPLAY4 <= `Display_OFF;
        TB_LOAD_DISPLAY5 <= `Display_OFF;
        TB_LOAD_DISPLAY6 <= `Display_OFF;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;
    
        // All Displays and LEDR should be Off. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Assert the Display Enable Signal.
        TB_DISPLAY_EN <= 1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX0 Should be On and Display "C". 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_C, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Deassert the Display Enable Signal.
        TB_DISPLAY_EN <= 0;

        // Display Loaders are based on Case B of Design. 
        TB_LOAD_DISPLAY1 <= `Display_P;
        TB_LOAD_DISPLAY2 <= `Display_C;
        TB_LOAD_DISPLAY3 <= `Display_OFF;
        TB_LOAD_DISPLAY4 <= `Display_OFF;
        TB_LOAD_DISPLAY5 <= `Display_OFF;
        TB_LOAD_DISPLAY6 <= `Display_OFF;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX0 Should be On and Display "C". 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_C, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Assert the Display Enable Signal.
        TB_DISPLAY_EN <= 1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX1, TB_HEX0 Should be On and Display "C", "P" Respectively. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_P, `Display_C, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        //////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that the Display Enable Signal is connected as intended. ///////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////

        // Display Loaders are based on Case C of Design. 
        TB_LOAD_DISPLAY1 <= `Display_E;
        TB_LOAD_DISPLAY2 <= `Display_P;
        TB_LOAD_DISPLAY3 <= `Display_C;
        TB_LOAD_DISPLAY4 <= `Display_OFF;
        TB_LOAD_DISPLAY5 <= `Display_OFF;
        TB_LOAD_DISPLAY6 <= `Display_OFF;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX2, TB_HEX1, TB_HEX0 Should be On and Display "C", "P", "E" Respectively. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_E, `Display_P, `Display_C, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Display Loaders are based on Case D of Design. 
        TB_LOAD_DISPLAY1 <= `Display_N;
        TB_LOAD_DISPLAY2 <= `Display_E;
        TB_LOAD_DISPLAY3 <= `Display_P;
        TB_LOAD_DISPLAY4 <= `Display_C;
        TB_LOAD_DISPLAY5 <= `Display_OFF;
        TB_LOAD_DISPLAY6 <= `Display_OFF;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX3, TB_HEX2, TB_HEX1, TB_HEX0 Should be On and Display "C", "P", "E", "N" Respectively. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_N, `Display_E, `Display_P, `Display_C, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Display Loaders are based on Case E of Design. 
        TB_LOAD_DISPLAY1 <= `Display_OFF;
        TB_LOAD_DISPLAY2 <= `Display_N;
        TB_LOAD_DISPLAY3 <= `Display_E;
        TB_LOAD_DISPLAY4 <= `Display_P;
        TB_LOAD_DISPLAY5 <= `Display_C;
        TB_LOAD_DISPLAY6 <= `Display_OFF;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX4, TB_HEX3, TB_HEX2, TB_HEX1 Should be On and Display "C", "P", "E", "N" Respectively. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_OFF, `Display_N, `Display_E, `Display_P, `Display_C, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Display Loaders are based on Case F of Design. 
        TB_LOAD_DISPLAY1 <= `Display_3;
        TB_LOAD_DISPLAY2 <= `Display_OFF;
        TB_LOAD_DISPLAY3 <= `Display_N;
        TB_LOAD_DISPLAY4 <= `Display_E;
        TB_LOAD_DISPLAY5 <= `Display_P;
        TB_LOAD_DISPLAY6 <= `Display_C;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX5, TB_HEX4, TB_HEX3, TB_HEX2, TB_HEX0 Should be On and Display "C", "P", "E", "N", "3" Respectively. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_3, `Display_OFF, `Display_N, `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that Display 1 .. 6 are connected as intended. /////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        // Move to Posedge Clock.
        #1;

        // Assert the Loop Enable Signal.
        TB_LOOP_EN <= 1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX5, TB_HEX4, TB_HEX3, TB_HEX2, TB_HEX0 Should be On and Display "C", "P", "E", "N", "3" Respectively. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_1, `Display_3, `Display_OFF, `Display_N, `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Deassert the Loop Enable Signal.
        TB_LOOP_EN <= 0;
        TB_LOOP_COUNT <= `Count_1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX5, TB_HEX4, TB_HEX3, TB_HEX2, TB_HEX0 Should be On and Display "C", "P", "E", "N", "3" Respectively. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_1, `Display_3, `Display_OFF, `Display_N, `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end
         
        // Move to Posedge Clock.
        #1;

        // Assert the Loop Enable Signal.
        TB_LOOP_EN <= 1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // Only TB_HEX5, TB_HEX4, TB_HEX3, TB_HEX2, TB_HEX0 Should be On and Display "C", "P", "E", "N", "3" Respectively. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_2, `Display_3, `Display_OFF, `Display_N, `Display_E, `Display_P, `Display_C})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end
         
        // Move to Posedge Clock.
        #1;
   
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that the Loop Enable and Loop Count Signals are connected as intended. /////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        TB_RESET <= 1'b0;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // All Displays and LEDR should be Off. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move 1 Clock Cycle to Negedge Clock.
        #2;

        // All Displays and LEDR should be Off. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // All Displays and LEDR should be Off. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`Count_0, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
        begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output.", "\n",
                "TB_LEDR : ", TB_LEDR, "\n", 
                "TB_HEX0 : ", TB_HEX0, "\n",
                "TB_HEX1 : ", TB_HEX1, "\n",
                "TB_HEX2 : ", TB_HEX2, "\n",
                "TB_HEX3 : ", TB_HEX3, "\n",
                "TB_HEX4 : ", TB_HEX4, "\n",
                "TB_HEX5 : ", TB_HEX5);
            $stop; // Stop Simulation.
        end

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that the Reset Signal is connected as intended. /////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        $display("End of Testbench");	
    end
endmodule