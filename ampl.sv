module ampl(
  input  logic signed [15:0] i_wave,
  input  logic [1:0] i_sel,
  output logic signed [15:0] o_wave
);
  logic signed [15:0] wave;
  always_comb begin
    case(i_sel)
	   2'b00: wave = i_wave>>>4;
		2'b01: wave = i_wave>>>3;
		2'b10: wave = i_wave>>>2;
		2'b11: wave = 16'b0;
		default: wave = i_wave>>>2;
	 endcase
  end
  assign o_wave = wave;
endmodule