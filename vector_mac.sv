`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2022 19:50:13
// Design Name: 
// Module Name: (*DONT_TOUCH="YES"*) PE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`ifdef USE_DSP
//    (* use_dsp = "yes" *)
//`else 
    (* use_dsp = "no" *)
//`endif

//`ifdef DONT_USE_DSP
//    (* use_dsp = "no" *)
//`endif
    

module  vector_MAC_int #(parameter REG_WIDTH = 16, VECTOR = 8) (clk,a_n_1,b_n_1,c_n_1,c_ab);
    
    input clk;
    input [REG_WIDTH-1:0] a_n_1[VECTOR - 1:0] ;
    input [REG_WIDTH-1:0] b_n_1[ VECTOR-1: 0] ;
    input [(2*INPUT_LENGTH-1):0] c_n_1[VECTOR - 1:0] ;
    // output logic [REG_WIDTH-1:0] a_n[VECTOR - 1:0]; //NEED NOT BE REG, JUST USED HERE TO SIMPLIFY
    // output logic [REG_WIDTH-1:0] b_n[ VECTOR-1: 0]; // POINT OF OPTIMISATION, CAN REMOVE REG
    output logic [REG_WIDTH-1:0] c_ab[VECTOR - 1:0];

    genvar j;
    generate
        for(j=0;j<VECTOR;j=j+1) begin 
        // always@(posedge clk)
            begin
            c_ab[j] <=  ( a_n_1[j] * b_n_1[j]) + c_n_1[j];
            end
    end
endgenerate


    // reg [VECTOR - 1: 0] i;
    // always @(posedge clk) begin
    //     a_n <= a_n_1;
    //     b_n <= b_n_1;
    // end
endmodule


module  vector_MAC_float #(parameter VECTOR = 8,E_WIDTH = 5, M_WIDTH = 10, I_WIDTH= M_WIDTH +E_WIDTH +1) (clk,a_n_1,b_n_1,c_n_1,c_ab);
    
    input clk;
    input [I_WIDTH-1:0] a_n_1[VECTOR - 1:0] ;
    input [I_WIDTH-1:0] b_n_1[ VECTOR-1: 0] ;
    input [I_WIDTH-1:0] c_n_1[VECTOR - 1:0] ;
    // output logic [I_WIDTH-1:0] a_n[VECTOR - 1:0]; //NEED NOT BE REG, JUST USED HERE TO SIMPLIFY
    // output logic [I_WIDTH-1:0] b_n[ VECTOR-1: 0]; // POINT OF OPTIMISATION, CAN REMOVE REG
    output logic [I_WIDTH-1:0] c_ab[VECTOR - 1:0];

    genvar j;
    generate
        for(j=0;j<VECTOR;j=j+1) begin 
        always@(posedge clk) begin
            // c_ab[j] <=  ( a_n_1[j] * b_n_1[j]) + c_n_1[j];
            mac #(.E_WIDTH(E_WIDTH), .M_WIDTH(M_WIDTH), .I_WIDTH(M_WIDTH +E_WIDTH +1) ) uut (.a(a_n_1[j]),.b(b_n_1[j]),.c(c_n_1[j],.out(c_ab[j])));
            end
    end
endgenerate


    // reg [VECTOR - 1: 0] i;
    // always @(posedge clk) begin
    //     a_n <= a_n_1;
    //     b_n <= b_n_1;
    // end
endmodule