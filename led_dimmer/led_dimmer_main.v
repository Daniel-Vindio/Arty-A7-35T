//Example for the implementation of the led dimmer 

`timescale 1ns/1ns
module main 
	(input clk,
	 input [3:0] sw,
	 output led0_b, led1_b, led2_b, led3_b);

	led_dimmer #(.INTENS(4094)) ldmr_0 (clk, sw[0], led0_b);
	led_dimmer #(.INTENS(4074)) ldmr_1 (clk, sw[1], led1_b);
	led_dimmer #(.INTENS(4014)) ldmr_2 (clk, sw[2], led2_b);
	led_dimmer #(.INTENS(3094)) ldmr_3 (clk, sw[3], led3_b);
	
endmodule
