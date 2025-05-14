module config_codec (
   input  logic         clk         ,
   input  logic         reset_n     ,
   input  logic         busy        ,
   input  logic         is_config   ,
   output logic         done_config ,
   output logic         ack_i2c     ,
   output logic         wr_rd       ,
   output logic [7:0]   addr        ,
   output logic [15:0]  data_config 
);

   logic [15:0] data_array [10:0]; 

   always_ff @(negedge reset_n) begin 
		data_array[0] <= 16'h0B19; //
		data_array[1] <= 16'h047F;
		data_array[2] <= 16'h067F;
		data_array[3] <= 16'h0810;
      data_array[4] <= 16'h0C00; 
      data_array[5] <= 16'h13FF; //0C07
      data_array[6] <= 16'h0E13; 
      data_array[7] <= 16'h1001;
      data_array[8] <= 16'h0A01; //0812 
		data_array[9] <= 16'h0017; //
		data_array[10] <= 16'h0217; //
  end

   typedef enum logic [2:0] {
      S0,
      S1,
      S2,
      S3,
      S4,
      S5,
		S6
   } state_e;

   state_e state_q;
   state_e state_d;

   logic [3:0] count_d,
               count_q;

   logic       temp_ack_i2c,
               done;

   logic [15:0] data_temp;

   assign data_temp     = data_array[count_q];
   assign data_config   = data_temp[15:0];

   always_ff @(posedge clk or negedge reset_n) begin 
      if (!reset_n) begin 
         state_q <= S0;
         count_q <= 4'b1111;
      end else begin 
         state_q <= state_d;
         count_q <= count_d;
      end
   end

   always_comb begin 
      case (state_q)
         S0: begin 
            if (~busy)  state_d = S1;
            else        state_d = state_q;
            count_d        = 4'b1111;
            temp_ack_i2c   = 1'b0;
            done           = 1'b0;
         end
         S1: begin 
            if ((~is_config) && (~busy))  state_d = S2;
            else                          state_d = state_q;
            count_d        = count_q;
            temp_ack_i2c   = 1'b0;
            done           = 1'b0;
         end 
         S2: begin 
            state_d = S3;
            count_d        = count_q + 4'b1;
            temp_ack_i2c   = 1'b0;
            done           = 1'b0;
         end
			S3: begin
				count_d = (count_q == 4'b1011) ? 4'b0 : count_q;
				state_d = S4;
            temp_ack_i2c = 1'b0;
            done           = 1'b0;
			end
         S4: begin 
            state_d        = S5;
            count_d        = count_q;
            temp_ack_i2c   = 1'b1;
            done           = 1'b0;
         end
         S5: begin
            if (~busy)  state_d = S6;
            else        state_d = state_q; 
            count_d        = count_q;
            temp_ack_i2c   = 1'b0;
            done           = 1'b0;
			end
         S6: begin
            state_d        = S1;
            count_d        = count_q;
            temp_ack_i2c   = 1'b0;
            done           = 1'b1;
         end
         default: begin 
            state_d        = S0;
            count_d        = 4'b1111;
            temp_ack_i2c   = 1'b0;
            done           = 1'b0;
         end
      endcase 
   end

   assign addr          = 8'b00110100;
   assign wr_rd         = 1'b0;
   assign done_config   = done;
   assign ack_i2c       = temp_ack_i2c;
   
endmodule 