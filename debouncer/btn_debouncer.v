module btn_debouncer
	#(parameter CLOCK_FREQ = 100, 	//MHz
	  parameter T_TRANS = 2)		//miliseconds
	(input clk,
	input btn,
	output reg btn_dboun);

	//Comment for synth. & implement. Begin.
	parameter COUNT_BIT = $clog2(CLOCK_FREQ * T_TRANS * $pow(10, 3));
	parameter SEMI_PERIOD = $pow(2, COUNT_BIT-1);
	reg [COUNT_BIT-1:0] counter = 0;
	//Comment for synth. & implement. End.
	
	//reg [17:0] counter = 0; //Uncomment for synth. & implement.
	
	reg slow_clk = 0;
	
	always @(posedge clk) begin
		counter <= counter + 1;
		slow_clk <= (counter < SEMI_PERIOD) ? 1 : 0;  //Comment for synth. & implement.
		//slow_clk <= (counter < 18'd131072) ? 1 : 0; //Uncomment for synth. & implement.
	end
	
	reg sync1, sync2;
	always @(posedge slow_clk) begin
		sync1 <= btn;
		sync2 <= sync1;
		btn_dboun <= ~sync2 & sync1;
	end
	
	//Comment for synth. & implement. Begin.
	initial $display ("COUNT_BIT = %d\n", COUNT_BIT,
					  "SEMI_PERIOD = %d", SEMI_PERIOD);
	//Comment for synth. & implement. End.

endmodule
