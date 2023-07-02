`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 16:28:23
// Design Name: 
// Module Name: seg_sel_decoder
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


//数码管位选译码模块，低电平有效
module seg_sel_decoder(bit_disp,seg_sel);
    input [1:0] bit_disp;
    output reg [3:0] seg_sel; 
    always @ (bit_disp)
        case (bit_disp)
            3'd0 : seg_sel = 4'b1110;
            3'd1 : seg_sel = 4'b1101;
            3'd2 : seg_sel = 4'b1011;
            3'd3 : seg_sel = 4'b0111;
            default : seg_sel = 4'b1111;
        endcase
endmodule