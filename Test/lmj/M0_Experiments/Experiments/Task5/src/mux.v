`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 20:10:06
// Design Name: 
// Module Name: mux
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

//多路复用器
module Mux(
    input [1:0] sel,
    input [3:0] ina,
    input [3:0] inb,
    input [3:0] inc,
    input [3:0] ind,
    output reg [3:0] data_out
);
    always@(*)
        case(sel) 
            2'b00 : data_out = ina;
            2'b01 : data_out = inb;
            2'b10 : data_out = inc;
            2'b11 : data_out = ind;
            default : data_out = 0;
        endcase
endmodule