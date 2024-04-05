`timescale 1ns/1ps
`include "vector_mac.sv"
`include "non_vector_mac_float.sv"
module top_module #(parameter INPUT_BITWIDTH = 8, parameter VECTOR_LENGTH =1,
parameter E_WIDTH=5, parameter M_WIDTH=10, parameter I_WIDTH= M_WIDTH +E_WIDTH +1)(mode, reset, clk, a, b, c, out);
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
input [INPUT_BITWIDTH-1:0] a [VECTOR_LENGTH-1:0];
input [INPUT_BITWIDTH-1:0] b [VECTOR_LENGTH-1:0];
input [INPUT_BITWIDTH-1:0] c [VECTOR_LENGTH-1:0];
output logic [(2*INPUT_BITWIDTH-1):0] out [0:VECTOR_LENGTH-1];
integer i,j;

if (mode[0]== 1'b0) //mode[0]==0 -> non_vector operations
    begin
    if(mode[1] == 0) //integer unit
        begin
            if(mode[3:2]==2'b00) //addition
            begin 
                // assign b=[INPUT_LENGTH-1:0]'b1;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_BITWIDTH)) (.clk(clk),.a_n_1(a),.b_n_1('d1),.c_n_1(c),.c_ab(out));
            end
            else if(mode[3:2]==2'b01) //subtraction
            begin 
                // assign b=[INPUT_LENGTH-1:0]'d1;
                assign c=(-1)*c;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_BITWIDTH)) (.clk(clk),.a_n_1(a),.b_n_1('d1),.c_n_1(c),.c_ab(out));
            end
            else if(mode[3:2]==2'b10) //multiplication
            begin 
                // assign c= '0;
                non_vector_MAC_int #(.REG_WIDTH (INPUT_BITWIDTH)) (.clk(clk),.a_n_1(a),.b_n_1(b),.c_n_1('d0),.c_ab(out));
            end
            else if(mode[3:2]==2'b11) //mac operation
            begin 
                non_vector_MAC_int #(.REG_WIDTH (INPUT_BITWIDTH)) (.clk(clk),.a_n_1(a),.b_n_1(b),.c_n_1(c),.c_ab(out));
            end
        end
    else  // float unit
        begin
            if(mode[3:2]==2'b00) //addition
            begin 
                non_vector_mac_float #(.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH)) (.a(a),.b(32'h0x3f800000),.c(c),.out(out));
            end
            else if(mode[3:2]==2'b01) //subtraction
            begin 
                c[INPUT_BITWIDTH-1] = ~c[INPUT_BITWIDTH-1];
                non_vector_mac_float #(.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.a(a),.b(32'h0x3f800000),.c(c),.out(out));
            end
            else if(mode[3:2]==2'b10) //multiplication
                non_vector_mac_float #(.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.a(a),.b(b),.c('b0),.out(out));
            begin 
            end
            else if(mode[3:2]==2'b11)
                non_vector_mac_float #(.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.a(a),.b(b),.c(c),.out(out));
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
                for(i=0;i<VECTOR_LENGTH;i=i+1) begin
                    vector_MAC_int #(.REG_WIDTH (INPUT_BITWIDTH),.VECTOR(VECTOR_LENGTH)) (.clk(clk),.a_n_1(a[i]),.b_n_1('d1),.c_n_1(c[i]),.c_ab(out[i]));
                end
            end
            else if(mode[3:2]==2'b01) //subtraction
            begin 
                for(i=0;i<VECTOR_LENGTH;i=i+1) begin
                    assign c[i]=(-1)*c[i];
                    vector_MAC_int #(.REG_WIDTH (INPUT_BITWIDTH),.VECTOR(VECTOR_LENGTH)) (.clk(clk),.a_n_1(a[i]),.b_n_1('d1),.c_n_1(c[i]),.c_ab(out[i]));
                end
            end
            else if(mode[3:2]==2'b10) //multiplication
            begin 
                for(i=0;i<VECTOR_LENGTH;i=i+1) begin
                    vector_MAC_int #(.REG_WIDTH (INPUT_BITWIDTH),.VECTOR(VECTOR_LENGTH)) (.clk(clk),.a_n_1(a[i]),.b_n_1(b[i]),.c_n_1('d0),.c_ab(out[i]));
                end
            end
            else if(mode[3:2]==2'b11) //mac operation
            begin 
                for(i=0;i<VECTOR_LENGTH;i=i+1) begin
                    vector_MAC_int #(.REG_WIDTH (INPUT_BITWIDTH),.VECTOR(VECTOR_LENGTH)) (.clk(clk),.a_n_1(a[i]),.b_n_1(b[i]),.c_n_1(c[i]),.c_ab(out[i]));
                end
            end
        end
    else  //float unit
        begin
            if(mode[3:2]==2'b00) //addition
            begin 
                for (i=0;i<VECTOR_LENGTH;i=i+1) begin
                MAC_float #(.VECTOR(VECTOR_LENGTH),.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.clk(clk),.a_n_1(a[i]),.b_n_1(32'h0x3f800000),.c_n_1(c[i]),.c_ab(out[i]));
                end
            end
            else if(mode[3:2]==2'b01) //subtraction
            begin 
                for (i=0;i<VECTOR_LENGTH;i=i+1) begin
                c[i][INPUT_BITWIDTH-1] = ~c[i][INPUT_BITWIDTH-1];
                MAC_float #(.VECTOR(VECTOR_LENGTH),.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.clk(clk),.a_n_1(a[i]),.b_n_1(32'h0x3f800000),.c_n_1(c[i]),.c_ab(out[i]));
                end
            end
            else if(mode[3:2]==2'b10) //multiplication
            begin 
                for (i=0;i<VECTOR_LENGTH;i=i+1) begin
                MAC_float #(.VECTOR(VECTOR_LENGTH),.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.clk(clk),.a_n_1(a[i]),.b_n_1(b[i]),.c_n_1('d0),.c_ab(out[i]));
                end
            end
            else if(mode[3:2]==2'b11) //mac operation
            begin 
                for (i=0;i<VECTOR_LENGTH;i=i+1) begin
                MAC_float #(.VECTOR(VECTOR_LENGTH),.E_WIDTH(E_WIDTH),.M_WIDTH(M_WIDTH),.I_WIDTH(I_WIDTH))(.clk(clk),.a_n_1(a[i]),.b_n_1('d1),.c_n_1(c[i]),.c_ab(out[i]));
                end
            end
        end
    end

endmodule