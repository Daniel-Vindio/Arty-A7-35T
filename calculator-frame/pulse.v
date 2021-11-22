// Just a simple pulsenizer.
`timescale 1ns/1ns

module pulse
(input clk,
 input in,
 output reg sync);
 
 reg aux1 = 0, aux2 = 0;
 
always @(posedge clk)
	if (in) begin
	    aux1 <= 1'b1;
	    aux2 <= aux1;
	    sync  <= ~aux2 & aux1;
	  end	
endmodule

/*
module test();
reg clk = 0;
reg in = 0 ;
wire sync;
parameter tclk = 5; 


	initial
		begin
			$dumpfile ("sync.vcd");
			$dumpvars;
		end
	
	always #(1*tclk) clk = ~clk;
	
	initial
		begin
			#(5*tclk) in = 0;
			#(5*tclk) in = 1;
			#(5*tclk) in = 0;
			#(5*tclk) in = 1;		
			#(20*tclk)$finish;
		end


pulse uut (clk, in, sync);

endmodule
*/
