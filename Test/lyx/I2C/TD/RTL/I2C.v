/*
 * Copyright (C) 2023 by Liyuxuan,all rights reserved
 */
/**
 * @brief I2C master 模块
 * @author Liyuxuan
 * @date 2023-04-27 初始版本
 **/

module I2C
(
	input              rstn,
    input              clk,
    input [2:0]        addr,
    input              enableIn,
    input [3:0]        enableOut,
    input [31:0]       dataIn,
    output reg [31:0]  dataOut
    output             readyout,
    output             resp,
    inout              sda_pin,
    output             scl_pin,
);

reg [7:0] mem [6];

`define CTRL  0
`define STAU  1
`define RDATA 2
`define WDATA 3
`define SLAVE 4
`define REG   5

always@(posedge clk or negedge rstn)
begin
    if(~rstn)
	begin
        mem[`ST_REG] <= 0;
	end
	else
	begin
		if(enableIn[0]) mem[addr][7:0]   <= dataIn[7:0];
		if(enableOut) dataOut <= mem[addr];
	end
end

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

