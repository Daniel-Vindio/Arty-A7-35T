// Daniel Gutiérrez
// audobra@gmail.com
// Nov 20, 2021


module main
	#(parameter WORD = 4)
	(input clk,
	 input btn_zero, btn_one,
	 input reset, swich,
	 output [3:0] ledg, ledb);
	 
	wire [WORD-1:0] bus_a, bus_b;

	wire btn_zero_dboun, btn_one_dboun;
	btn_debouncer dbncer_zero (clk, btn_zero, btn_zero_dboun);
	btn_debouncer dbncer_one (clk, btn_one, btn_one_dboun);

	reg reset_a, btn_zero_dboun_a, btn_one_dboun_a;
	reg reset_b, btn_zero_dboun_b, btn_one_dboun_b;

	always @*
	case (swich)
	  0 : begin
		 reset_a <= reset;
		 btn_zero_dboun_a <= btn_zero_dboun;
		 btn_one_dboun_a  <= btn_one_dboun;
	  end 
	  1 : begin
		 reset_b <= reset;
		 btn_zero_dboun_b <= btn_zero_dboun;
		 btn_one_dboun_b  <= btn_one_dboun;
	  end
	endcase
	
	synchro_register input_a 
		(.clk    (clk),
		.reset  (reset_a), 
		.zeroes (btn_zero_dboun_a),
		.ones (btn_one_dboun_a),
		.bus    (bus_a));
	
	synchro_register input_b (clk, reset_b, 
		btn_zero_dboun_b, btn_one_dboun_b, bus_b);

	led_dimmer led_a0 (clk, bus_a[0], ledg[0]);
	led_dimmer led_a1 (clk, bus_a[1], ledg[1]);
	led_dimmer led_a2 (clk, bus_a[2], ledg[2]);
	led_dimmer led_a3 (clk, bus_a[3], ledg[3]);

	led_dimmer led_b0 (clk, bus_b[0], ledb[0]);
	led_dimmer led_b1 (clk, bus_b[1], ledb[1]);
	led_dimmer led_b2 (clk, bus_b[2], ledb[2]);
	led_dimmer led_b3 (clk, bus_b[3], ledb[3]);

endmodule
