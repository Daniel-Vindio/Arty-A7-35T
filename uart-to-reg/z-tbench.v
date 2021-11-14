`timescale 1ns/1ns

module test ();

	parameter BAUD = 9_600;				//Bits per second.
	parameter BIT_PERIOD = 1e9/BAUD;	//nanoseconds.
	parameter CLK_FREQ = 1e8; 			 //Arty 7 -> 100 MHz 
	parameter CLK_PERIOD = 1e9/CLK_FREQ; //Arty 7 -> Period = 10 ns.
	parameter TCLK = CLK_PERIOD/2;		 //To generate the wave.
	parameter WORDSZ = 8;
	
	reg 				CLK = 1'b0;
	reg 				RXD_PIN = 1'b1; //UART Recieve pin.
	wire 				TXD_PIN; //UART Recieve pin.
	reg 				SW_0 = 1'b0;    //Slide switch to enable reception.
	wire [WORDSZ-1:0] 	BUS;
	wire [WORDSZ-1:0] 	LED;
	wire [3:0] 			STATE;
	
	task send_byte;
		input [WORDSZ-1:0] to_send;
		integer i;
		begin
			$display("Sending byte: %b at time %d", to_send, $time);
			#BIT_PERIOD RXD_PIN = 1'b1;
			for (i = 0; i < 8; i = i + 1)
				#BIT_PERIOD RXD_PIN = to_send[i];
			#BIT_PERIOD RXD_PIN = 1'b0;
			#1000;
		end
	endtask
	
	initial
		begin
			$dumpfile ("uart_to_reg.vcd");
			$dumpvars;
		end
	
	always #(TCLK) CLK = ~CLK;
	
	initial
		begin
			#40 SW_0 = 1'b1;
			send_byte("A");
			send_byte(0);

			$display("Finish simulation at time %d", $time);
			$finish();
		end


	uart_to_reg uut (CLK, RXD_PIN, TXD_PIN, SW_0, LED);
	
/*
	always #TCLK $display (
		"Time = %0t, "  ,$time,
		"CLK  = %b, "   ,CLK,
		"RXD_PIN = %b, ",RXD_PIN,
		"TXD_PIN = %b, ",TXD_PIN,
		"SW_0 = %b, "   ,SW_0,
		"BUS = %b, "    ,BUS,
		"LED = %b, "    ,LED,
		"STATE =%B"     ,STATE);
*/
endmodule
