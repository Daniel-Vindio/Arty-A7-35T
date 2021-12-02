module lock (
  input clk,
  input reset,	  // Btn 2
  input oops,       // Btn 1
  input enter,      // Btn 0
  input [3:0] login,  // 4 Switches
  output [3:0] loginled,
  output [3:0] flag_d);
  
localparam START   = 3'd0,
		   ERROR_1 = 3'd1,
		   WAIT    = 3'd2,
		   ERROR_2 = 3'd3,
		   OPEN    = 3'd4;

reg [3:0] passw = 4'b1001;

reg [2:0] current_state = 3'b000;
reg [2:0] next_state;

reg [3:0] flag;

wire reset;	 // Btn 2
wire oops;   // Btn 1
wire enter;  // Btn 0

assign loginled = login;

always @(*) begin
	flag = 4'b0000;
	case (current_state)
		START   : flag[0]   = 1'b1;
		ERROR_1 : flag[1]   = 1'b1;
		WAIT    : flag[0]   = 1'b1; 
		ERROR_2 : flag[2:1] = 2'b11;
		OPEN    : flag[3]   = 1'b1;
	endcase
end

always @(posedge clk) begin
	current_state <= next_state;
end

wire pass = (login == passw & enter);
wire fail = (login != passw & enter);

always @(*) begin
	next_state = current_state;
	case(current_state)
		START : begin
					if 		(pass) 	next_state = OPEN;
					else if	(fail) 	next_state = ERROR_1;
					else 			next_state = START;
		end
		ERROR_1 : begin 
					if (oops)   next_state = WAIT;
					else 		next_state = ERROR_1;
		end
		WAIT    : begin 
			 		if (pass) 		next_state = OPEN; 
					else if	(fail) 	next_state = ERROR_1;
		end
		ERROR_2 : begin 
					if (reset) next_state = START;
					else 	   next_state = ERROR_2;
		end
		OPEN : begin 
					if (reset) next_state = START;
					else 	   next_state = OPEN;
		end
	endcase
end

led_dimmer led0 (clk, flag[0], flag_d[0]);
led_dimmer led1 (clk, flag[1], flag_d[1]);
led_dimmer led2 (clk, flag[2], flag_d[2]);
led_dimmer led3 (clk, flag[3], flag_d[3]);

//btn_debouncer_sync btn_rst   (clk,reset_i,reset);
//btn_debouncer_sync btn_oops  (clk,oops_i,oops);
//btn_debouncer_sync btn_enter (clk,enter_i,enter);

endmodule