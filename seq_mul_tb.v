`timescale 1ns / 100ps
module seq_mul_tb;

	// Inputs
	reg clk;
	reg start;
	reg [7:0] a;
	reg [7:0] b;

   wire [15:0] op;
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

		//reset
		#100;
        start = 1;
		a = 8'b01011101;
		b = 8'b10110101;
		#25;
		start = 0;
		a = 0;
		b = 0;
		#160 $finish;
	end
		// #150;
		// start = 1;
		//   a = 4'b0101;
		// b = 4'b0011;
		// #20;
		// start = 0;
		//   a = 0;
		// b = 0;

		// #150;
		// start = 1;
		//   a = 4'b1001;
		// b = 4'b0101;
		// #20;
		// start = 0;
		//   a = 0;
		// b = 0;
	// 	#100 $finish;
	// end
      
endmodule

