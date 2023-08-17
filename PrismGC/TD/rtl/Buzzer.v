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

`define Do 262
`define Re 294
`define Mi 330
`define Fa 349
`define So 392
`define La 440
`define Si 494
`define DoH 554
`define ReH 622
`define MiH 698
`define FaH 783
`define SoH 879
`define LaH 987
`define SiH 1107

`define NUM(X) (`CLK_FRE/X)/2

wire [31:0] clkNum =
    (mem[`FREQ][3:0] == 4'd0)   ? 0 :
    (mem[`FREQ][3:0] == 4'd1)   ? `NUM(`Do) :
    (mem[`FREQ][3:0] == 4'd2)   ? `NUM(`Re) :
    (mem[`FREQ][3:0] == 4'd3)   ? `NUM(`Mi) :
    (mem[`FREQ][3:0] == 4'd4)   ? `NUM(`Fa) :
    (mem[`FREQ][3:0] == 4'd5)   ? `NUM(`So) :
    (mem[`FREQ][3:0] == 4'd6)   ? `NUM(`La) :
    (mem[`FREQ][3:0] == 4'd7)   ? `NUM(`Si) : 
    (mem[`FREQ][3:0] == 4'd8)   ? `NUM(`DoH) :
    (mem[`FREQ][3:0] == 4'd9)   ? `NUM(`ReH) :
    (mem[`FREQ][3:0] == 4'd10)  ? `NUM(`MiH) :
    (mem[`FREQ][3:0] == 4'd11)  ? `NUM(`FaH) :
    (mem[`FREQ][3:0] == 4'd12)  ? `NUM(`SoH) :
    (mem[`FREQ][3:0] == 4'd13)  ? `NUM(`LaH) :
    (mem[`FREQ][3:0] == 4'd14)  ? `NUM(`SiH) : 0;

reg [31:0] counter;
always @(posedge clk) if(counter>=clkNum) counter<=0; else counter <= counter+1;

reg speaker;
always @(posedge clk) if(counter>=clkNum && mem[`TIME] != 0) speaker <= ~speaker;

assign BUZ = (mem[`OUTPUT][0]) ? speaker : 1'bz;
assign AUD = (mem[`OUTPUT][1]) ? speaker : 1'bz;

endmodule