/*
The purpose of this module is to graduate the light intensity of the LED. 
The default intensity is too high, and it dazzles you, especially when 
you have to look at the Arty many times, for example, for debugging. 
This development is based on PWM (Pulse Width Modulation).
INTENS = 0     Unchanged brightness .
INTENS = 4000  Acceptable brightness.
INTENS = 4000  Acceptable brightness.
INTENS = 4094  Minimum brightness.
*/
`timescale 1ns/1ns

module led_dimmer
	#(parameter INTENS = 4000)
	(input clk, data,
	 output reg led);

	reg [11:0] count = 0;

	always @(posedge clk) begin
		case (data)
		  0 : led = 0;
		  1 : begin
				count <= count + 1;
				if (count > INTENS) led = 1;
				else 				led = 0;
			  end
		endcase
	end
endmodule
