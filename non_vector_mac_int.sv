`timescale 1ns/1ps
module  non_vector_MAC_int #(parameter REG_WIDTH = 16) (clk,a_n_1,b_n_1,c_n_1,c_ab);
    
    input clk;
    input [REG_WIDTH-1:0] a_n_1;
    input [REG_WIDTH-1:0] b_n_1 ;
    input [REG_WIDTH-1:0] c_n_1;
    // output logic [REG_WIDTH-1:0] a_n; 
    // output logic [REG_WIDTH-1:0] b_n; 
    output logic [REG_WIDTH-1:0] c_ab;

    always@(posedge clk) 
        begin
        c_ab <=  ( a_n_1 * b_n_1) + c_n_1;
        end
endmodule