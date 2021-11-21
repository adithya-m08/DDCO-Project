`timescale 1ns / 1ps
module seq_mul(clk,start,a,b,op);
    input [7:0] a,b;
    input clk,start;
    output [15:0] op;

    wire [16:0] p;
    wire [7:0] t,c,a1;
    wire ld,load,shift,cy;
    wire [1:0] out;

    reg4 rg1(clk, start, a, a1);

    assign t[0] = a1[0] & p[0]; 
    assign t[1] = a1[1] & p[0];
    assign t[2] = a1[2] & p[0]; 
    assign t[3] = a1[3] & p[0];
    assign t[4] = a1[4] & p[0];
    assign t[5] = a1[5] & p[0];
    assign t[6] = a1[6] & p[0];
    assign t[7] = a1[7] & p[0];

    ripple_carry_4_bit ad(p[16:9], t, c, cy);

    reg8 rg2(clk, start, ld, cy, c, b, p);

    cnt4 cnt(clk, load, en, 3'b000, 3'b100, tc, out);
    pg pg1(clk, 1'b0, start, tc, en);

    assign load = start | tc;
    assign ld = en;
    assign op = p[16:1];
endmodule
