// Daniel Gutiérrez
// audobra@gmail.com
// Nov 20, 2021

//Finite state machine to feed the TX module. It is used to divide the 
//message into 8-bit fragments (which precisely match the ASCII 
//characters of the message).
`timescale 1ns/1ns

module test();

parameter N = 8, M = 128;
parameter tclk = 5; 

reg busy = 1;			
reg clk = 0;
reg start = 1;			
reg reset = 1;
reg  [M-1:0] data = "Wake up, Neo...";
wire enable;			
wire[N-1:0] bus;

	initial
		begin
			$dumpfile ("fsm_2.vcd");
			$dumpvars;
		end
	
	always #(1*tclk) clk = ~clk;
	
	initial
		begin
			#(20*tclk) start = 1; busy = 0; reset = 0;
			#(20*tclk) busy = 1; start = 0;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
						
			$finish;
		end


fsm uut (busy, clk, start, reset, data, enable, bus);

	always #tclk $display (
	"Time = %0t, CLK = %b,", $time, clk,
	//"busy = %b, start = %b, reset = %b,", busy, start, reset,
	"data = %h, enable = %b bus = %h", data, enable, bus);

endmodule














