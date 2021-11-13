`timescale 1ns/1ps

module test ();

	parameter tclk = 5; //In ns. Arty 7 -> 100 MHz -> Period = 10 ns.
	parameter WORDSZ = 8;
	reg CLK = 0;
	reg 				RXD_PIN; // UART Recieve pin.
	reg 				SW_0;	 //Slide switch to enable reception.
	wire [WORDSZ-1:0] 	BUS;
	wire [3:0] 			STATE;
	
	initial
		begin
			$dumpfile ("uart_to_reg.vcd");
			$dumpvars;
			#(2.2e6*tclk) $finish; //xe6*tclk -> x*tclk ms.
		end
	
	always #(1*tclk) CLK = ~CLK;
	
	initial
		begin
			//#(1e6*tclk) BTN = 1;
		end


	uart_to_reg uut (CLK, RXD_PIN, SW_0, BUS, STATE);
	
	always #tclk $display (
		"Time = %0t, "  ,$time,
		"CLK  = %b, "   ,CLK,
		"RXD_PIN = %b, ",RXD_PIN,
		"SW_0 = %b, "   ,SW_0,
		"BUS = %b, "    ,BUS,
		"STATE =%B"     ,STATE);

endmodule
