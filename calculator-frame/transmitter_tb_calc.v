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

reg clk = 0;
reg main_start = 0;
reg reset = 1;
wire txd_pin;
wire [3:0] led;


	initial
		begin
			$dumpfile ("waves.vcd");
			$dumpvars;
		end
	
	always #(1*tclk) clk = ~clk;
	
	initial
		begin
			#(5*tclk) reset = 0; main_start = 1;
			#(2e7*tclk)$finish;
		end


transmitter_calc uut (clk, main_start, reset, txd_pin, led);

endmodule














