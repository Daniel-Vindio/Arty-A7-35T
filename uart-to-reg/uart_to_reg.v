//The objective of this module is to prepare the necessary 
//infrastructure for the input and output of data through the UART 
//serial port.
`timescale 1ns/1ns

module uart_to_reg 
  #(parameter WORDSZ = 8) 		 	//Word size in bits.
  (	input 				clk,		//Clock signal.
	input 				rxd_pin, 	//UART Recieve pin.
	output wire			txd_pin, 	//UART Transmit pin.
	input 				sw_0,	 	//Slide switch to enable reception.
	output wire [WORDSZ-1:0] led);	//Output to led display.

// Clock frequency in hertz.
localparam CLK_HZ = 100_000_000;
localparam BIT_RATE =   9_600;
localparam PAYLOAD_BITS = 8;

wire [PAYLOAD_BITS-1:0] uart_rx_data;
wire        			uart_rx_valid;
wire        			uart_rx_break;

wire [PAYLOAD_BITS-1:0]	uart_tx_data;
wire        			uart_tx_busy;
wire        			uart_tx_en;

reg [WORDSZ-1:0] bus;
reg [3:0] 		state;


// UART Receiver RX
always @(posedge clk)
    if(!sw_0) 				state[0] <= 1'b1;
    else if(uart_rx_valid)  bus <= uart_rx_data;

uart_rx 
#(.BIT_RATE(BIT_RATE),
  .PAYLOAD_BITS(PAYLOAD_BITS),
  .CLK_HZ  (CLK_HZ))
i_uart_rx(
  .clk          (clk          ), // Top level system clock input.
  .resetn       (sw_0         ), // Asynchronous active low reset.
  .uart_rxd     (rxd_pin      ), // UART Recieve pin.
  .uart_rx_en   (1'b1         ), // Recieve enable.
  .uart_rx_break(uart_rx_break), // Did we get a BREAK message?
  .uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
  .uart_rx_data (uart_rx_data )  // The recieved data.
);


// UART Transmitter TX
assign uart_tx_data = uart_rx_data;	//Enable echoing.
assign uart_tx_en   = uart_rx_valid;

uart_tx
#(.BIT_RATE(BIT_RATE),
  .PAYLOAD_BITS(PAYLOAD_BITS),
  .CLK_HZ  (CLK_HZ))
i_uart_tx(
  .clk          (clk          ),
  .resetn       (sw_0         ),
  .uart_txd     (txd_pin      ),
  .uart_tx_en   (uart_tx_en   ),
  .uart_tx_busy (uart_tx_busy ),
  .uart_tx_data (uart_tx_data ) 
);


// LED Display of instant input data.
led_dimmer #(.INTENS(0)) ldmr_0 (clk, bus[7], led[3]);
led_dimmer #(.INTENS(0)) ldmr_1 (clk, bus[6], led[2]);
led_dimmer #(.INTENS(0)) ldmr_2 (clk, bus[5], led[1]);
led_dimmer #(.INTENS(0)) ldmr_3 (clk, bus[4], led[0]);
 	
led_dimmer #(.INTENS(4074)) ldmr_4 (clk, bus[3], led[7]);
led_dimmer #(.INTENS(4074)) ldmr_5 (clk, bus[2], led[6]);
led_dimmer #(.INTENS(4074)) ldmr_6 (clk, bus[1], led[5]);
led_dimmer #(.INTENS(4074)) ldmr_7 (clk, bus[0], led[4]);

endmodule
