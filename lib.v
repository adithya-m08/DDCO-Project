module pg(start,tc,q,clk,reset);
  input start,tc,clk,reset;
  output  q;
    
  wire t1,t2;
  parameter vdd=1'b1;
  parameter gnd=1'b0;

  mux2 M1(t2, vdd, start, q);
  mux2 M2(q, gnd, tc, t1);
  dfr d2(clk, reset, t1, t2);
endmodule

module reg4(input wire clk, en, input wire [3:0] a, output wire [3:0] y);
  dfl dfl_1(clk, en, a[0], y[0]);
  dfl dfl_2(clk, en, a[1], y[1]);
  dfl dfl_3(clk, en, a[2], y[2]);
  dfl dfl_4(clk, en, a[3], y[3]);
endmodule

module reg8(input wire clk,start,ld,cy,input wire [3:0]c,b,output wire [8:0] p);
  wire en2;
  dfl dfl_1(clk, ld, cy, p[8]);
  dfl dfl_2(clk, ld, c[3], p[7]);
  dfl dfl_3(clk, ld, c[2], p[6]);
  dfl dfl_4(clk, ld, c[1], p[5]);
  dfl dfl_5(clk, ld, c[0], p[4]);

  // module mux_df(input wire clk, i0, i1, s, load, output wire z_);
  mux_df muxdf_0(clk, p[4], b[3], start, en2, p[3]);
  mux_df muxdf_1(clk, p[3], b[2], start, en2, p[2]);
  mux_df muxdf_2(clk, p[2], b[1], start, en2, p[1]);
  mux_df muxdf_3(clk, p[1], b[0], start, en2, p[0]);

assign en2 = start | ld;
endmodule

module cnt4(out, data, load, en, clk, tc, lmt);
  output [1:0] out;
  output reg tc;
  input [1:0] data;
  input load, en, clk;
  reg [1:0] out;
  parameter reset=0;
  input [1:0]lmt;
  initial begin out=2'b00; tc=0; end
  always @(posedge clk)
  if (reset) begin out <= 2'b00 ; end 
  else if (load) begin out <= data; end 
  else if (en) out <= out + 2'b01;
  else out <= out;
  always @(posedge clk)
  if (out ==lmt) tc<=1;
  else tc<=0;
endmodule

// test modules for matching ddco lab
module mux2 (input wire i0, i1, j, output wire o);
  assign o = (j==0)?i0:i1;
endmodule

module invert (input wire i, output wire o);
   assign o = !i;
endmodule

module and2 (input wire i0, i1, output wire o);
  assign o = i0 & i1;
endmodule

module fulladd(input wire a,b,cin, output wire sum, cout);
    assign sum = a ^ b ^ cin;
    assign cout = (a&b)+(b&cin)+(cin&a);
endmodule

module mux_df(input wire clk, i0, i1, s, load, output wire z_);
  wire d_in;
  mux2 mux2_0(i0, i1, s, d_in);
  dfl dfl_0(clk, load, d_in, z_);
endmodule

module ripple_carry_4_bit(input wire [3:0] a,b, output wire [3:0] s, output wire cout);
  wire [2:0] c;
  fulladd f_0(a[0], b[0], 1'b0, s[0], c[0]);
  fulladd f_1(a[1], b[1], c[0], s[1], c[1]);
  fulladd f_2(a[2], b[2], c[1], s[2], c[2]);
  fulladd f_3(a[3], b[3], c[2], s[3], cout);
endmodule

module df (input wire clk, in, output wire out);
  reg df_out;
  initial begin df_out = 0; end
  always@(posedge clk) df_out <= in;
  assign out = df_out;
endmodule

module dfr (input wire clk, reset, in, output wire out);
  wire reset_, df_in;
  invert invert_0 (reset, reset_);
  and2 and2_0 (in, reset_, df_in);
  df df_0 (clk, df_in, out);
endmodule

module dfl(input wire clk, load, in, output wire out);
  wire _in;
  mux2 mux2_0(out, in, load, _in);
  df df_0 (clk, _in, out);
endmodule

module dfrl (input wire clk, reset, load, in, output wire out);
  wire _in;
  mux2 mux2_0(out, in, load, _in);
  dfr dfr_1(clk, reset, _in, out);
endmodule