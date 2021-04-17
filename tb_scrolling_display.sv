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

module tb_scrolling_display();
    // Input Signals for Scrolling Display TB.
    logic [9:0] TB_SW;
    logic TB_CLOCK_50;
    logic [3:0] TB_KEY;

    // Output Signals for Scrolling Display TB.
    logic [9:0] TB_LEDR;
    logic [6:0] TB_HEX0;
    logic [6:0] TB_HEX1;
    logic [6:0] TB_HEX2;
    logic [6:0] TB_HEX3;
    logic [6:0] TB_HEX4;
    logic [6:0] TB_HEX5;

    /* DE1 GUI TEST -> Uncomment and Load de1_gui.tcl (Must Include de1_gui.sv, tb_de1_gui.sv in Modelsim Project). 
        
        // Instantiate DE1 GUI
        de1_gui GUI(.SW(TB_SW), .KEY(TB_KEY), .LEDR(TB_LEDR), 
                    .HEX5(TB_HEX5), .HEX4(TB_HEX4), .HEX3(TB_HEX3), 
                    .HEX2(TB_HEX2), .HEX1(TB_HEX1), .HEX0(TB_HEX0));
    */
    
    // Instantiate the Scrolling Display Module.
    scrolling_display DUT (.CLOCK_50(TB_CLOCK_50), .KEY(TB_KEY), 
                          .LEDR(TB_LEDR), 
                          .HEX5(TB_HEX5), .HEX4(TB_HEX4), .HEX3(TB_HEX3),
                          .HEX2(TB_HEX2), .HEX1(TB_HEX1), .HEX0(TB_HEX0));

    // Cycle the Clock.
    initial begin
        TB_KEY[0] = 0;
        forever #1 TB_KEY[0] = ~ TB_KEY[0];
    end

    initial begin
        ////////// Scrolling Display should be completed in approximately 107 Clock Cycles. //////////

        // Assert the Reset Signal.
        TB_KEY[3] <= 0;
        
        // Move 2 Clock Cycles to Negedge Clock -> HEX and LEDR Output Driven After a Clock Cycle Delay.
        #4;

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

        // Deassert the Reset Signal.
        TB_KEY[3] <= 1;

        // Move 54 Clock Cycles to Negedge Clock.
        #109;

        // All Displays and LEDR should NOT be Off. 
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            != {`Count_0, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
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

        // Move 54 Clock Cycles to Negedge Clock.
        #108;

        // All Displays should be Off and LEDR should be On.  
        assert ({TB_LEDR, TB_HEX0, TB_HEX1, TB_HEX2, TB_HEX3, TB_HEX4, TB_HEX5} 
            == {`All_Lights_ON, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF, `Display_OFF})
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

        $display("End of Testbench");
    end
endmodule