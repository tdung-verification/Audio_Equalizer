module i2c_protocol(
  input  logic i_clk,
  input  logic i_rst_n,
  input  logic i_i2c_send_flag,
  input  logic [7:0] i_i2c_addr,
  input  logic [15:0] i_i2c_data,
  output logic o_i2c_done, o_i2c_busy,
  output logic o_i2c_scl,
  inout        io_i2c_sda

);
  
  logic [7:0] clk_prs;
  logic clk_i2c, ack_en, clk_en;
  logic i2c_clk_en;
  logic [3:0] data_index_d, data_index_q;
  logic i2c_sda_temp;

  typedef enum logic [3:0]{
    S0,S1,S2,S3,S4,S5,S6,S7,S8 
  } state_e;
  state_e state_d;
  state_e state_q;
  
//tao i2c_clk tan so 200KHz
  always_ff @(posedge i_clk) begin
    if (~i_rst_n) begin
	   clk_prs <= 8'b0;
		clk_i2c <= 1'b0;
		clk_en  <= 1'b0;
	 end
	 else begin
	   clk_prs <= (clk_prs == 8'd250) ? 8'b0 : (clk_prs + 8'b1) ;
		clk_i2c <= (clk_prs < 8'd125)  ? 1'b1 : 1'b0             ;
		clk_en  <= (clk_prs == 8'd187) ? 1'b1 : 1'b0             ;
	 end
  end

// state combination
  always_comb begin
	   case(state_q)
		  S0: begin
		      i2c_sda_temp    = 1'b1;
				o_i2c_done      = 1'b0;
				data_index_d    = 4'd0;
				i2c_clk_en      = 1'b0;
            state_d         = S0;
            o_i2c_busy      = 1'b0;
		      end
		  S1: begin
		      i2c_sda_temp    = 1'b0;
				o_i2c_done      = 1'b0;
				data_index_d    = 4'd7;
				i2c_clk_en      = 1'b0;
				state_d = S2;
				o_i2c_busy      = 1'b1;
		      end
		  S2: begin
		      i2c_clk_en      = 1'b1;
				o_i2c_done      = 1'b0;
				o_i2c_busy      = 1'b1;
				if (data_index_q == 4'd0) begin
				  i2c_sda_temp = i_i2c_addr[data_index_q];
				  state_d = S3;
				  data_index_d = 4'd15;
				  end
				else begin
				  data_index_d = data_index_q - 4'b1;
				  i2c_sda_temp = i_i2c_addr[data_index_q];
				  state_d = S2;
				  end
				end
		  S3: begin
		      i2c_sda_temp    = 1'bz;
				o_i2c_done      = 1'b0;
				data_index_d    = 4'd15;
				i2c_clk_en      = 1'b1;
				state_d = S4;
				o_i2c_busy      = 1'b1;
		      end
		  S4: begin
		      i2c_clk_en      = 1'b1;
				o_i2c_done      = 1'b0;
				o_i2c_busy      = 1'b1;
				if (data_index_q == 4'd8) begin
				  i2c_sda_temp = i_i2c_data[data_index_q];
				  state_d = S5;
				  data_index_d = 4'd7;
				  end
				else begin
				  data_index_d = data_index_q - 4'b1;
				  i2c_sda_temp = i_i2c_data[data_index_q];
				  state_d = S4;
				  end
		      end
		  S5: begin
		      i2c_sda_temp    = 1'bz;
				o_i2c_done      = 1'b0;
				data_index_d    = 4'd7;
				i2c_clk_en      = 1'b1;
				state_d = S6;
				o_i2c_busy      = 1'b1;
		      end
		  S6: begin
		      i2c_clk_en      = 1'b1;
				o_i2c_done      = 1'b0;
				o_i2c_busy      = 1'b1;
				if (data_index_q == 4'd0) begin
				  i2c_sda_temp = i_i2c_data[data_index_q];
				  state_d = S7;
				  data_index_d = 4'b0;
				  end
				else begin
				  data_index_d = data_index_q - 4'b1;
				  i2c_sda_temp = i_i2c_data[data_index_q];
				  state_d = S6;
				  end
		      end
		  S7: begin
		      i2c_sda_temp    = 1'bz;
				o_i2c_done      = 1'b0;
				data_index_d    = 4'd0;
				i2c_clk_en      = 1'b1;
				state_d = S8;
				o_i2c_busy      = 1'b1;
		      end
		  S8: begin
		        i2c_clk_en      = 1'b0;
				  i2c_sda_temp    = 1'b0;
				  state_d = S0;
				  o_i2c_busy      = 1'b1;
				  o_i2c_done      = 1'b1;
	           data_index_d    = 4'b0;			  
		      end
		  default: begin
		    state_d = S0;
			 i2c_sda_temp  = 1'b1;
		    o_i2c_done = 1'b0;
			 o_i2c_busy = 1'b0;
			 data_index_d = 4'd0;
		    i2c_clk_en = 1'b0;
		  end
		endcase
  end
// state transition
  always_ff @(posedge i_clk)begin
    if (~i_rst_n) begin
	   state_q = S0;
      data_index_q = 4'd0;
	 end
    if (clk_en) begin
	   state_q = state_d;
      data_index_q = data_index_d;
    end
    if(i_i2c_send_flag) state_q = S1;
  end
// output combination
assign o_i2c_scl  = (i2c_clk_en) ? clk_i2c : 1'b1;
assign io_i2c_sda = i2c_sda_temp;
endmodule