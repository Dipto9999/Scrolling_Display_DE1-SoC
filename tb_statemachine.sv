`timescale 1 ps / 1 ps

`include "defines.sv"

/*************/
/* TestBench */
/*************/

/* Note : No I/O Signals To TestBench. */
module tb_statemachine;

    /* Error Signal for TestBench. */
    logic err;

	/* Input Signals For DUT. */
    logic TB_CLK, TB_RESET;
    logic[9:0] TB__CURRENT_LEDR;
    logic[6:0] TB__CURRENT_HEX0, TB__CURRENT_HEX1, TB__CURRENT_HEX2,
               TB__CURRENT_HEX3, TB__CURRENT_HEX4, TB__CURRENT_HEX5;

    /* Output Signals for DUT. */
    logic TB__LEDR_EN, TB__HEX_EN;
    logic[6:0] TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
               TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5;

    /* Instantiate the StateMachine Module. */
    statemachine DUT(
        /* Input Signals */
        .clk(TB_CLK), .reset(TB_RESET),
        .current_ledr(TB__CURRENT_LEDR), .current_hex0(TB__CURRENT_HEX0), .current_hex1(TB__CURRENT_HEX1), .current_hex2(TB__CURRENT_HEX2),
        .current_hex3(TB__CURRENT_HEX3), .current_hex4(TB__CURRENT_HEX4), .current_hex5(TB__CURRENT_HEX5),
        /* Output Signals */
        .ledr_en(TB__LEDR_EN), .hex_en(TB__HEX_EN),
        .next_hex0(TB__NEXT_HEX0), .next_hex1(TB__NEXT_HEX1), .next_hex2(TB__NEXT_HEX2),
        .next_hex3(TB__NEXT_HEX3), .next_hex4(TB__NEXT_HEX4), .next_hex5(TB__NEXT_HEX5)
    );

    /* Cycle the Slow Clock. */
    initial begin
        TB_CLK = 0;
        forever #(`CLOCK_CYCLE/2) TB_CLK = ~TB_CLK;
    end

    /* DataPath Hex Registers Updated on Positive Clock Edge. */
    always @(posedge TB_CLK) begin
        TB__CURRENT_HEX0 = TB__NEXT_HEX0; TB__CURRENT_HEX1 = TB__NEXT_HEX1; TB__CURRENT_HEX2 = TB__NEXT_HEX2;
        TB__CURRENT_HEX3 = TB__NEXT_HEX3; TB__CURRENT_HEX4 = TB__NEXT_HEX4; TB__CURRENT_HEX5 = TB__NEXT_HEX5;
    end

    initial begin
	    err = 0; // Deassert Error Signal.

        check__reset_state();

        TB__CURRENT_LEDR = `LEDR_0;
        check__displaycase_A_state();

        check__displaycase_B_J_state();
        check__displaycase_C_K_state();
        check__displaycase_D_L_state();
        check__displaycase_E_M_state();

        repeat(10) begin
            check__displaycase_F_state();
            check__displaycase_G_state();
            check__displaycase_H_state();

            TB__CURRENT_LEDR = (TB__CURRENT_LEDR == `LEDR_0) ?
                `LEDR_1 : TB__CURRENT_LEDR << 1;
            check__displaycase_I_state();

            check__displaycase_B_J_state();
            check__displaycase_C_K_state();
            check__displaycase_D_L_state();
            check__displaycase_E_M_state();
        end

        repeat(5) check__displaycase_N__R_state();

        check__displaycase_S_V_state();
        TB__CURRENT_LEDR = `LEDR_1A;
        check__displaycase_T_W_state();
        TB__CURRENT_LEDR = `LEDR_1B;
        check__displaycase_U_X_state();
        TB__CURRENT_LEDR = `LEDR_2A;
        check__displaycase_S_V_state();
        TB__CURRENT_LEDR = `LEDR_2B;
        check__displaycase_T_W_state();
        TB__CURRENT_LEDR = `LEDR_2C;
        check__displaycase_U_X_state();
        TB__CURRENT_LEDR = `LEDR_ON;

        repeat(6) check__displaycase_Y__c_state();
        TB__CURRENT_LEDR = `LEDR_ON;

        repeat(10) check__displaycase_N__R_state();

        assert (err == 0) begin
            $display("\n*** PASSED! End of Testbench ***\n");
        end else begin
            $display("\n*** FAILED! End of Testbench ***\n");
        end
    end

    task check__reset_state;
        begin
            TB_RESET = 1'b1; #(`CLOCK_CYCLE); TB_RESET = 1'b0; /* Current State : `ResetState */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {{2{1'b0}}, {6{`HEX_OFF}}}
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b0, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_OFF, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", `HEX_OFF, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", `HEX_OFF, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", `HEX_OFF, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", `HEX_OFF, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", `HEX_OFF, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_A_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_A_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_C, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_C, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_B_J_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_B_J_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_P, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_P, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_C_K_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_C_K_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_E, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_E, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_D_L_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_D_L_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_N, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_N, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_E_M_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_E_M_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_OFF, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_OFF, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_F_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_F_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_3, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_3, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_G_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_G_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_1, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_1, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_H_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_H_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_1, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_1, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_I_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_I_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    {2{1'b1}},
                    `HEX_C, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b1, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_C, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_N__R_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_N__R_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    1'b0, 1'b1,
                    `HEX_OFF, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b0, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_OFF, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_S_V_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_S_V_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    {2{1'b1}},
                    `HEX_b, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b1, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_b, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_T_W_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_T_W_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    {2{1'b1}},
                    `HEX_y, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b1, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_y, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_U_X_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_U_X_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    {2{1'b1}},
                    `HEX_e, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b1, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_e, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask

    task check__displaycase_Y__c_state;
        begin
            #(`CLOCK_CYCLE); /* Current State : `DisplayCase_Y__c_State */

            assert (
                {
                    TB__LEDR_EN, TB__HEX_EN,
                    TB__NEXT_HEX0, TB__NEXT_HEX1, TB__NEXT_HEX2,
                    TB__NEXT_HEX3, TB__NEXT_HEX4, TB__NEXT_HEX5
                } == {
                    {2{1'b1}},
                    `HEX_OFF, TB__CURRENT_HEX0, TB__CURRENT_HEX1,
                    TB__CURRENT_HEX2, TB__CURRENT_HEX3, TB__CURRENT_HEX4
                }
            ) begin
                $display("OK. Output as Expected.");
		    end else begin
                err = 1; // Assert Error Signal.

                $display("Expected TB__LEDR_EN : %b\nActual TB__LEDR_EN : %b\n", 1'b1, TB__LEDR_EN);
                $display("Expected TB__HEX_EN : %b\nActual TB__HEX_EN : %b\n", 1'b1, TB__HEX_EN);

                $display("Expected TB__NEXT_HEX0 : %b\nActual TB__NEXT_HEX0 : %b\n", `HEX_OFF, TB__NEXT_HEX0);
                $display("Expected TB__NEXT_HEX1 : %b\nActual TB__NEXT_HEX1 : %b\n", TB__CURRENT_HEX0, TB__NEXT_HEX1);
                $display("Expected TB__NEXT_HEX2 : %b\nActual TB__NEXT_HEX2 : %b\n", TB__CURRENT_HEX1, TB__NEXT_HEX2);
                $display("Expected TB__NEXT_HEX3 : %b\nActual TB__NEXT_HEX3 : %b\n", TB__CURRENT_HEX2, TB__NEXT_HEX3);
                $display("Expected TB__NEXT_HEX4 : %b\nActual TB__NEXT_HEX4 : %b\n", TB__CURRENT_HEX3, TB__NEXT_HEX4);
                $display("Expected TB__NEXT_HEX5 : %b\nActual TB__NEXT_HEX5 : %b\n", TB__CURRENT_HEX4, TB__NEXT_HEX5);

                $stop; // Stop Simulation.
            end
        end
    endtask
endmodule : tb_statemachine