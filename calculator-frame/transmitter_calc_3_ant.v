//This module combines a functionality to divide the data string 
//into 8-bit fragments, with the transmission module.
`timescale 1ns/1ns

module transmitter_calc
 #(parameter DATASIZE = 128)		   //Message size in bits.
  (	input 				 clk,		   //Clock signal.
	input				 main_start,   //Swich.
	input				 reset,		   //Swich
	output  			 txd_pin, 	   //UART Transmit pin.
	input				 rxd_pin,
	output wire [3:0]    led);	       //Output to led display of signals.

 	
localparam CLK_HZ = 100_000_000;	   //Clock frequency in hertz.
localparam BIT_RATE =     9_600;
localparam PAYLOAD_BITS =     8;

wire [PAYLOAD_BITS-1:0]	bus;
wire        			busy;
wire        			enable;
wire [5:0] state;
wire sitm = (state == 6'd6 & busy == 0); 		//send it to me, fsm says.
reg go_fsm;
reg start;


//assign led[0] = |state; //Useful to stop the test with wait.
assign led[0] = sitm;
assign led[1] = start;
assign led[2] = rxd_pin;
assign led[3] = txd_pin;


//----------- FSM Screen Begin -----------------------------------------
reg [DATASIZE-1:0] data;
reg [DATASIZE-1:0] cls          = {8'h0C};
reg [DATASIZE-1:0] header_1     = {8'h0A, 8'h0D, "CALCULATOR"};
reg [DATASIZE-1:0] underline    = {8'h0A, 8'h0D, "----------"};
reg [DATASIZE-1:0] input_1      = {8'h0A, 8'h0D, ">INPUT#1:  "};
reg [DATASIZE-1:0] blank_line   = {8'h00};

localparam  IDLE   = 3'd0,
			LINE_1 = 3'd1,
			LINE_2 = 3'd2,
			LINE_3 = 3'd3,
			LINE_4 = 3'd4,
			LINE_5 = 3'd5,
			STOP   = 3'd6,
			INPUT_1= 3'd7;

reg [3:0] current_state;
reg [3:0] next_state;

//Outputs of every state.
always @(*) begin
	case (current_state)
		IDLE   : begin
					data  = 8'h00;
					start = 1'b1;
				end
		LINE_1 : data  = cls;
		LINE_2 : data  = header_1;
		LINE_3 : data  = underline;
		LINE_4 : data  = input_1;
		LINE_5 : data  = blank_line;
		INPUT_1 : data = bus_rx;  //A loopback.
		STOP   : begin
					data  = bus_rx;
					start = 1'b0;
				end

	endcase
end

//Synchronous state transition.
always @(posedge clk)
	if (reset) current_state <= IDLE;
	else       current_state <= next_state;

//Conditional state transitions.
always @(*) begin
	next_state = current_state;
	case (current_state)
		IDLE : if (main_start) next_state = LINE_1;
		LINE_1 : if (sitm) next_state = LINE_2;
		LINE_2 : if (sitm) next_state = LINE_3;
		LINE_3 : if (sitm) next_state = LINE_4;
		LINE_4 : if (sitm) next_state = LINE_5;
		LINE_5 : if (sitm) next_state = INPUT_1;
		INPUT_1 : if (valid) next_state = STOP;
		STOP :              next_state = STOP;

	endcase
end
//----------- FSM Screen End -------------------------------------------


fsm
#(.N		(PAYLOAD_BITS),
  .M		(DATASIZE))
fsm_tx(
  .busy		(busy),
  .clk		(clk),
  .start	(start),
  .reset	(reset),
  .data 	(data),
  .enable	(enable),
  .state	(state),
  .bus		(bus));


uart_tx
#(.BIT_RATE		(BIT_RATE),
  .PAYLOAD_BITS	(PAYLOAD_BITS),
  .CLK_HZ  		(CLK_HZ))
i_uart_tx(
  .clk			(clk),
  .resetn		(!reset),
  .uart_txd		(txd_pin),
  .uart_tx_busy	(busy),
  .uart_tx_en   (enable),
  .uart_tx_data (bus) 
);


wire [PAYLOAD_BITS-1:0]	bus_rx;
reg        			enable_rx = 1;
wire        			break;
wire        			valid;

uart_rx 
i_uart_rx(
.clk			(clk),
.resetn			(!reset),
.uart_rxd		(rxd_pin),
.uart_rx_en		(enable_rx),
.uart_rx_break	(break),
.uart_rx_valid	(valid),
.uart_rx_data 	(bus_rx)
);


endmodule

