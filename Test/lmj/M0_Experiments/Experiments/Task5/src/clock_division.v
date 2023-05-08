`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 16:33:11
// Design Name: 
// Module Name: clock_division
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

//时钟分频
module clock_division(clk_in,divclk,rstn);
    input clk_in;
    input rstn;
    output divclk;
    parameter DIVCLK_CNTMAX = 24999; //时钟分频计数的最大值
    reg [31:0] cnt = 0;              
    reg divclk_reg = 0;
    always@(posedge clk_in or negedge rstn) begin
        if (~rstn)
            cnt <= 0;
        else if(cnt == DIVCLK_CNTMAX) begin
            cnt <= 0;
            divclk_reg <= ~divclk_reg;
        end
        else
            cnt <= cnt + 1;
    end 
    assign divclk = divclk_reg;
endmodule