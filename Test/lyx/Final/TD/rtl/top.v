/*** 顶层模块 ***/
module top
(
    input       CLK,            //系统时钟
    inout[7:0]  SWI,            //8个开关
    inout[7:0]  LED,            //8个发光二极管
    inout[7:0]  SEG,            //八段数码管
    inout[3:0]  SEGCS,          //八段数码管的位选
    inout       SWDIO,          //SW调试接口 数据
    input       SWCLK,          //SW调试接口 时钟
    output      TXD,            //UART串口 输出TX
    input       RXD,            //UART串口 输入RX
    inout[31:0] NC              //悬空管脚
);

CortexM0_SoC SoC
(
    .clk(CLK),
    .RSTn(SWI[0]),
    .SWDIO(SWDIO),
    .SWCLK(SWCLK),
    .TXD(TXD),
    .RXD(RXD),
    .ioPin({NC[3:0],SEGCS,SEG,LED,SWI})
);

endmodule