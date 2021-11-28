//Finite state machine to feed the TX module. It is used to divide the 
//message into 8-bit fragments (which precisely match the ASCII 
//characters of the message).
`timescale 1ns/1ns

module test();

parameter N = 8, M = 128;
parameter tclk = 5; 

reg clk = 0;
reg main_start = 0;
reg reset = 1;
wire txd_pin;
reg rxd_pin;
wire [3:0] led;
wire busy;
reg [7:0] to_send;
reg enable_rx;
reg bus;

localparam BIT_RATE = 9600;
localparam BIT_P    = (1000000000/BIT_RATE);

// Sends a single byte down the UART line.
task send_byte;
    input [7:0] to_send;
    integer i;
    begin
        //$display("Sending byte: %d at time %d", to_send, $time);

        #BIT_P;  rxd_pin = 1'b0;
        for(i=0; i < 8; i = i+1) begin
            #BIT_P;  rxd_pin = to_send[i];

            //$display("    Bit: %d at time %d", i, $time);
        end
        #BIT_P;  rxd_pin = 1'b1;
        #1000;
    end
endtask



	initial
		begin
			$dumpfile ("waves.vcd");
			$dumpvars;
		end
	
	always #(1*tclk) clk = ~clk;
	
	initial
		begin
			#(5*tclk) reset = 0; main_start = 1;
			//#(2e7*tclk) to_send = "a"; send_byte(to_send);
			//#(2e7*tclk) to_send = "b"; send_byte(to_send);
			#2e8 $finish;		

		end


transmitter_calc uut (clk, main_start, reset, txd_pin, rxd_pin, led);

endmodule














