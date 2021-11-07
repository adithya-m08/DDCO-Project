`timescale 1ns / 100ps
module seq_mul_tb;

	// Inputs
	reg clk;
	reg start;
	reg [3:0] a;
	reg [3:0] b;

   wire [7:0] op;
	initial begin $dumpfile("tb.vcd"); $dumpvars(0,seq_mul_tb); end
	seq_mul uut (
		.clk(clk), 
		.start(start), 
		.a(a), 
		.b(b),
		.op(op)
	);

always #10 clk = ~clk;
	initial begin
		clk = 0;
		start = 0;
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#109.5;
        start = 1;
		  a = 4'b1001;
		b = 4'b1101;
		#20;
		start = 0;
		  a = 0;
		b = 0;
		// Add stimulus here
		#100 $finish;
	end
      
endmodule
