`timescale 1ns/1ps
module test ();

	parameter N = 4; //tamaño en bits 4 = 0000.
	parameter tclk =1;

	reg CLK = 0;
	reg RESET = 1;
	reg ZEROES = 0, ONES = 0;
	wire [N-1:0] BUS;


	initial
		begin
			$dumpfile ("test.vcd");
			$dumpvars;
			#(70*tclk) $finish;
		end
	
	always #(1*tclk) CLK = ~CLK;
	
	initial
		begin
			#(5*tclk) RESET = 0;
			#(4*tclk) ONES = 1;
			#(6*tclk) ONES = 0;
			#(4*tclk) ZEROES = 1;
			#(5*tclk) ZEROES = 0;
			#(4*tclk) ONES = 1;
			#(5*tclk) ONES = 0;
			#(4*tclk) ONES = 1;
			#(5*tclk) ONES = 0;
			#(4*tclk) ZEROES = 1;
			#(6*tclk) ZEROES = 0;
			#(4*tclk) ONES = 1;
		end


	synchro_register uut (CLK, RESET, ZEROES, ONES, BUS);
	
	always #tclk $display (
	 "Time = %0t, CLK = %b,", $time, CLK, 
	 "RESET = %b, ZEROES = %b, ONES = %b, ", RESET, ZEROES, ONES,
	 "BUS = %b", BUS);
endmodule
