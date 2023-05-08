`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 16:40:45
// Design Name: 
// Module Name: counter
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

//计数器模块
module counter(clk,cnt,rstn);
	input rstn;
    input clk;
    output reg [1:0] cnt = 0;
    always@(posedge clk or negedge rstn) begin
    	if (~rstn)
            cnt <= 0;
        else if(cnt == 2'b11)
            cnt <= 2'b00;
        else 
            cnt <= cnt + 1'b1;
    end
endmodule