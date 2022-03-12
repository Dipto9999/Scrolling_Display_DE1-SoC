/* Time Values Will Be Read As ps And Rounded To The Nearest 1 ps. */
`timescale 1 ps / 1 ps

`include "defines.sv"

/*************/
/* TestBench */
/*************/

/* Note : No I/O Signals To TestBench. */
module tb_ledr_driver;

    /* Error Signal for TestBench. */
    logic err;

    logic TB_CLK, TB_RESET, TB_EN; /* Input Signals For DUT. */
    logic[9:0] TB_IN;
    logic[9:0] TB_OUT; /* Output Signal For DUT. */

    /* Instantiate the LEDR Driver Module. */
    ledr_driver DUT(.clk(TB_CLK), .reset(TB_RESET), .en(TB_EN), .in(TB_IN), .out(TB_OUT));

    /* Cycle the Slow Clock. */
    initial begin
        TB_CLK = 0;
        forever #(`CLOCK_CYCLE/2) TB_CLK = ~TB_CLK;
    end

    initial begin
	    err = 0; // Deassert Error Signal.

        /* Check Reset Signal Is High. */
        TB_RESET = 1'b1; TB_EN = 1'b1; TB_IN = `LEDR_0; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_0);

        /* Check Enable Signal Is Low. */
        TB_RESET = 1'b0; TB_EN = 1'b0; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_0);

        /* Check LEDR Counter. */

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_1);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_2);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_3);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_4);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_5);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_6);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_7);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_8);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_9);

        TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_10);

        /* Check LEDR Effects. */

        repeat(2) begin
            TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
            check_ledr(`LEDR_1A);

            TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
            check_ledr(`LEDR_1B);

            TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
            check_ledr(`LEDR_2A);

            TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
            check_ledr(`LEDR_2B);

            TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
            check_ledr(`LEDR_2C);

            TB_EN = 1'b1; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
            check_ledr(`LEDR_ON);
        end

        /* Check Enable Signal Is Low. */
        TB_EN = 1'b0; TB_IN = TB_OUT; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_ON);

        /* Check Reset Signal Is High */
        TB_RESET = 1'b1; TB_EN = 1'b1; TB_IN = `LEDR_0; #(`CLOCK_CYCLE);
        check_ledr(`LEDR_0);

        assert (err == 0) begin
            $display("\n*** PASSED! End of Testbench ***\n");
        end else begin
            $display("\n*** FAILED! End of Testbench ***\n");
        end
    end

    /* Check That LEDR Output Is As Expected. */
    task check_ledr;
        input[9:0] expected_ledr;

        begin
            assert (TB_OUT == expected_ledr) begin
		    	$display("OK. LEDR Output as Expected.\n");
            end else begin
                err = 1; // Assert Error Signal.

		    	$error("Expected LEDR : %b\nActual LEDR : %b\n", expected_ledr, TB_OUT);
                $stop; // Stop Simulation.
            end
        end
    endtask
endmodule : tb_ledr_driver