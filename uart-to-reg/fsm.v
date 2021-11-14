`timescale 1ns/1ns

module fsm
#(parameter N=8)
(input busy,
 input clk,
 input enable,
 input  [N-1:0] data,
 output reg [N/2-1:0] bus_0, bus_1);

localparam  IDLE     = 2'd0,
			NIBBLE_1 = 2'd1,
			NIBBLE_2 = 2'd2;

reg [1:0] current_state;
reg [1:0] next_state;


always @(*) begin
	case (current_state)
		NIBBLE_1 : bus_0 = data[N-1:N/2];
		NIBBLE_2 : bus_1 = data[N/2-1:0];
	endcase
end

always @(posedge clk)
	if (!enable) current_state <= IDLE;
	else 	 	 current_state <= next_state;
	
always @(*)
	next_state = current_state;
	case (current_state)
		IDLE : if (busy == 0 & enable ==1) NIBBLE_1;
		//NIBBLE_1 : xxxxx --- seguir por aquí
	
	endcase

endmodule
