`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 16:46:14
// Design Name: 
// Module Name: onehot2bin1ry
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//独热码转BCD码模块
module onehot2bin1ry(clk,onehot,bin1ry);
    input clk;
    input [15:0] onehot;
    output reg [3:0] bin1ry;
    always@(posedge clk) 
        case(onehot) 
            16'h0001 : bin1ry <= 4'b0000;
            16'h0002 : bin1ry <= 4'b0001;
            16'h0004 : bin1ry <= 4'b0010;
            16'h0008 : bin1ry <= 4'b0011;
            16'h0010 : bin1ry <= 4'b0100;
            16'h0020 : bin1ry <= 4'b0101;
            16'h0040 : bin1ry <= 4'b0110;
            16'h0080 : bin1ry <= 4'b0111;
            16'h0100 : bin1ry <= 4'b1000;
            16'h0200 : bin1ry <= 4'b1001;
            16'h0400 : bin1ry <= 4'b1010;
            16'h0800 : bin1ry <= 4'b1011;
            16'h1000 : bin1ry <= 4'b1100;
            16'h2000 : bin1ry <= 4'b1101;
            16'h4000 : bin1ry <= 4'b1110;
            16'h8000 : bin1ry <= 4'b1111;
        endcase
endmodule