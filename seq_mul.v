`timescale 1ns / 1ps
module seq_mul(clk,start,a,b,op);
    input [3:0] a,b;
    input clk,start;
    output [7:0] op;

    wire [8:0] p;
    wire [3:0] t,c,a1;
    wire ld,load,shift,cy;
    wire [1:0] out;

    reg4 rg1(clk, start, a, a1);

    assign t[0] = a1[0] & p[0]; 
    assign t[1] = a1[1] & p[0];
    assign t[2] = a1[2] & p[0]; 
    assign t[3] = a1[3] & p[0];

    ripple_carry_4_bit ad(p[8:5], t, c, cy);

    reg8 rg2(clk, start, ld, cy, c, b, p);

    cnt4 cnt(out, 2'b00, load, en, clk, tc, 2'b10);
    pg pg1(start, tc, en, clk, 1'b0);

    assign load = start | tc;
    assign ld = en;
    assign op = p[8:1];
endmodule
