//This module combines a functionality to divide the data string 
//into 8-bit fragments, with the transmission module.
`timescale 1ns/1ns

module transmitter_calc
 #(parameter DATASIZE = 128)		   //Message size in bits.
  (	input 				 clk,		   //Clock signal.
//	input				 start,	   //Start signal from main module
	input				 reset,		   //Swich
//	input [DATASIZE-1:0] data,		   //Data to display
	output  			 txd_pin, 	   //UART Transmit pin.
	output wire [3:0]    led);	       //Output to led display of signals.

 	
localparam CLK_HZ = 100_000_000;	   //Clock frequency in hertz.
localparam BIT_RATE =     9_600;
localparam PAYLOAD_BITS =     8;


wire [PAYLOAD_BITS-1:0]	bus;
wire        			busy;
wire        			enable;
wire [5:0] state;

reg start = 1, sync1, sync2;
assign led[0] = |state; //Useful to stop the test with wait.
assign led[1] = start;
assign led[2] = reset;
assign led[3] = txd_pin;

reg [DATASIZE-1:0] data;
reg [DATASIZE-1:0] header_1  = {"CALCULATOR", 8'h0A, 8'h0D};
reg [DATASIZE-1:0] underline = {"----------", 8'h0A, 8'h0D};

/*
localparam SEL = $clog2(2);  // Number of messages.
reg [SEL-1:0] selector = {SEL{1'b0}};
always @(posedge clk) begin
	if (state == 6'd16) begin
		selector <= selector + 1'b1;
		//sync1 <= 1'b1;
		//sync2 <= sync1;
		//start <= ~sync2 & sync1;
	end 
	case (selector)
		0 : data <= underline;
		1 : data <= header_1;
		default: data <= "x";
	endcase
end
*/

initial assign data = header_1;

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


endmodule

