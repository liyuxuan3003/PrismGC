/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module Digit 
(
    input               clk,
    input               rstn,
    input[7:0]          addrIn,
    input[7:0]          addrOut,
    input[3:0]          sizeDecode,
    input[31:0]         dataIn,
    output reg[31:0]    dataOut,
    output reg[7:0]     SEG,
    output reg[3:0]     SEGCS
);

reg [31:0] mem [1:0];

always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[0] <= 0;
        mem[1] <= 4'b1;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[0]][31:24] <= dataIn[31:24];

        dataOut <= mem[addrOut[0]]; 
    end
end

reg[1:0] nowDig;

reg clkDig;
reg[15:0] clkDigCnt;

always @(posedge clk)
begin
    clkDigCnt <= clkDigCnt+1;
    if(clkDigCnt == 16'h0000)
        clkDig <= ~clkDig;
end

wire[7:0] dig0Seg;
wire[7:0] dig1Seg;
wire[7:0] dig2Seg;
wire[7:0] dig3Seg;
wire[31:0] m0=mem[0];

DigitDecoder dd0(.digit(m0[3:0]), .digitEnable(m0[5]), .dot(m0[4]), .seg(dig0Seg));
DigitDecoder dd1(.digit(m0[8*1+:4]), .digitEnable(m0[5+8*1]), .dot(m0[4+8*1]), .seg(dig1Seg));
DigitDecoder dd2(.digit(m0[8*2+:4]), .digitEnable(m0[5+8*2]), .dot(m0[4+8*2]), .seg(dig2Seg));
DigitDecoder dd3(.digit(m0[8*3+:4]), .digitEnable(m0[5+8*3]), .dot(m0[4+8*3]), .seg(dig3Seg));

always @(posedge clkDig) 
begin
    case (mem[1][3:0])
        4'b0000: begin SEG <= dig0Seg; SEGCS <= 4'b1110; end
        4'b0001: begin SEG <= dig1Seg; SEGCS <= 4'b1101; end
        4'b0010: begin SEG <= dig2Seg; SEGCS <= 4'b1011; end
        4'b0011: begin SEG <= dig3Seg; SEGCS <= 4'b0111; end
        4'b1111:
        begin
            nowDig <= nowDig+1;
            case (nowDig)
                2'b00 : begin SEG <= dig0Seg; SEGCS <= 4'b1110; end
                2'b01 : begin SEG <= dig1Seg; SEGCS <= 4'b1101; end
                2'b10 : begin SEG <= dig2Seg; SEGCS <= 4'b1011; end
                2'b11 : begin SEG <= dig3Seg; SEGCS <= 4'b0111; end
            endcase
        end
        4'b1100: begin SEG <= 8'bzzzzzzzz; SEGCS <= 4'bzzzz; end 
        default: begin SEG <= 8'bzzzzzzzz; SEGCS <= 4'bzzzz; end 
    endcase
end

endmodule