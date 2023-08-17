/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 * 顶层模块
 */

module top
(
    input       CLK,            //系统时钟
    inout[7:0]  SWI,            //8个开关
    inout[7:0]  LED,            //8个发光二极管
    output[7:0] SEG,            //八段数码管
    output[3:0] SEGCS,          //八段数码管的位选
    inout[60:1] PI4,            //下侧双排针
    inout       SWDIO,          //SW调试接口 数据
    input       SWCLK,          //SW调试接口 时钟
    output      TXD,            //UART串口 输出TX
    input       RXD,            //UART串口 输入RX
    output      HDMI_CLK_P,     //HDMI CLK
    output      HDMI_D2_P,      //HDMI D2
    output      HDMI_D1_P,      //HDMI D1
    output      HDMI_D0_P,      //HDMI D0
    output[4:0] VGA_R,          //VGA R
    output[5:0] VGA_G,          //VGA G
    output[4:0] VGA_B,          //VGA B
    output      VGA_HS,         //VGA HS
    output      VGA_VS,         //VGA VS
    output      BUZ,            //蜂鸣器
    output      AUD,            //3.5mm音频输出
    input[3:0]  COL,            //键盘列信号
    output[3:0] ROW,            //键盘行信号
    inout[31:0] NC              //悬空管脚
);

// AHBLite总线相关
wire        HRESETn;        //总线复位信号 低电平有效
wire [31:0] HADDR;          //传输地址 ADDR-Address
wire [ 2:0] HBURST;         //Burst类型
wire        HMASTLOCK;      //未知
wire [ 3:0] HPROT;          //未知
wire [ 2:0] HSIZE;          //数据宽度 00-8bit 01-16bit 10-32bit
wire [ 1:0] HTRANS;         //传输类型 00-IDLE(无操作) 01-BUSY 10-NONSEQ(主要传输方式) 11-SEQ
wire [31:0] HWDATA;         //由内核发出的写数据
wire        HWRITE;         //读写选择 0-读 1-写
wire [31:0] HRDATA;         //由外设返回的读数据
wire        HRESP;          //传输是否成功 通常为0 传输成功为1
wire        HMASTER;        //未使用
wire        HREADY;         //从设备就绪

// Interrupt
wire [31:0] IRQ;            //M0的IRQ中断信号


// M0处理器
CortexM0 uCortexM0
(
    .CLK(CLK),
    .RSTn(SWI[0]),          //SWI[0]作为重置信号
    .SWDIO(SWDIO),
    .SWCLK(SWCLK),
    .IRQ(IRQ),
    .HRESETn(HRESETn),
    .HADDR(HADDR),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HBURST(HBURST),
    .HPROT(HPROT),
    .HMASTLOCK(HMASTLOCK),
    .HWRITE(HWRITE),
    .HWDATA(HWDATA),
    .HRDATA(HRDATA),
    .HREADY(HREADY),
    .HRESP(HRESP)
);

// AHBLite总线
AHBLite uAHBLite
(
    // AHBLite总线信号
    .HCLK(CLK),
    .HRESETn(HRESETn),
    .HADDR(HADDR),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HBURST(HBURST),
    .HPROT(HPROT),
    .HMASTLOCK(HMASTLOCK),
    .HWRITE(HWRITE),
    .HWDATA(HWDATA),
    .HRDATA(HRDATA),
    .HREADY(HREADY),
    .HRESP(HRESP),
    // AHBLite外设
    .IRQ(IRQ),
    .TXD(TXD),
    .RXD(RXD),
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D2_P(HDMI_D2_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D0_P(HDMI_D0_P),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .SEG(SEG),
    .SEGCS(SEGCS),
    .BUZ(BUZ),
    .AUD(AUD),
    .COL(COL),
    .ROW(ROW),
    .io_pin0({NC[15:0],LED,SWI}),
    .io_pin1({NC[29:0],PI4[55],PI4[53]}),
    .io_pin2({NC[31:0]}),
    .io_pin3({NC[31:0]})
);

endmodule