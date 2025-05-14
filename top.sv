module top(
  input  logic i_clk_50M,
  input  logic [9:0] i_SW,
  input  logic [3:0] i_KEY,
  input  logic i_ADCDAT,
  output logic o_BCLK,
  output logic o_DACLRC,
  output logic o_DACDAT,
  output logic o_XCLK,
  output logic o_i2c_scl,
  inout        io_i2c_sda,
  output logic o_ADCLRC
);
  logic clk_12M;
  logic press_KEY0;
  logic i2c_busy;
  logic ack_i2c;
  logic [7:0] i2c_addr;
  logic [15:0] i2c_data;
  logic clk_fsample;
  logic [31:0] data_parallel_DAC, data_parallel_ADC;
  logic data_serial_DAC, data_serial_ADC;
  logic bclk;
  logic [15:0] data_lowpass, data_bandpass, data_highpass, data_lowpass_ampl, data_bandpass_ampl, data_highpass_ampl;
  logic [15:0] data_DAC_out;
  logic clk_filter;
  logic [9:0] addr;

  
	pll pll_inst (
		.refclk   (i_clk_50M),   //  refclk.clk
		.rst      (~i_SW[9]),      //   reset.reset
		.outclk_0 (clk_12M), // outclk0.clk
		.locked   ()    //  locked.export
	);


//filter

  fir_57tap_lowpass lowpass_fillter(
    .clock_50(clk_filter),
    .x(data_parallel_ADC[15:0]),
    .dout(data_lowpass)
  );

  fir_57tap_bandpass bandpass_fillter(
    .clock_50(clk_filter),
    .x(data_parallel_ADC[15:0]),
    .dout(data_bandpass)
  );
  
  fir_57tap_highpass highpass_fillter(
    .clock_50(clk_filter),
    .x(data_parallel_ADC[15:0]),
    .dout(data_highpass)
  );
//ampl
  ampl ampl_lowpass(
    .i_wave(data_lowpass),
    .i_sel(i_SW[1:0]),
    .o_wave(data_lowpass_ampl));

  ampl ampl_bandpass(
    .i_wave(data_bandpass),
    .i_sel(i_SW[3:2]),
    .o_wave(data_bandpass_ampl));
	 
  ampl ampl_highpass(
    .i_wave(data_highpass),
    .i_sel(i_SW[5:4]),
    .o_wave(data_highpass_ampl));

 assign data_DAC_out = data_lowpass_ampl + data_bandpass_ampl + data_highpass_ampl;

// DAC
  button button_debounce_1(
    .i_clk(i_clk_50M),
	 .i_rst_n(i_SW[9]),
    .i_button(i_KEY[0]),
    .o_stable(press_KEY0)
  );
  
  config_codec confic_i2c(
    .clk(i_clk_50M),
    .reset_n(i_SW[9]),
    .busy(i2c_busy),
    .is_config(press_KEY0),
    .done_config(),
    .ack_i2c(ack_i2c),
    .wr_rd(),
    .addr(i2c_addr)     ,
    .data_config(i2c_data)
  );

  i2c_protocol i2c(
    .i_clk(i_clk_50M),
    .i_rst_n(i_SW[9]),
    .i_i2c_send_flag(ack_i2c),
    .i_i2c_addr(i2c_addr),
    .i_i2c_data(i2c_data),
    .o_i2c_done(),
	 .o_i2c_busy(i2c_busy),
    .o_i2c_scl(o_i2c_scl),
    .io_i2c_sda(io_i2c_sda)
  );
  
  assign data_parallel_DAC[31:16] = data_DAC_out;
  assign data_parallel_DAC[15:0]  = data_DAC_out;
  
  parallel_serial send_data(
    .i_clk(clk_12M),
    .i_data_parallel(data_parallel_DAC),
    .o_bclk(bclk),
    .o_lrclk(clk_fsample),
    .o_data_serial(data_serial_DAC)
  );
  
  serial_parallel receive_data(
    .i_clk(clk_12M),
    .i_lrclk(clk_fsample),
    .i_data_serial_ADC(data_serial_ADC),
    .o_data_parallel_ADC(data_parallel_ADC),
    .o_clk_filter(clk_filter)
  );
  
  assign o_XCLK          = clk_12M;
  assign o_DACLRC        = clk_fsample;
  assign o_DACDAT        = data_serial_DAC;
  assign o_BCLK          = bclk;
  assign o_ADCLRC        = clk_fsample;
  assign data_serial_ADC = i_ADCDAT;
endmodule