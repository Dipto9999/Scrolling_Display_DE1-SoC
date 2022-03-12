/* Time Values Will Be Read As ps And Rounded To The Nearest 1 ps. */
`timescale 1 ps / 1 ps

`include "defines.sv"

/*************/
/* TestBench */
/*************/

/* Note : No I/O Signals To TestBench. */
module tb_datapath;

    /* Error Signal for TestBench. */
    logic err;

	/* Input Signals For DUT. */
    logic TB_CLK, TB_RESET;
    logic TB__LEDR_EN, TB__HEX_EN;
    logic[6:0] TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
               TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5;

    /* Output Signal For DUT. */
    wire[9:0] TB__CURRENT_LEDR;
    logic[6:0] TB__CURRENT_HEX0, TB__CURRENT_HEX1, TB__CURRENT_HEX2,
               TB__CURRENT_HEX3, TB__CURRENT_HEX4, TB__CURRENT_HEX5;

    /* Instantiate DataPath Module. */
    datapath DP(
        /* Input Signals */
        .clk(TB_CLK), .reset(TB_RESET), .ledr_en(TB__LEDR_EN), .hex_en(TB__HEX_EN),
        .next_hex0(TB__NEXT_HEX0), .next_hex1(TB__NEXT_HEX1), .next_hex2(TB__NEXT_HEX2),
        .next_hex3(TB__NEXT_HEX3), .next_hex4(TB__NEXT_HEX4), .next_hex5(TB__NEXT_HEX5),
        /* Output Signals */
        .current_ledr(TB__CURRENT_LEDR), .current_hex0(TB__CURRENT_HEX0), .current_hex1(TB__CURRENT_HEX1), .current_hex2(TB__CURRENT_HEX2),
        .current_hex3(TB__CURRENT_HEX3), .current_hex4(TB__CURRENT_HEX4), .current_hex5(TB__CURRENT_HEX5)
    );

    /* Cycle the Clock. */
    initial begin
        TB_CLK = 0;
        forever #(`CLOCK_CYCLE/2) TB_CLK = ~TB_CLK;
    end

    initial begin
	    err = 0; // Deassert Error Signal.

        /* Check Reset Signal Is High */
        TB_RESET = 1'b1; TB__LEDR_EN = 1'b1; TB__HEX_EN = 1'b1;
        TB__NEXT_HEX0 = `HEX_3; TB__NEXT_HEX1 = `HEX_OFF; TB__NEXT_HEX2 = `HEX_N;
        TB__NEXT_HEX3 = `HEX_E; TB__NEXT_HEX4 = `HEX_P; TB__NEXT_HEX5 = `HEX_C; #(`CLOCK_CYCLE); TB__LEDR_EN = 1'b0;

        check_ledr(`LEDR_0); check_hex(TB__CURRENT_HEX0, `HEX_OFF); check_hex(TB__CURRENT_HEX1, `HEX_OFF); check_hex(TB__CURRENT_HEX2, `HEX_OFF);
        check_hex(TB__CURRENT_HEX3, `HEX_OFF); check_hex(TB__CURRENT_HEX4, `HEX_OFF); check_hex(TB__CURRENT_HEX5, `HEX_OFF);

        /* Check HEX Enable Signal Is High. */
        TB_RESET = 1'b0; TB__LEDR_EN = 1'b0; TB__HEX_EN = 1'b1;
        TB__NEXT_HEX0 = `HEX_3; TB__NEXT_HEX1 = `HEX_OFF; TB__NEXT_HEX2 = `HEX_N;
        TB__NEXT_HEX3 = `HEX_E; TB__NEXT_HEX4 = `HEX_P; TB__NEXT_HEX5 = `HEX_C; #(`CLOCK_CYCLE); TB__LEDR_EN = 1'b0;

        check_ledr(`LEDR_0); check_hex(TB__CURRENT_HEX0, `HEX_3); check_hex(TB__CURRENT_HEX1, `HEX_OFF); check_hex(TB__CURRENT_HEX2, `HEX_N);
        check_hex(TB__CURRENT_HEX3, `HEX_E); check_hex(TB__CURRENT_HEX4, `HEX_P); check_hex(TB__CURRENT_HEX5, `HEX_C);

        /* Check LEDR Enable Signal Is High. */
        TB_RESET = 1'b0; TB__LEDR_EN = 1'b1; TB__HEX_EN = 1'b0;
        TB__NEXT_HEX0 = `HEX_OFF; TB__NEXT_HEX1 = `HEX_N; TB__NEXT_HEX2 = `HEX_E;
        TB__NEXT_HEX3 = `HEX_P; TB__NEXT_HEX4 = `HEX_C; TB__NEXT_HEX5 = `HEX_1; #(`CLOCK_CYCLE); TB__LEDR_EN = 1'b0;

        check_ledr(`LEDR_1); check_hex(TB__CURRENT_HEX0, `HEX_3); check_hex(TB__CURRENT_HEX1, `HEX_OFF); check_hex(TB__CURRENT_HEX2, `HEX_N);
        check_hex(TB__CURRENT_HEX3, `HEX_E); check_hex(TB__CURRENT_HEX4, `HEX_P); check_hex(TB__CURRENT_HEX5, `HEX_C);

        /* Check Reset Signal Is High */
        TB_RESET = 1'b1; TB__LEDR_EN = 1'b1; TB__HEX_EN = 1'b1;
        TB__NEXT_HEX0 = `HEX_OFF; TB__NEXT_HEX1 = `HEX_N; TB__NEXT_HEX2 = `HEX_E;
        TB__NEXT_HEX3 = `HEX_P; TB__NEXT_HEX4 = `HEX_C; TB__NEXT_HEX5 = `HEX_1; #(`CLOCK_CYCLE); TB__LEDR_EN = 1'b0;

        check_ledr(`LEDR_0); check_hex(TB__CURRENT_HEX0, `HEX_OFF); check_hex(TB__CURRENT_HEX1, `HEX_OFF); check_hex(TB__CURRENT_HEX2, `HEX_OFF);
        check_hex(TB__CURRENT_HEX3, `HEX_OFF); check_hex(TB__CURRENT_HEX4, `HEX_OFF); check_hex(TB__CURRENT_HEX5, `HEX_OFF);

        assert (err == 0) begin
            $display("\n*** PASSED! End of Testbench ***\n");
        end else begin
            $display("\n*** FAILED! End of Testbench ***\n");
        end
    end

    /* Check That HEX Register Is As Expected. */
    task check_hex;
        input[6:0] actual_hex, expected_hex;

        begin
            assert (actual_hex == expected_hex) begin
		    	$display("OK. HEX Register Assigned as Expected.\n");
            end else begin
                err = 1; // Assert Error Signal.

		    	$display("Expected HEX Data : %b\nActual HEX Data : %b\n", expected_hex, actual_hex);
                $stop; // Stop Simulation.
            end
        end
    endtask

    /* Check That LEDR Register Is As Expected. */
    task check_ledr;
        input[9:0] expected_ledr;

        begin
            assert (TB__CURRENT_LEDR == expected_ledr) begin
		    	$display("OK. LEDR Data as Expected.\n");
            end else begin
                err = 1; // Assert Error Signal.

		    	$error("Expected LEDR Data : %b\nActual LEDR Data : %b\n", expected_ledr, TB__CURRENT_LEDR);
                $stop; // Stop Simulation.
            end
        end
    endtask
endmodule : tb_datapath