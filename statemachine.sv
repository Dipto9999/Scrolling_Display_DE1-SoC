`include "defines.sv"

/****************/
/**** Module ****/
/****************/

module statemachine(clk, reset, current_ledr, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4, current_hex5,
                    ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5);

    /* Input Signals */
    input clk, reset;
    input[9:0] current_ledr;
    input[6:0] current_hex0, current_hex1, current_hex2, current_hex3, current_hex4, current_hex5;

    /* Output Signals */
    output logic ledr_en, hex_en;
    output logic[6:0] next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5;

    /* Internal Signals */
    logic[4:0] current_state, next_state;
    logic loop_done, display_done;

    assign loop_done = (current_ledr == `LEDR_10);
    assign display_done = (next_hex5 == `HEX_OFF);

    /* Current State Logic (Sequential, Synchronous). */
    always @(posedge clk) begin
        if (reset) current_state <= `ResetState;
        else if (~reset) current_state <= next_state;
        else current_state <= current_state;
    end

    /* Output and Next State Logic (Combinational). */
    always @(*) begin
        /* Assign Next State. */
        casex({current_state, loop_done, display_done})

            /* ScrollingDisplay States */

            {`DisplayCase_E_M_State, 1'b0, 1'bx} : next_state = `DisplayCase_F_State;
            {`DisplayCase_E_M_State, 1'b1, 1'b0} : next_state = `DisplayCase_N__R_State;

            {`DisplayCase_I_State, {2{1'bx}}} : next_state = `DisplayCase_B_J_State;

            {`DisplayCase_N__R_State, 1'b1, 1'b0} : next_state = `DisplayCase_N__R_State;
            {`DisplayCase_N__R_State, {2{1'b1}}} : next_state = `DisplayCase_S_V_State;
            {`DisplayCase_N__R_State, 1'b0, 1'b1} : next_state = `DisplayCase_N__R_State;

            /* EndDisplay States */

            {`DisplayCase_U_X_State, 1'b0, 1'b0} : next_state = `DisplayCase_Y__c_State;
            {`DisplayCase_U_X_State, 1'b0, 1'b1} : next_state = `DisplayCase_S_V_State;

            {`DisplayCase_Y__c_State, 1'b0, 1'b0} : next_state = `DisplayCase_Y__c_State;
            {`DisplayCase_Y__c_State, 1'b0, 1'b1} : next_state = `DisplayCase_N__R_State;

            default : next_state = current_state + 1'b1;
        endcase

        /* Assign Output Signals. */
        case (current_state)
            `ResetState : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5} = {{2{1'b0}}, {6{`HEX_OFF}}};

            /* ScrollingDisplay States */

            `DisplayCase_A_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_C, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};

            `DisplayCase_B_J_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_P, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};
            `DisplayCase_C_K_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_E, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};
            `DisplayCase_D_L_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_N, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};
            `DisplayCase_E_M_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_OFF, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};

            `DisplayCase_F_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_3, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};
            `DisplayCase_G_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_1, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};
            `DisplayCase_H_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_1, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};
            `DisplayCase_I_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {{2{1'b1}}, `HEX_C, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};

            `DisplayCase_N__R_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {1'b0, 1'b1, `HEX_OFF, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};

            /* EndDisplay States */

            `DisplayCase_S_V_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {{2{1'b1}}, `HEX_b, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};
            `DisplayCase_T_W_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {{2{1'b1}}, `HEX_y, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};
            `DisplayCase_U_X_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {{2{1'b1}}, `HEX_e, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};

            `DisplayCase_Y__c_State : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5}
                = {{2{1'b1}}, `HEX_OFF, current_hex0, current_hex1, current_hex2, current_hex3, current_hex4};

            default : {ledr_en, hex_en, next_hex0, next_hex1, next_hex2, next_hex3, next_hex4, next_hex5} = {44{1'bx}};
        endcase
    end
endmodule : statemachine