module parallel_serial(
  input  logic i_clk,
  input  logic [31:0] i_data_parallel,
  output logic o_bclk,
  output logic o_lrclk,
  output logic o_data_serial
);

  typedef enum logic [1:0] {
  S0,S1,S2
  } state_e;
  state_e state_d;
  state_e state_q;
  
  logic bclk_temp, lrclk_temp;
  logic [31:0] data_temp;
  logic [7:0] count_d, count_q;
  logic [4:0] count_bit_d, count_bit_q;
  
  assign bclk_temp = i_clk;
  
  always_ff @(posedge lrclk_temp) begin
    data_temp <= i_data_parallel;
  end
  
//state transition
  always_ff @(negedge bclk_temp) begin
    state_q     <= state_d;
	 count_q     <= count_d;
	 count_bit_q <= count_bit_d;
  end
//state combination
  always_comb begin
    case(state_q)
	   S0: begin
		  lrclk_temp  = 1'b1;
		  count_d     = 8'd0;
        count_bit_d = 5'd31;
		  state_d     = S1;
		end
	   S1: begin
		  lrclk_temp  = 1'b0;
		  count_d     = 8'd0;
		  if(count_bit_q == 5'd0) begin
		    state_d = S2;
			 count_bit_d = 5'd0;
		  end
		  else begin
		    count_bit_d = count_bit_q - 5'd1;
			 state_d = state_q;
		  end
		end
      S2: begin
		  lrclk_temp  = 1'b0;
        count_bit_d = 5'd0;
		  if(count_q == 8'd216) begin
		     state_d = S0;
			  count_d = 8'd0;
		  end
		  else begin
		    count_d = count_q + 8'd1;
			 state_d = state_q;
		  end
		end
	   default: begin
		  lrclk_temp  = 1'b0;
		  count_d     = 8'd0;
        count_bit_d = 5'd0;
		  state_d     = S0;
		end
	 endcase
  end
// output combination
  assign o_bclk = bclk_temp;
  assign o_data_serial = data_temp[count_bit_q];
  assign o_lrclk = lrclk_temp;
endmodule