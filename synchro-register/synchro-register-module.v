/*
The objective of this module is to capture a nibble (4 bits) by means 
of the buttons (push-buttons) of Arty A7. For this, the data entry is 
synchronized and subsequently stored in a register. The zeros are 
entered using one of the buttons and the ones with a different button. 
It also has a reset button to erase the generated data bus. This 
version admits indefinite data entry, that is, the fifth bit that is 
entered deletes the one entered first. The last data entered is the 
least significant bit.
*/

module synchro_register
	#(parameter N = 4) // 4 bits = 1 "nibble".
	(input clk, 
	 input reset,
	 input zeroes, ones,
	 output reg [N-1:0] bus);

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

	always @(posedge clk, posedge reset)
		if (reset) begin
				bus <= 0;
			end
		else begin
			if (zeroes_syn)    bus <= {bus[N-2:0], 1'b0};
			else if (ones_syn) bus <= {bus[N-2:0], 1'b1};
		end
endmodule
