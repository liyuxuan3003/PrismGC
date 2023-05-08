`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 11:26:00
// Design Name: 
// Module Name: keyboard_instance2
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

//顶层文件
module keyboard_instance2(clk_50M,col,row,seg_led,seg_sel,rstn);
    input clk_50M;
    input [3:0] col;
    input rstn;
    output [3:0] row;
    output [7:0] seg_led;
    output [3:0] seg_sel;

    //例化时钟分频模块
    parameter DIVCLK_CNTMAX = 24999; //50M/1K = 5K
    wire clk_1K;    
    clock_division #(
        .DIVCLK_CNTMAX(DIVCLK_CNTMAX)
    )
    my_clock(
        .clk_in(clk_50M),
        .rstn(rstn),
        .divclk(clk_1K)
    );

    //例化计数器模块
    wire [2:0] bit_disp;
    counter counter(
        .clk(clk_1K),
        .rstn(rstn),
        .cnt(bit_disp)
    );

    //例化按键扫描模块
    wire [15:0] key;
    keyboard_scan keyboard_scan(
        .clk(clk_50M),
        .col(col),
        .row(row),
        .key(key)
    );

    //例化按键消抖模块
    wire [15:0] key_deb;
    wire en;
    key_filter key_filter(
        .clk(clk_50M),
        .rstn(rstn),
        .key_in(key),
        .key_deb(key_deb),
        .en(en)
    );

    //例化独热码转BCD码模块
    wire [3:0] data_in;
    onehot2bin1ry onehot2bin1ry(
        .clk(clk_50M),
        .onehot(key_deb),
        .bin1ry(data_in)
    );

    //例化移位显示器
    wire [3:0] data_0,data_1,data_2,data_3;
    switch switch(
        .en(en),
        .clk(clk_50M),
        .rst(rstn),
        .data_in(data_in),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3)
    );

    //例化多路复用器模块
    wire [3:0] data_disp;
    Mux Mux(
        .sel(bit_disp),
        .ina(data_0),
        .inb(data_1),
        .inc(data_2),
        .ind(data_3),
        .data_out(data_disp)
    );

    //例化数码管位选译码模块
    seg_sel_decoder seg_sel_decoder(
        .bit_disp(bit_disp),
        .seg_sel(seg_sel)
    );

    //例化数码管段码译码模块
    seg_led_decoder seg_led_decoder(
        .data_disp(data_disp),
        .seg_led(seg_led)
    );

endmodule