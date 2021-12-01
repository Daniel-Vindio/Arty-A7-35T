module lock (
  input clk,
  input onoff,
  input reset,	// Btn 2
  input oops,   // Btn 1
  input enter,  // Btn 0
  input [3:0] login,  // 4 Switches
  output [3:0] loginled,
  output [3:0] flag_d);
  
localparam START   = 2'd0,
		   ERROR_1 = 2'd1,
		   ERROR_2 = 2'd2,
		   OPEN    = 2'd3;

reg [1:0] count = 2'b0;
reg [3:0] passw = 4'b1001;

reg [2:0] current_state;
reg [2:0] next_state;

reg [3:0] flag;

    assign loginled = login;
always @(*) begin
	flag = 4'b0000;
	case (current_state)
		START   : begin flag[0] = 1'b1; count = count + 1'b1; end
		ERROR_1 : flag[1]   = 1'b1; 
		ERROR_2 : flag[2:1] = 2'b11;
		OPEN    : flag[3]   = 1'b1;
	endcase
end

always @(posedge clk) begin
	if (onoff) current_state <= START;
	else current_state <= next_state;
end

wire pass1 = (login != passw & count == 2'b01);
wire pass2 = (login != passw & count == 2'b10);
wire pass3 = (login == passw);
//wire pass3 = (login == passw & count == 2'b01);

always @(*) begin
	next_state = current_state;
	case(current_state)
		START : begin
			 if      (pass1 & enter) next_state = ERROR_1;
			 else if (pass2 & enter) next_state = ERROR_2;
			 else if (pass3 & enter) next_state = OPEN;
		end
		ERROR_1 : if (oops)  next_state = START;
		ERROR_2 : if (reset) next_state = START;
		OPEN    : if (reset) next_state = START;
	endcase
end

led_dimmer led0 (clk, flag[0], flag_d[0]);
led_dimmer led1 (clk, flag[1], flag_d[1]);
led_dimmer led2 (clk, flag[2], flag_d[2]);
led_dimmer led3 (clk, flag[3], flag_d[3]);


endmodule