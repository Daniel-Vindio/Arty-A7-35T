// Daniel Gutiérrez
// audobra@gmail.com
// Nov 20, 2021

/*
The objective of this module is to capture a nibble (4 bits) by means 
of the buttons (push-buttons) of Arty A7. For this, the data entry is 
synchronized and subsequently stored in a register. The zeros are 
entered using one of the buttons and the ones with a different button. 
It also has a reset button to erase the generated data bus. This 
version admits indefinite data entry, that is, the fifth bit that is 
entered deletes the one entered first. The last data entered is the 
least significant bit.

Finite State Machine (fsm) version.
*/
`timescale 1ns/1ns
module synchro_register
	#(parameter N = 4) // 4 bits = 1 "nibble".
	(input clk, 
	 input reset,
	 input zeroes, ones,
	 output [N-1:0] bus);

	reg sync1, sync2, sync3, sync4;
	reg zeroes_syn, ones_syn;
	always @(posedge clk)
		begin
			sync1 <= zeroes;
			sync2 <= sync1;
			zeroes_syn <= ~sync2 & sync1;
			
			sync3 <= ones;
			sync4 <= sync3;
			ones_syn <= ~sync4 & sync3;
		end

	localparam [N-1:0] S0 = 'b0000;
	localparam [N-1:0] S1 = 'b0001;
	localparam [N-1:0] S2 = 'b0010;
	localparam [N-1:0] S3 = 'b0011;
	localparam [N-1:0] S4 = 'b0100;
	localparam [N-1:0] S5 = 'b0101;
	localparam [N-1:0] S6 = 'b0110;
	localparam [N-1:0] S7 = 'b0111;
	localparam [N-1:0] S8 = 'b1000;
	localparam [N-1:0] S9 = 'b1001;
	localparam [N-1:0] S10 = 'b1010;
	localparam [N-1:0] S11 = 'b1011;
	localparam [N-1:0] S12 = 'b1100;
	localparam [N-1:0] S13 = 'b1101;
	localparam [N-1:0] S14 = 'b1110;
	localparam [N-1:0] S15 = 'b1111;

	reg [N-1:0] current_state, next_state;
	
	always @(posedge clk)
		if (reset) current_state <= S0;
		else current_state <= next_state;

	always @(*) begin
		next_state = current_state;
		
		case (current_state)
			S0 : begin
					if      (zeroes_syn) next_state = S0;
					else if (ones_syn)   next_state = S1;
				 end
			S1 : begin
					if      (zeroes_syn) next_state = S2;
					else if (ones_syn)   next_state = S3;
				 end
			S2 : begin
					if      (zeroes_syn) next_state = S4;
					else if (ones_syn)   next_state = S5;
				 end
			S3 : begin
					if      (zeroes_syn) next_state = S6;
					else if (ones_syn)   next_state = S7;
				 end
			S4 : begin
					if      (zeroes_syn) next_state = S8;
					else if (ones_syn)   next_state = S9;
				 end
			S5 : begin
					if      (zeroes_syn) next_state = S10;
					else if (ones_syn)   next_state = S11;
				 end
			S6 : begin
					if      (zeroes_syn) next_state = S12;
					else if (ones_syn)   next_state = S13;
				 end
			S7 : begin
					if      (zeroes_syn) next_state = S14;
					else if (ones_syn)   next_state = S15;
				 end
			S8  : next_state = S8;
			S9  : next_state = S9;
			S10 : next_state = S10;
			S11 : next_state = S11;
			S12 : next_state = S12;
			S13 : next_state = S13;
			S14 : next_state = S14;
			S15 : next_state = S15;
			default : next_state = S0;
		endcase
	end
	
	assign bus = current_state;

endmodule















