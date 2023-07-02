module top
(
	input   wire       rstn,
    input   wire       clk,
    inout   wire       sda_pin,
    inout   wire       scl_pin,
	output  wire       pin1
);

reg [7:0] mem [5:0];

`define CRTL  0
`define STAU  1
`define RDATA 2
`define WDATA 3
`define SLAVE 4
`define REG   5

reg [19:0] cnt;

always@(posedge clk or negedge rstn)
begin
    if(~rstn)
	begin
        mem[`CRTL][0]<=1'b1;
        mem[`CRTL][1]<=1'b0;
        mem[`STAU]<=0;
        mem[`RDATA]<=0;m
        mem[`WDATA]<=8'h00;
        mem[`SLAVE]<=8'h52;
        mem[`REG]<=8'h40;
		cnt<=0;
	end
	else
	begin
		mem[`RDATA]<=rdata;
		mem[`STAU]<=stau;
		cnt<=cnt+1;

		// if(mem[`STAU][0]==1'b0 && cnt==16'hFFF)
		if(cnt==20'hFFFFF)
		begin
			mem[`CRTL][0]<=1'b0;
       		mem[`CRTL][1]<=1'b1;
			mem[`WDATA]<=8'h00;
			mem[`REG]<=8'h00;
		end

	end
end
assign pin1=mem[`STAU][0];

wire rdata;
wire [4:0] stau;

i2c_master 
#(
	.T_CLK (10)
) 
(
	.i_clk         (clk),
	.i_rstn        (rstn), // async active low rst

	// read/write control 
	.i_wr          (mem[`CRTL][0]), // write enable
	.i_rd          (mem[`CRTL][1]), // read enable
	.i_slave_addr  (mem[`SLAVE]), // 7-bit slave device addr
	.i_reg_addr    (mem[`REG]), // 8-bit register addr
	.i_wdata       (mem[`WDATA]), // 8-bit write data

	// read data out
	.o_rdata       (rdata), // 8-bit read data out

	// status signals
	.o_busy        (stau[0]), // asserted when r/w in progress
	.o_rdata_valid (stau[1]), // indicates o_rdata is valid
	.o_nack_slave  (stau[2]), // NACK on slave address frame
	.o_nack_addr   (stau[3]), // NACK on register address frame
	.o_nack_data   (stau[4]), // NACK on data frame

	// bidirectional i2c pins
	.i_scl           (scl_pin), 
	.i_sda           (sda_pin),
	.o_scl           (scl_pin), 
	.o_sda           (sda_pin)
);

endmodule

