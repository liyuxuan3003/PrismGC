/*
 * Copyright (C) 2023 by Liyuxuan,all rights reserved
 */
/**
 * @brief 4x4 KeyBoard 模块
 * @author Liyuxuan
 * @date 2023-04-27 初始版本
 **/

module KeyBoard
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
    input  [3:0]       in_pin,
    output [3:0]       out_pin,
    output             irq,
);

reg [7:0] mem [2];

`define CODE_REG  0
`define STAU_REG  1

reg	[12:0] cnt;
reg [1:0] scan;
always @ (posedge clk or negedge rstn) 
begin
	if(~rstn) 
		cnt <= 13'b0;
	else 
		cnt <= cnt + 1'b1;
end

always @ (posedge clk or negedge rstn) 
begin
	if(~rstn) 
		scan <= 1'b0;
	else if(cnt == 0);
	begin
		scan = scan + 1'b1;
	end
end

assign out_pin = 
    (scan == 2'b00) ? 4'b1110 : 
    (scan == 2'b01) ? 4'b1101 : 
    (scan == 2'b10) ? 4'b1011 : 
    (scan == 2'b11) ? 4'b0111 : 4'b1111;
	
always@(posedge clk)
begin
	case (scan,in_pin)
		6'b00_1110: mem[CODE_REG] = 8'h30;
		6'b00_1101: mem[CODE_REG] = 8'h2e;
		6'b00_1011: mem[CODE_REG] = 8'h20;
		6'b00_0111: mem[CODE_REG] = 8'h0d;

		6'b01_1110: mem[CODE_REG] = 8'h31;
		6'b01_1101: mem[CODE_REG] = 8'h32;
		6'b01_1011: mem[CODE_REG] = 8'h33;
		6'b01_0111: mem[CODE_REG] = 8'h08;

		6'b10_1110: mem[CODE_REG] = 8'h34;
		6'b10_1101: mem[CODE_REG] = 8'h35;
		6'b10_1011: mem[CODE_REG] = 8'h36;
		6'b10_0111: mem[CODE_REG] = 8'h2d;

		6'b11_1110: mem[CODE_REG] = 8'h37;
		6'b11_1101: mem[CODE_REG] = 8'h38;
		6'b11_1011: mem[CODE_REG] = 8'h39;
		6'b11_0111: mem[CODE_REG] = 8'h2b;

		default: mem[CODE_REG]=0;
	endcase
end

always@(posedge clk or negedge rstn)
begin
    if(~rstn)
	begin
        mem[`STAU_REG] <= 0;
        mem[`CODE_REG] <= 0;
	end
	else
	begin
		if(enableOut) dataOut <= {24'b0,mem[addr]};
	end
end

endmodule

