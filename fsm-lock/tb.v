`timescale 1ns/1ns

module test();

parameter tclk = 5; 

reg clk = 1;
reg onoff = 1;
reg reset = 0;
reg oops  = 0;
reg enter = 0;
reg [3:0] login;
wire [3:0] loginled;
wire [3:0] flag;

initial
	begin
		$dumpfile ("waves.vcd");
		$dumpvars;
	end
	
always #(1*tclk) clk = ~clk;
	
initial
	begin
		#(6*tclk) onoff = 0;
		#(6*tclk) login = 4'b1111; 
		#(6*tclk) enter = 1;
		#(15*tclk) enter = 0;
		#(15*tclk) oops = 1;
		#(15*tclk) oops = 0;
		#(15*tclk) login = 4'b1001;
		#(15*tclk) enter = 1;
		#(15*tclk) enter = 0;		
		#(15*tclk)  $finish;		
	end

lock uut (clk, onoff, reset, oops, enter, login, loginled, flag);

endmodule










