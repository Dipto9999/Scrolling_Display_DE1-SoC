`timescale 1ps/1ps

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

module tb_led_handler();
    // Input Signals for LED_Handler TB.
    logic TB_CLOCK, TB_RESET, TB_EN;
    logic [9:0] TB_INPUT_DISPLAY;

    // Output Signal for LED_Handler TB.
    logic [9:0] TB_LEDR;

    // Instantiate the LED_Handler Module.
    led_handler LED_Handler (.enable(TB_EN), .input_display(TB_INPUT_DISPLAY), .clk(TB_CLOCK), .reset(TB_RESET), .stored_display(TB_LEDR));

    // Cycle the Clock.
    initial begin
        TB_CLOCK = 0;
        forever #1 TB_CLOCK = ~ TB_CLOCK;
    end

    initial begin
        // Assert the Reset Signal (Done by statemachine.sv).
        TB_RESET <= 0;

        // Deassert the Enable Signal (Done by statemachine.sv). 
        TB_EN <= 0;
        
        // Initialize the Input Display Signal (Done by statemachine.sv).
        TB_INPUT_DISPLAY <= `Count_0;

        // Move 1 Clock Cycle to Negedge Clock.
        #4;

        // LEDR Signal should NOT be incremented.
        assert (TB_LEDR == `Count_0) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Assert the Enable Signal.
        TB_EN <= 1;
        TB_INPUT_DISPLAY <= `Count_0;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should NOT be incremented.
        assert (TB_LEDR == `Count_0) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Triple check that Reset Signal is handled as intended.
        TB_INPUT_DISPLAY <= `Count_1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should NOT be incremented.
        assert (TB_LEDR == `Count_0) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Deassert the Reset Signal.
        TB_RESET <= 1;

        //////////////////////////////////////////////////////////////
        /////// Continue Through the Possible Input Displays /////////
        //////////////////////////////////////////////////////////////
       
        TB_INPUT_DISPLAY <= `Count_0;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_1) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_1;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_2) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_2;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_3) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_3;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_4) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_4;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_5) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_5;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_6) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_6;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_7) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_7;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_8) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_8;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_9) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Count_9;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be incremented.
        assert (TB_LEDR == `Count_10) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Deassert the Enable Signal.
        TB_EN <= 0;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should NOT be incremented.
        assert (TB_LEDR == `Count_10) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        //////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that the Enable Signal is connected as intended. ///////
        //////////////////////////////////////////////////////////////////////////////////////////////////

        // Assert the Enable Signal.
        TB_EN <= 1;

        // Change the Input Display to a trivial 10 bit value.
        TB_INPUT_DISPLAY <= 10'b1111111110;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should NOT change.
        assert (TB_LEDR == `Count_10) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        // Assert the Reset Signal.
        TB_RESET <= 0;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be reinitialized to 0.
        assert (TB_LEDR == `Count_0) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that the Reset Signal is connected as intended. /////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        // Move to Posedge Clock.
        #1;

        TB_RESET <= 1;
        TB_INPUT_DISPLAY <= `Count_10;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be changed to the respective Flickering Light Code.
        assert (TB_LEDR == `Flickering_Skip_1A) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Flickering_Skip_1A;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be changed to the respective Flickering Light Code.
        assert (TB_LEDR == `Flickering_Skip_1B) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Flickering_Skip_1B;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be changed to the respective Flickering Light Code.
        assert (TB_LEDR == `Flickering_Skip_2A) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Flickering_Skip_2A;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be changed to the respective Flickering Light Code.
        assert (TB_LEDR == `Flickering_Skip_2B) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Flickering_Skip_2B;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be changed to the respective Flickering Light Code;
        assert (TB_LEDR == `Flickering_Skip_2C) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `Flickering_Skip_2C;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be changed to the respective Flickering Light Code.
        assert (TB_LEDR == `All_Lights_ON) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        TB_INPUT_DISPLAY <= `All_Lights_ON;

        // Move 1 Clock Cycle to Negedge Clock.
        #3;

        // LEDR Signal should be changed to the respective Flickering Light Code.
        assert (TB_LEDR == `Flickering_Skip_1B) begin
            $display ("OK. Output as Expected.");
        end else begin
            $error("Unexpected Output. TB_LEDR : ", TB_LEDR);
            $stop; // Stop Simulation.
        end

        // Move to Posedge Clock.
        #1;

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////// At this stage, we are confident that the Input Display is connected as intended. ////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        $display("End of Testbench");	
    end
endmodule