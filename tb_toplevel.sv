`timescale 1ps/1ps

`include "defines.sv"

/*************/
/* TestBench */
/*************/

/* Note : No I/O Signals To TestBench. */
module tb_toplevel;

    /* Error Signal for TestBench. */
    logic err;

    /* Input Signals For DUT. */
    logic[9:0] TB_SW;
    logic[3:0] TB_KEY;

    /* Output Signals */
    logic[9:0] TB_LEDR;
    logic[6:0] TB_HEX0, TB_HEX1, TB_HEX2,
               TB_HEX3, TB_HEX4, TB_HEX5;

    /* Internal Signals For DUT. */
    logic TB_CLK, TB_RESET;

    logic[9:0] EXPECTED_LEDR;
    logic[6:0] OLD_HEX0, OLD_HEX1, OLD_HEX2,
               OLD_HEX3, OLD_HEX4, OLD_HEX5;

    assign TB_KEY[0] = ~TB_CLK;
    assign TB_KEY[3] = ~TB_RESET;

    /* DE1 GUI TEST -> Uncomment and Load de1_gui.tcl (Must Include de1_gui.sv, tb_de1_gui.sv in Modelsim Project). */
    // Instantiate DE1 GUI.
    de1_gui GUI(
        .SW(), .KEY(),
        .LEDR(TB_LEDR), .HEX5(TB_HEX5), .HEX4(TB_HEX4), .HEX3(TB_HEX3),
        .HEX2(TB_HEX2), .HEX1(TB_HEX1), .HEX0(TB_HEX0)
    );


    /* Instantiate the Scrolling Display Module. */
    toplevel DUT(
        /* Input Signal */
        .KEY(TB_KEY),
        /* Output Signals */
        .LEDR(TB_LEDR), .HEX5(TB_HEX5), .HEX4(TB_HEX4), .HEX3(TB_HEX3),
        .HEX2(TB_HEX2), .HEX1(TB_HEX1), .HEX0(TB_HEX0)
    );

    /* Cycle the Slow Clock. */
    initial begin
        TB_CLK = 0;
        forever #(`CLOCK_CYCLE/2) TB_CLK = ~TB_CLK;
    end

    initial begin
	    err = 0; // Deassert Error Signal.

        check__reset_state();

        check__displaycase_A_state();

        check__displaycase_B_J_state(`LEDR_0);
        check__displaycase_C_K_state(`LEDR_0);
        check__displaycase_D_L_state(`LEDR_0);
        check__displaycase_E_M_state(`LEDR_0);

        EXPECTED_LEDR = `LEDR_0;
        repeat(10) begin
            check__displaycase_F_state(EXPECTED_LEDR);
            check__displaycase_G_state(EXPECTED_LEDR);
            check__displaycase_H_state(EXPECTED_LEDR);

            EXPECTED_LEDR = (EXPECTED_LEDR == `LEDR_0) ?
                `LEDR_1 : EXPECTED_LEDR << 1;
            check__displaycase_I_state(EXPECTED_LEDR);

            check__displaycase_B_J_state(EXPECTED_LEDR);
            check__displaycase_C_K_state(EXPECTED_LEDR);
            check__displaycase_D_L_state(EXPECTED_LEDR);
            check__displaycase_E_M_state(EXPECTED_LEDR);
        end

        repeat(5) check__displaycase_N__R_state(`LEDR_10);

        check__displaycase_S_V_state(`LEDR_1A);
        check__displaycase_T_W_state(`LEDR_1B);
        check__displaycase_U_X_state(`LEDR_2A);
        check__displaycase_S_V_state(`LEDR_2B);
        check__displaycase_T_W_state(`LEDR_2C);
        check__displaycase_U_X_state(`LEDR_ON);

        check__displaycase_Y__c_state(`LEDR_1A);
        check__displaycase_Y__c_state(`LEDR_1B);
        check__displaycase_Y__c_state(`LEDR_2A);
        check__displaycase_Y__c_state(`LEDR_2B);
        check__displaycase_Y__c_state(`LEDR_2C);
        check__displaycase_Y__c_state(`LEDR_ON);

        repeat(10) check__displaycase_N__R_state(`LEDR_ON);

        assert (err == 0) begin
            $display("\nPASSED! End of Testbench...\n");
        end else begin
            $display("\nFAILED! End of Testbench...\n");
        end
    end

    task check__reset_state;
        begin
            TB_RESET = 1'b1; #(`CLOCK_CYCLE); TB_RESET = 1'b0; #(`CLOCK_CYCLE);

            check_ledr(`LEDR_0);  check_hex(TB_HEX1, `HEX_OFF); check_hex(TB_HEX2, `HEX_OFF);
            check_hex(TB_HEX3, `HEX_OFF); check_hex(TB_HEX4, `HEX_OFF); check_hex(TB_HEX5, `HEX_OFF);
        end
    endtask

    task check__displaycase_A_state;
        begin
            #(`CLOCK_CYCLE);

            check_ledr(`LEDR_0); check_hex(TB_HEX0, `HEX_C); check_hex(TB_HEX1, `HEX_OFF); check_hex(TB_HEX2, `HEX_OFF);
            check_hex(TB_HEX3, `HEX_OFF); check_hex(TB_HEX4, `HEX_OFF); check_hex(TB_HEX5, `HEX_OFF);
        end
    endtask

    task check__displaycase_B_J_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_P); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_C_K_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_E); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_D_L_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_N); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_E_M_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_OFF); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_F_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_3); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_G_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_1); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_H_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_1); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_I_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_C); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_N__R_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_OFF); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_S_V_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_b); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_T_W_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_y); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_U_X_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_e); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    task check__displaycase_Y__c_state;
        input[9:0] expected_ledr;

        begin
            save_hex(); #(`CLOCK_CYCLE);

            check_ledr(expected_ledr); check_hex(TB_HEX0, `HEX_OFF); check_hex(TB_HEX1, OLD_HEX0); check_hex(TB_HEX2, OLD_HEX1);
            check_hex(TB_HEX3, OLD_HEX2); check_hex(TB_HEX4, OLD_HEX3); check_hex(TB_HEX5, OLD_HEX4);
        end
    endtask

    /* Check That HEX Register Is As Expected. */
    task check_hex;
        input[6:0] actual_hex, expected_hex;

        begin
            assert (actual_hex == expected_hex) begin
		    	$display("OK. HEX Output as Expected.\n");
            end else begin
                err = 1; // Assert Error Signal.

		    	$display("Expected HEX Output : %b\nActual HEX Output : %b\n", expected_hex, actual_hex);
                $stop; // Stop Simulation.
            end
        end
    endtask

    /* Save HEX Register Contents to Local Signals. */
    task save_hex;
        OLD_HEX0 = TB_HEX0; OLD_HEX1 = TB_HEX1; OLD_HEX2 = TB_HEX2;
        OLD_HEX3 = TB_HEX3; OLD_HEX4 = TB_HEX4; OLD_HEX5 = TB_HEX5;
    endtask

    /* Check That LEDR Register Is As Expected. */
    task check_ledr;
        input[9:0] expected_ledr;

        begin
            assert (TB_LEDR == expected_ledr) begin
		    	$display("OK. LEDR Output as Expected.\n");
            end else begin
                err = 1; // Assert Error Signal.

		    	$error("Expected LEDR Output : %b\nActual LEDR Output : %b\n", expected_ledr, TB_LEDR);
                $stop; // Stop Simulation.
            end
        end
    endtask
endmodule