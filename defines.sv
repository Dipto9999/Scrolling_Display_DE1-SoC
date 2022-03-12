`define CLOCK_CYCLE 4'd10

/**************************/
/* StateMachine Encodings */
/**************************/

`define ResetState 5'b00000

/* ScrollingDisplay States */

`define DisplayCase_A_State 5'b00001

`define DisplayCase_B_J_State 5'b00010
`define DisplayCase_C_K_State 5'b00011
`define DisplayCase_D_L_State 5'b00100
`define DisplayCase_E_M_State 5'b00101

`define DisplayCase_F_State 5'b00110
`define DisplayCase_G_State 5'b00111
`define DisplayCase_H_State 5'b01000
`define DisplayCase_I_State 5'b01001

`define DisplayCase_N__R_State 5'b01010

/* EndDisplay States */

`define DisplayCase_S_V_State 5'b01011
`define DisplayCase_T_W_State 5'b01100
`define DisplayCase_U_X_State 5'b01101

`define DisplayCase_Y__c_State 5'b01110

/*****************/
/* HEX Encodings */
/*****************/

`define HEX_OFF 7'b1111111

`define HEX_C 7'b1000110
`define HEX_P 7'b0001100
`define HEX_E 7'b0000110
`define HEX_N 7'b1001000
`define HEX_3 7'b0110000
`define HEX_1 7'b1111001

`define HEX_b 7'b0000011
`define HEX_y 7'b0010001
`define HEX_e 7'b0000100

/******************/
/* LEDR Encodings */
/******************/

/* One-Hot LEDR Counter */
`define LEDR_0 10'b0000000000
`define LEDR_1 10'b0000000001
`define LEDR_2 10'b0000000010
`define LEDR_3 10'b0000000100
`define LEDR_4 10'b0000001000
`define LEDR_5 10'b0000010000
`define LEDR_6 10'b0000100000
`define LEDR_7 10'b0001000000
`define LEDR_8 10'b0010000000
`define LEDR_9 10'b0100000000
`define LEDR_10 10'b1000000000

/* Flickering LEDR */
`define LEDR_1A 10'b10_10_10_10_10
`define LEDR_1B 10'b0_10_10_10_10_1
`define LEDR_2A 10'b00_100_100_10
`define LEDR_2B 10'b0_100_100_100
`define LEDR_2C 10'b100_100_100_1
`define LEDR_ON 10'b1111111111
