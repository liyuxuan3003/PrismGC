`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 11:22:47
// Design Name: 
// Module Name: keyboard_scan
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

//按键扫描模块
module keyboard_scan(clk,col,row,key);
    input clk;
    input [3:0] col;             
    output reg [3:0] row = 4'b1110;               
    output reg [15:0] key;  
    reg [31:0] cnt = 0;
    reg scan_clk = 0;
    always@(posedge clk) begin
        if(cnt == 2499) begin
            cnt <= 0;
            scan_clk <= ~scan_clk;
        end
        else
            cnt <= cnt + 1;
    end
    always@(posedge scan_clk)
        row <= {row[2:0],row[3]}; 
    always@(negedge scan_clk) 
        case(row)
            4'b1110 : key[3:0] <= col;
            4'b1101 : key[7:4] <= col;
            4'b1011 : key[11:8] <= col;
            4'b0111 : key[15:12] <= col;
            default : key <= 0;
        endcase
endmodule