//Finite state machine to feed the TX module. It is used to divide the 
//message into 8-bit fragments (which precisely match the ASCII 
//characters of the message).

`timescale 1ns/1ns

module fsm
#(parameter N = 8,
  parameter M = 128)		//Size of message to send.
(input busy,			//Signal from TX module.
 input clk,
 input start,			//Signal to start fsm.
 input reset,
 input  [M-1:0] data,
 output reg enable,			//Signal to TX module
 output reg [N-1:0] bus);

localparam  IDLE   = 2'd0,
			BYTE_1 = 4'd1,
			BYTE_2 = 4'd2,
			BYTE_3 = 4'd3,
			BYTE_4 = 4'd4,
			BYTE_5 = 4'd5,
			BYTE_6 = 4'd6,
			BYTE_7 = 4'd7,
			BYTE_8 = 4'd8,
			BYTE_9 = 4'd9,
			BYTE_10 = 4'd10,
			BYTE_11 = 4'd11,
			BYTE_12 = 4'd12,
			BYTE_13 = 4'd13,
			BYTE_14 = 4'd14,
			BYTE_15 = 4'd15,
			BYTE_16 = 5'd16,
			STOP   = 5'd17;

reg [5:0] current_state;
reg [5:0] next_state;


//Outputs of every state.
always @(*) begin
	case (current_state)
		IDLE   : bus = {N{1'b0}};
		BYTE_1 : begin 
					enable = 1'b1;					
					bus = data[127:120];
				 end
		BYTE_2:  bus = data[119:112];
		BYTE_3:  bus = data[111:104];
		BYTE_4:  bus = data[103:96];
		BYTE_5:  bus = data[95:88];
		BYTE_6:  bus = data[87:80];
		BYTE_7:  bus = data[79:72];
		BYTE_8:  bus = data[71:64];
		BYTE_9:  bus = data[63:56];
		BYTE_10: bus = data[55:48];
		BYTE_11: bus = data[47:40];
		BYTE_12: bus = data[39:32];
		BYTE_13: bus = data[31:24];
		BYTE_14: bus = data[23:16];
		BYTE_15: bus = data[15:8];
		BYTE_16: bus = data[7:0];
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
		IDLE   : if  ( !(busy & enable) ) next_state = BYTE_1;
		BYTE_1 : if  ( !busy )   next_state = BYTE_2;
		BYTE_2 : if  ( !busy )   next_state = BYTE_3;
		BYTE_3 : if  ( !busy )   next_state = BYTE_4;
		BYTE_4 : if  ( !busy )   next_state = BYTE_5;
		BYTE_5 : if  ( !busy )   next_state = BYTE_6;
		BYTE_6 : if  ( !busy )   next_state = BYTE_7;
		BYTE_7 : if  ( !busy )   next_state = BYTE_8;
		BYTE_8 : if  ( !busy )   next_state = BYTE_9;
		BYTE_9 : if  ( !busy )   next_state = BYTE_10;
		BYTE_10 : if ( !busy )   next_state = BYTE_11;
		BYTE_11 : if ( !busy )   next_state = BYTE_12;
		BYTE_12 : if ( !busy )   next_state = BYTE_13;
		BYTE_13 : if ( !busy )   next_state = BYTE_14;
		BYTE_14 : if ( !busy )   next_state = BYTE_15;
		BYTE_15 : if ( !busy )   next_state = BYTE_16;
		BYTE_16 : if ( !busy ) 	 next_state = STOP;
		STOP   : 				 next_state = IDLE;
		default : 				 next_state = IDLE;
	  endcase
	end
endmodule

module test();

parameter N = 8, M = 128;
parameter tclk = 5; 

reg busy = 1;			
reg clk = 0;
reg start = 1;			
reg reset = 1;
reg  [M-1:0] data = "Wake up, Neo...";
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
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
			#(20*tclk) busy = 1;
			#(20*tclk) busy = 0;
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
	//"busy = %b, start = %b, reset = %b,", busy, start, reset,
	"data = %h, enable = %b bus = %h", data, enable, bus);

endmodule














