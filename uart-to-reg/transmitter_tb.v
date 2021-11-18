//Finite state machine to feed the TX module. It is used to divide the 
//message into 8-bit fragments (which precisely match the ASCII 
//characters of the message).
`timescale 1ns/1ns

module test();

parameter N = 8, M = 128;
parameter tclk = 5; 

reg clk = 0;
reg  [M-1:0] data = "Wake up, Neo...";
reg btn_start = 0;			
reg reset = 1;
wire txd_pin;
wire [3:0] led;


	initial
		begin
			$dumpfile ("transmitter.vcd");
			$dumpvars;
		end
	
	always #(1*tclk) clk = ~clk;
	
	initial
		begin
			#(100*tclk) reset = 0;		
			//#(20*tclk) btn_start = 1;
			//#(20*tclk) btn_start = 0;
			#(1e6*tclk) btn_start = 1;
			#(1e5*tclk) btn_start = 0;
			#(1e6*tclk) btn_start = 1;
			#(1e5*tclk) btn_start = 0;
			wait(!led[0]);
			//#(1e6*tclk) btn_start = 1;
			//#(1e5*tclk) btn_start = 0;
						
			$finish;
		end


transmitter uut (clk, data, btn_start, reset, txd_pin, led);

	/*
	always #tclk $display (
	"Time = %0t, CLK = %b,", $time, clk,
	//"busy = %b, btn_start = %b, reset = %b,", busy, btn_start, reset,
	"data = %h, btn_start = %b txd_pin = %h", data, btn_start, txd_pin);
	*/
endmodule














