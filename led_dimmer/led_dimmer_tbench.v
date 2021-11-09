`timescale 1ns/1ps

module test ();

	parameter tclk = 5; //In ns. Arty 7 -> 100 MHz -> Period = 10 ns.

	reg  CLK = 0;
	reg  SW0 = 0, SW1 = 0, SW2 = 0, SW3 = 0; 
	wire LED0, LED1, LED2, LED3;

	initial
		begin
			$dumpfile ("led_test.vcd");
			$dumpvars;
			#(1e5*tclk) $finish;
		end
	
	always #(1*tclk) CLK = ~CLK;
	
	initial
		begin
			#(0*tclk)   SW0 = 1; SW1 = 1; SW2 = 1; SW3 = 1; 
		end


	led_dimmer #(.INTENS(4094)) ldmr_0 (CLK, SW0, LED0);
	led_dimmer #(.INTENS(4000)) ldmr_1 (CLK, SW1, LED1);
	led_dimmer #(.INTENS(3000)) ldmr_2 (CLK, SW2, LED2);
	led_dimmer #(.INTENS(100))  ldmr_3 (CLK, SW3, LED3);
	
	always #tclk $display (
	"Time = %0t, CLK = %b,", $time, CLK,
	"SW0 = %b, SW01 = %b, SW02 = %b,SW03 = %b,", SW0, SW1, SW2, SW3,
	"LED0 = %b, LED1 = %b LED2 = %b, LED3 = %b", LED0, LED1, LED2, LED3);

endmodule
