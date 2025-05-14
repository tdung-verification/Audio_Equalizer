module serial_parallel(
  input  logic i_clk,
  input  logic i_lrclk,
  input  logic i_data_serial_ADC,
  output logic [31:0] o_data_parallel_ADC,
  output logic o_clk_filter
);
  logic [31:0] buffer_d, buffer_q;
  logic [4:0]  count_bit_d, count_bit_q;
  logic ADC_done;
  
  typedef enum logic [1:0] {
  S0,S1,S2,S3
  } state_e;
  state_e state_d;
  state_e state_q;

//state transition
  always_ff @(posedge i_clk) begin
    state_q     <= state_d;
	 count_bit_q <= count_bit_d;
	 buffer_q    <= buffer_d;
	 
  end
//state combination
  always_comb begin
    case(state_q)
	   S0: begin
		  state_d     = (i_lrclk == 1'b1) ? S1 : S0;
		  count_bit_d = 5'd31;
		  buffer_d    = 32'b0;
		  ADC_done    = 1'b0;
		  o_clk_filter= 1'b0;
		end
	   S1: begin
		  if(count_bit_q == 5'd0) begin
		    state_d     = S2;
			 count_bit_d = 5'b0;
		    end
		  else begin
			 state_d = state_q;
		    count_bit_d = count_bit_q - 5'd1;
 		    end
        buffer_d = {buffer_q[30:0],i_data_serial_ADC};
		  o_clk_filter = 1'b0;
		  ADC_done    = 1'b0;
		 
		end
	   S2: begin
		  state_d     = S3;
        count_bit_d = 5'b0;
        buffer_d = buffer_q;
		  ADC_done    = 1'b1;
		  o_clk_filter= 1'b0;
		end
	   S3: begin
		  state_d     = S0;
        count_bit_d = 5'd0;
        buffer_d = buffer_q;
		  ADC_done    = 1'b0;
		  o_clk_filter= 1'b1;
		end
	   default: begin
		  state_d     = S0;
        count_bit_d = 5'd0;
		  buffer_d    = 32'b0;
		  ADC_done    = 1'b0;
		  o_clk_filter= 1'b0;
		end
	 endcase
  end
// output combination
  always_ff @(posedge ADC_done) begin
     o_data_parallel_ADC <= buffer_q; 
  end
endmodule