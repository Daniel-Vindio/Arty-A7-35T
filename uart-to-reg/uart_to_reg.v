// The objective of this module is to store data entered by the UART 
// in a register. 
`timescale 1ns/1ps
module uart_to_reg 
  #(parameter WORDSZ = 8) 		 // Word size in bits.
  (	input 				clk,
	input 				rxd_pin, // UART Recieve pin.
	input 				sw_0,	 //Slide switch to enable reception.
	output reg [WORDSZ-1:0] bus,
	output reg [3:0] 		state);


// Clock frequency in hertz.
parameter CLK_HZ = 100_000_000;
parameter BIT_RATE =   9_600;
parameter PAYLOAD_BITS = 8;

wire [PAYLOAD_BITS-1:0]  uart_rx_data;
wire        			 uart_rx_valid;
wire        			 uart_rx_break;

always @(posedge clk)
    if(!sw_0) 				state[0] <= 1'b1;
    else if(uart_rx_valid)  bus <= uart_rx_data;


// UART RX
uart_rx 
#(.BIT_RATE(BIT_RATE),
  .PAYLOAD_BITS(PAYLOAD_BITS),
  .CLK_HZ  (CLK_HZ  ))
i_uart_rx(
  .clk          (clk          ), // Top level system clock input.
  .resetn       (sw_0         ), // Asynchronous active low reset.
  .uart_rxd     (rxd_pin     ), // UART Recieve pin.
  .uart_rx_en   (1'b1         ), // Recieve enable
  .uart_rx_break(uart_rx_break), // Did we get a BREAK message?
  .uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
  .uart_rx_data (uart_rx_data )  // The recieved data.
);

endmodule
