`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 11:26:00
// Design Name: 
// Module Name: key_filter
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

//按键消抖模块
module key_filter(clk,rstn,key_in,key_deb,en);
    input clk;
    input rstn;
    input [15:0] key_in;
    output [15:0] key_deb;
    output en;

    //分频计数
    reg [19:0] cnt = 0;
    parameter CNTMAX = 999_999;
    always@(posedge clk or negedge rstn) begin
        if(~rstn)
            cnt <= 0;
        else if(cnt == CNTMAX)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;
     end
     //每20ms采样一次按键电平

     reg [15:0] key_reg0;
     reg [15:0] key_reg1;
     reg [15:0] key_reg2; 
     always@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            key_reg0 <= 16'hffff;
            key_reg1 <= 16'hffff;
            key_reg2 <= 16'hffff;
        end
        else if(cnt == CNTMAX) begin
            key_reg0 <= key_in;
            key_reg1 <= key_reg0;
            key_reg2 <= key_reg1;                                
        end
    end
    assign key_deb = (~key_reg0&~key_reg1& ~key_reg2)|(~key_reg0&~key_reg1&key_reg2);

    //根据按键是否按下产生使能状态的状态机
    parameter s0 = 1'b0 ;
    parameter s1 = 1'b1 ;

    reg [2:0] current_state ; //statement
    reg [2:0] next_state ; //statement
    reg [15:0] key_debb;//定义中间比较变量
    reg en;

    always@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            current_state <= s0;
            next_state <= s0;
        end
        else begin
            current_state <= next_state;
            key_debb <= key_deb;

            case(current_state)
            s0:if(key_deb == key_debb) begin//状态s0
                next_state <= s0;
                en <= 0;
            end
            else begin
                next_state <= s1;
                en <= 1;
            end    

            s1:if(key_deb == key_debb) begin//状态s1
                next_state <= s1;
                en <= 0;
            end
            else begin
                next_state <= s0;
                en <= 0;
            end

            default:next_state<=s0;
        endcase
            end
    end
endmodule