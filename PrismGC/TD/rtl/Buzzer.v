/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

`include "GlobalDefine.v"

module Buzzer 
(
    input               clk,
    input               rstn,
    input[7:0]          addrIn,
    input[7:0]          addrOut,
    input[3:0]          sizeDecode,
    input[31:0]         dataIn,
    output reg[31:0]    dataOut,
    output              BUZ,
    output              AUD
);

`define FREQ 0
`define TIME 1
`define OUTPUT 2

reg [31:0] mem [2:0];

reg [15:0] msCounter;

always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[`FREQ] <= 0;
        mem[`TIME] <= 0;
        mem[`OUTPUT] <= 0;
        msCounter <= 0;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[1:0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[1:0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[1:0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[1:0]][31:24] <= dataIn[31:24];

        if(mem[`TIME] != 0)
        begin
            msCounter <= msCounter + 1;
            if(msCounter == 50000)
            begin
                msCounter <= 0;
                mem[`TIME] <= mem[`TIME] - 1;
            end
        end

        dataOut <= mem[addrOut[1:0]]; 
    end
end

`define nC3 262
`define nD3 294
`define nE3 330
`define nF3 349
`define nG3 392
`define nA3 440
`define nB3 494

`define nC4 523
`define nD4 587
`define nE4 659
`define nF4 698
`define nG4 784
`define nA4 880
`define nB4 988

`define NUM(X) (`CLK_FRE/X)/2

wire [31:0] clkNum =
    (mem[`FREQ][3:0] == 4'd0)   ? 0 :
    (mem[`FREQ][3:0] == 4'd1)   ? `NUM(`nC3) :
    (mem[`FREQ][3:0] == 4'd2)   ? `NUM(`nD3) :
    (mem[`FREQ][3:0] == 4'd3)   ? `NUM(`nE3) :
    (mem[`FREQ][3:0] == 4'd4)   ? `NUM(`nF3) :
    (mem[`FREQ][3:0] == 4'd5)   ? `NUM(`nG3) :
    (mem[`FREQ][3:0] == 4'd6)   ? `NUM(`nA3) :
    (mem[`FREQ][3:0] == 4'd7)   ? `NUM(`nB3) : 
    (mem[`FREQ][3:0] == 4'd8)   ? `NUM(`nC4) :
    (mem[`FREQ][3:0] == 4'd9)   ? `NUM(`nD4) :
    (mem[`FREQ][3:0] == 4'd10)  ? `NUM(`nE4) :
    (mem[`FREQ][3:0] == 4'd11)  ? `NUM(`nF4) :
    (mem[`FREQ][3:0] == 4'd12)  ? `NUM(`nG4) :
    (mem[`FREQ][3:0] == 4'd13)  ? `NUM(`nA4) :
    (mem[`FREQ][3:0] == 4'd14)  ? `NUM(`nB4) : 0;

reg [31:0] counter;
always @(posedge clk) if(counter>=clkNum) counter<=0; else counter <= counter+1;

reg speaker;
always @(posedge clk) if(counter>=clkNum && mem[`TIME] != 0) speaker <= ~speaker;

assign BUZ = (mem[`OUTPUT][0]) ? speaker : 1'bz;
assign AUD = (mem[`OUTPUT][1]) ? speaker : 1'bz;

endmodule