`timescale 1ns/1ns

module test ();

	parameter tclk = 5; //In ns. Arty 7 -> 100 MHz -> Period = 10 ns.

	reg CLK = 0, BTN = 0; 
	wire BTN_DBOUN;

	initial
		begin
			$dumpfile ("btn_debouncer.vcd");
			$dumpvars;
			#(2.2e6*tclk) $finish; //xe6*tclk -> x*tclk ms.
		end
	
	always #(1*tclk) CLK = ~CLK;
	
	initial
		begin
			#(1e6*tclk) BTN = 1;
			#(1e5*tclk) BTN = 0;
			#(1e5*tclk) BTN = 1;
		    #(1e5*tclk) BTN = 0;
		    #(1e5*tclk) BTN = 1;
		    #(1e5*tclk) BTN = 0;
		end


	btn_debouncer_syn uut (CLK, BTN, BTN_DBOUN);
	
	always #tclk $display ("Time = %0t  CLK = %b, BTN = %b, BTN_DBOUN = %b", 
				 $time, CLK, BTN, BTN_DBOUN);

endmodule
