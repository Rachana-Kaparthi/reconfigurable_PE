`timescale 1ns/1ps
`include "vector_mac.sv"
`include "non_vector_mac_float.sv"
module top_module #(parameter INPUT_BITWIDTH = 8,VECTOR_LENGTH =8)(mode, reset, clk, a, b, c, out);
//mode =  00_0_0 -> non_vector integer addition
//mode =  01_0_0 -> non_vector integer subtraction
//mode =  10_0_0 -> non_vector integer multiplication
//mode =  11_0_0 -> non_vector integer mac
//mode =  00_1_0 -> non_vector float addition
//mode =  01_1_0 -> non_vector float subtraction
//mode =  10_1_0 -> non_vector float multiplication
//mode =  11_1_0 -> non_vector float mac

//mode =  00_0_1 -> vector integer addition
//mode =  01_0_1 -> vector integer subtraction
//mode =  10_0_1 -> vector integer multiplication
//mode =  11_0_1 -> vector integer mac
//mode =  00_1_1 -> vector float addition
//mode =  01_1_1 -> vector float subtraction
//mode =  10_1_1 -> vector float multiplication
//mode =  11_1_1 -> vector float mac

endmodule