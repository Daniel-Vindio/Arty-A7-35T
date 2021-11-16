`timescale 1ns/1ns

module fsm
#(parameter N = 8,
  parameter M = 16)		//Size of message to send.
(input busy,			//Signal from TX module.
 input clk,
 input start,			//Signal to start fsm.
 input reset,
 input  [M-1:0] data,
 output reg enable,			//Signal to TX module
 output reg [N-1:0] bus);

localparam  IDLE   = 2'd0,
			BYTE_1 = 2'd1,
			BYTE_2 = 2'd2,
			STOP   = 2'd3;

reg [1:0] current_state;
reg [1:0] next_state;


//Outputs of every state.
always @(*) begin
	case (current_state)
		IDLE   : bus = {N{1'b0}};
		BYTE_1 : begin 
					enable = 1'b1;					
					bus = data[M-1:M/2];
				 end
		BYTE_2 : bus = data[M/2-1:0];
		STOP   : enable = 1'b0;					
	endcase
end

//Synchronous state transition.
always @(posedge clk)
	if (reset) current_state <= IDLE;
	else 	 	 current_state <= next_state;

//Conditional state transitions.	
always @(*) begin
	next_state = current_state;
	  case (current_state)
		IDLE   : if ( !(busy & enable) ) next_state = BYTE_1;
		BYTE_1 : if ( !busy ) 			 next_state = BYTE_2;
		BYTE_2 : if ( !busy ) 			 next_state = STOP;
		STOP   : 						 next_state = IDLE;
		default : 						 next_state = IDLE;
	  endcase
	end
endmodule

module test();

parameter N = 8, M = 16;
parameter tclk = 5; 

reg busy = 1;			
reg clk = 0;
reg start = 1;			
reg reset = 1;
reg  [M-1:0] data = "AB";
wire enable;			
wire[N-1:0] bus;

	initial
		begin
			$dumpfile ("fsm.vcd");
			$dumpvars;
		end
	
	always #(1*tclk) clk = ~clk;
	
	initial
		begin
			#(20*tclk) start = 0; busy = 0; reset = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
						
			$finish;
		end


fsm uut (busy, clk, start, reset, data, enable, bus);

	always #tclk $display (
	"Time = %0t, CLK = %b,", $time, clk,
	"busy = %b, start = %b, reset = %b,", busy, start, reset,
	"data = %h, enable = %b bus = %h", data, enable, bus);

endmodule














