`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 22:18:23
// Design Name: 
// Module Name: switch
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


//具有使能端的移位寄存器
module switch(en,clk,rst,data_in,data_0,data_1,data_2,data_3);
    input clk,rst,en;
    input [3:0] data_in;
    output reg [3:0] data_0,data_1,data_2,data_3;

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            data_0 <= 4'b0;
            data_1 <= 4'b0;
            data_2 <= 4'b0;
            data_3 <= 4'b0;// reset         
        end
        else if (en) begin
            data_0<= data_in;
            data_1<= data_0;
            data_2<= data_1;
            data_3<= data_2;
        end
    end
endmodule