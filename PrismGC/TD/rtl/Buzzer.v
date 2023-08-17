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

reg [31:0] mem [1:0];

reg [15:0] msCounter;

always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[0] <= 0;
        mem[1] <= 0;
        msCounter <= 0;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[0]][31:24] <= dataIn[31:24];

        if(mem[1] != 0)
        begin
            msCounter <= msCounter + 1;
            if(msCounter == 50000)
            begin
                msCounter <= 0;
                mem[1] <= mem[1] - 1;
            end
        end

        dataOut <= mem[addrOut[0]]; 
    end
end

`define Do 262
`define Re 294
`define Mi 330
`define Fa 349
`define So 392
`define La 440
`define Si 494

`define NUM(X) (`CLK_FRE/X)/2

wire [31:0] clkNum =
    (mem[0] == 0) ? 0 :
    (mem[0] == 1) ? `NUM(`Do) :
    (mem[0] == 2) ? `NUM(`Re) :
    (mem[0] == 3) ? `NUM(`Mi) :
    (mem[0] == 4) ? `NUM(`Fa) :
    (mem[0] == 5) ? `NUM(`So) :
    (mem[0] == 6) ? `NUM(`La) :
    (mem[0] == 7) ? `NUM(`Si) : 0;

reg [31:0] counter;
always @(posedge clk) if(counter>=clkNum) counter<=0; else counter <= counter+1;

reg speaker;
always @(posedge clk) if(counter>=clkNum && mem[1] != 0) speaker <= ~speaker;

assign BUZ = speaker;
assign AUD = speaker;

endmodule