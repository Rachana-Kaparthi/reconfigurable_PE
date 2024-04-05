`timescale 1ns/1ps
`include "vector_mac.sv"
`include "non_vector_mac_float.sv"
`include "non_vector_mac_int.sv"

module top_module #(parameter INPUT_LENGTH = 8,parameter VECTOR_LENGTH =1,
parameter E_WIDTH=5, parameter M_WIDTH=10, parameter I_WIDTH= M_WIDTH +E_WIDTH +1)(mode, reset, clk, a, b, c, out);
//mode =  00_0 -> non_vector integer addition
//mode =  01_0 -> non_vector integer subtraction
//mode =  10_0 -> non_vector integer multiplication
//mode =  11_0 -> non_vector integer mac
//mode =  00_1 -> non_vector float addition
//mode =  01_1 -> non_vector float subtraction
//mode =  10_1 -> non_vector float multiplication
//mode =  11_1 -> non_vector float mac


input clk;
input rst;
input [2:0] mode;
input [INPUT_LENGTH-1:0] a [VECTOR_LENGTH-1:0];
input [INPUT_LENGTH-1:0] b [VECTOR_LENGTH-1:0];
input [INPUT_LENGTH-1:0] c [VECTOR_LENGTH-1:0];
output logic [(2*INPUT_LENGTH-1):0] out [0:VECTOR_LENGTH-1];

genvar i;
generate
    for(i=0;i<VECTOR_LENGTH;i++) 
// if (mode[0]== 1'b0) //mode[0]==0 -> non_vector operations
    begin
    if(mode[0] == 0) //integer unit
        begin
            if(mode[2:1]==2'b00) //addition
            begin 
                // assign b[i]=[INPUT_LENGTH-1:0]'b1;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_LENGTH)) add_int(.clk(clk),.a_n_1(a[i]),.b_n_1('d1),.c_n_1(c[i]),.c_ab(out[i]));
            end
            else if(mode[2:1]==2'b01) //subtraction
            begin 
                // assign b=[INPUT_LENGTH-1:0]'b1;
                assign c=(-1)*c;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_LENGTH)) sub_int (.clk(clk),.a_n_1(a[i]),.b_n_1('d1),.c_n_1(c[i]),.c_ab(out[i]));
            end
            else if(mode[2:1]==2'b10) //multiplication
            begin 
                // assign c[i]= '0;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_LENGTH)) mul_int (.clk(clk),.a_n_1(a[i]),.b_n_1(b[i]),.c_n_1('d0),.c_ab(out[i]));
            end
            else if(mode[2:1]==2'b11) //mac operation
            begin 
                non_vector_MAC_int #(.REG_WIDTH (INPUT_LENGTH)) mac_int (.clk(clk),.a_n_1(a[i]),.b_n_1(b[i]),.c_n_1(c[i]),.c_ab(out[i]));
            end
        end
    else  // float unit
        begin
            if(mode[2:1]==2'b00) //addition
            begin 
                non_vector_mac_float #(.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH)) (.a(a[i]),.b(32'h0x3f800000),.c(c[i]),.out(out[i]));
            end
            else if(mode[2:1]==2'b01) //subtraction
            begin 
                c[i][INPUT_LENGTH-1] = ~c[i][INPUT_LENGTH-1];
                non_vector_mac_float #(.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.a(a[i]),.b(32'h0x3f800000),.c(c[i]),.out(out[i]));
            end
            else if(mode[2:1]==2'b10) //multiplication
                non_vector_mac_float #(.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.a(a[i]),.b(b[i]),.c('b0),.out(out[i]));
            begin 
            end
            else if(mode[2:1]==2'b11) //mac_operation
                non_vector_mac_float #(.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.a(a[i]),.b(b[i]),.c(c[i]),.out(out[i]));
            begin 
            end
        end
    end
endgenerate
// else // mode[0]==1 -> vector_operation
//     begin
//     if(mode[1] == '0) //integer unit
//         begin
//             if(mode[3:2]==2'b00) //addition
//             begin 

//                 vector_MAC_int #(.REG_WIDTH(INPUT_LENGTH) , .VECTOR(VECTOR_LENGTH)) add_int_vec(.clk(clk),.a_n_1(a),.b_n_1(b),.c_n_1(c),.c_ab(out));
//             end
//             else if(mode[3:2]==2'b01) //subtraction
//             begin 
//             end
//             else if(mode[3:2]==2'b10) //multiplication
//             begin 
//             end
//             else if(mode[3:2]==2'b11) //mac operation
//             begin 
//             end
//         end
//     else  //float unit
//         begin
//             if(mode[3:2]==2'b00) //addition
//             begin 

//             end
//             else if(mode[3:2]==2'b01) //subtraction
//             begin 
//             end
//             else if(mode[3:2]==2'b10) //multiplication
//             begin 
//             end
//             else if(mode[3:2]==2'b11) //mac operation
//             begin 
//             end
//         end
//     end

endmodule