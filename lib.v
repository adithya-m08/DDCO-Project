module mux(A,B,S,Y);

    input  A,B;
    output  Y;
    input S;


assign Y = (S)? B : A;
endmodule

module ha(input a,b,output sum,co);
assign sum = a^b;
assign co = a&b;
endmodule

module fa(a,b,cin,sum,co);
input a,b,cin;
output sum,co; 
wire t1,t2,t3;
ha X1(a,b,t1,t2);
ha X2(cin,t1,sum,t4);
assign co = t2 | t4;
endmodule

module adder_4bit(a,b,sum,cy);
input [3:0] a,b;
output [3:0] sum;
output cy;

fa m1(a[0],b[0],1'b0,sum[0],co1);
fa m2(a[1],b[1],co1,sum[1],co2);
fa m3(a[2],b[2],co2,sum[2],co3);
fa m4(a[3],b[3],co3,sum[3],cy);

endmodule

module DFF(q,clk,reset,d);
    input d,clk,reset;
    output reg q;
initial begin q=0; end
always @ (posedge (clk)) begin
 if (reset)
  q <= 0;
 else  
 q<= d ;
end
endmodule

module fdce(q,clk,ce,d);
    input d,clk,ce;
    output reg q;
initial begin q=0; end
always @ (posedge (clk)) begin
 if (ce)
  q <= d;
 else 
 q<= q ;
end
endmodule

module mux_reg(clk,a,b,s,en,z);
input clk,a,b,s,en;
output z;
wire y;
mux m1(a,b,s,y);
fdce m2(z,clk,en,y);
endmodule

module pg(start,tc,q,clk,reset);
	 input start,tc,clk,reset;
	 output  q;
	 
	 wire t1,t2;
	 parameter vdd=1'b1;
	 parameter gnd=1'b0;
	
    mux M1(t2,vdd,start,q);
	 mux M2(q,gnd,tc,t1);
	 DFF d2(t2,clk,reset,t1);
endmodule

module reg4(y,clk,en,a);
    input [3:0] a;
    output [3:0] y;
    input clk,en;
 
fdce d1(y[0],clk,en,a[0]);
fdce d2(y[1],clk,en,a[1]);
fdce d3(y[2],clk,en,a[2]);
fdce d4(y[3],clk,en,a[3]);

endmodule

module Regbank(clk,start,ld,cy,c,b,p);

input [3:0] c,b;
output [8:0] p;
input clk,start,ld,cy;
wire en1,en2;
fdce f1(p[8],clk,ld,cy);

fdce d1(p[7],clk,ld,c[3]);
fdce d2(p[6],clk,ld,c[2]);
fdce d3(p[5],clk,ld,c[1]);
fdce d4(p[4],clk,ld,c[0]);

mux_reg m5(clk,p[4],b[3],start,en2,p[3]);
mux_reg m6(clk,p[3],b[2],start,en2,p[2]);
mux_reg m7(clk,p[2],b[1],start,en2,p[1]);
mux_reg m8(clk,p[1],b[0],start,en2,p[0]);
assign en2 = start | ld;
endmodule

module cnt4(out,data,load,en,clk,tc,lmt);
output [1:0] out;
output reg tc;
input [1:0] data;
input load, en, clk;
reg [1:0] out;
parameter reset=0;
input [1:0]lmt;
initial begin out=2'b00;
tc=0; end
always @(posedge clk)
if (reset) begin
  out <= 2'b00 ;
end else if (load) begin
  out <= data;
end else if (en)
  out <= out + 2'b01;
else out <= out;
always @(posedge clk)
if (out ==lmt)
tc<=1;
else tc<=0;
endmodule