module top
(
	input CLK,
    input[7:0] SWI,
    output[7:0] LED,
    inout[60:1] PI4
);

assign PI4[5]=CLK;

i2c_master 
#(
	.T_CLK (10)
) 
(
	.i_clk         (clk),
	.i_rstn        (rstn), // async active low rst

	// read/write control 
	.i_wr          (mem[CTRL][0]), // write enable
	.i_rd          (mem[CTRL][1]), // read enable
	.i_slave_addr  (mem[SLAVE]), // 7-bit slave device addr
	.i_reg_addr    (mem[REG]), // 8-bit register addr
	.i_wdata       (mem[WDATA]), // 8-bit write data

	// read data out
	.o_rdata       (mem[RDATA]), // 8-bit read data out

	// status signals
	.o_busy        (mem[STAU][0]), // asserted when r/w in progress
	.o_rdata_valid (mem[STAU][1]), // indicates o_rdata is valid
	.o_nack_slave  (mem[STAU][2]), // NACK on slave address frame
	.o_nack_addr   (mem[STAU][3]), // NACK on register address frame
	.o_nack_data   (mem[STAU][4]), // NACK on data frame

	// bidirectional i2c pins
	.SCL           (scl_pin), 
	.SDA           (sda_pin)  
);

endmodule