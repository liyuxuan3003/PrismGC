/*** 顶层模块 ***/
module top
(
    input       CLK,            //系统时钟
    input[7:0]  SWI,            //8个开关
    output[7:0] LED,            //8个发光二极管
    output[7:0] SEG,            //八段数码管
    output[3:0] SEGCS,          //八段数码管的位选
    inout       SWDIO,          //SW调试接口 数据
    input       SWCLK,          //SW调试接口 时钟
    output      TXD,            //UART串口 输出TX
    input       RXD             //UART串口 输入RX
);

CortexM0_SoC SoC
(
    .clk(CLK),
    .RSTn(SWI[0]),
    .SWDIO(SWDIO),
    .SWCLK(SWCLK),
    .TXD(TXD),
    .RXD(RXD)
);

assign LED[1]= 1'b1;

endmodule