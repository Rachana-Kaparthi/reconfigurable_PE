`timescale 1ns/1ps
`include "vector_mac.sv"
`include "non_vector_mac_float.sv"
module top_module #(parameter INPUT_BITWIDTH = 8,VECTOR_LENGTH =1)(mode, reset, clk, a, b, c, out);
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

input clk;
input rst;
input [3:0] mode;
input [INPUT_LENGTH-1:0] a [VECTOR_LENGTH-1:0];
input [INPUT_LENGTH-1:0] b [VECTOR_LENGTH-1:0];
input [INPUT_LENGTH-1:0] c [VECTOR_LENGTH-1:0];
output logic [(2*INPUT_LENGTH-1):0] out [0:VECTOR_LENGTH-1];

if (mode[0]== 1'b0) //mode[0]==0 -> non_vector operations
    begin
    if(mode[1] == 0) //integer unit
        begin
            if(mode[3:2]==2'b00) //addition
            begin 
                assign b=[INPUT_LENGTH-1:0]'b1;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_LENGTH)) (.clk(clk),.a_n_1(a),.b_n_1(b),.c_n_1(c),.c_ab(out));
            end
            else if(mode[3:2]==2'b01) //subtraction
            begin 
                assign b=[INPUT_LENGTH-1:0]'b1;
                assign c=(-1)*c;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_LENGTH)) (.clk(clk),.a_n_1(a),.b_n_1(b),.c_n_1(c),.c_ab(out));
            end
            else if(mode[3:2]==2'b10) //multiplication
            begin 
                assign c= '0;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_LENGTH)) (.clk(clk),.a_n_1(a),.b_n_1(b),.c_n_1(c),.c_ab(out));
            end
            else if(mode[3:2]==2'b11) //mac operation
            begin 
                non_vector_MAC_int #(.REG_WIDTH (INPUT_LENGTH)) (.clk(clk),.a_n_1(a),.b_n_1(b),.c_n_1(c),.c_ab(out));
            end
        end
    else  // float unit
        begin
            if(mode[3:2]==2'b00) 
            begin 
            end
            else if(mode[3:2]==2'b01)
            begin 
            end
            else if(mode[3:2]==2'b10)
            begin 
            end
            else if(mode[3:2]==2'b11)
            begin 
            end
        end
    end
else // vector_operation
    begin
    if(mode[1] == 0) //integer unit
        begin
            if(mode[3:2]==2'b00) //addition
            begin 

            end
            else if(mode[3:2]==2'b01) //subtraction
            begin 
            end
            else if(mode[3:2]==2'b10) //multiplication
            begin 
            end
            else if(mode[3:2]==2'b11) //mac operation
            begin 
            end
        end
    else  //float unit
        begin
            if(mode[3:2]==2'b00) //addition
            begin 

            end
            else if(mode[3:2]==2'b01) //subtraction
            begin 
            end
            else if(mode[3:2]==2'b10) //multiplication
            begin 
            end
            else if(mode[3:2]==2'b11) //mac operation
            begin 
            end
        end
    end

endmodule