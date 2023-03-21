/*** 顶层模块 ***/
module top
(
    input       CLK,            //系统时钟
    inout[7:0]  SWI,            //8个开关
    inout[7:0]  LED,            //8个发光二极管
    inout[7:0]  SEG,            //八段数码管
    inout[3:0]  SEGCS,          //八段数码管的位选
    inout[60:1] PI4,            //下侧双排针
    inout       SWDIO,          //SW调试接口 数据
    input       SWCLK,          //SW调试接口 时钟
    output      TXD,            //UART串口 输出TX
    input       RXD,            //UART串口 输入RX
    inout[31:0] NC              //悬空管脚
);

wire[3:0] DIG0;
wire[3:0] DIG1;
wire[3:0] DIG2;
wire[3:0] DIG3;
wire[3:0] DIG_DOT;
wire[3:0] DIG_ENA;
wire[3:0] DIG_CRT;

Digit Digit
(
    .clk(CLK),
    .seg_pin(SEG),
    .segcs_pin(SEGCS),
    .DIG0(DIG0),
    .DIG1(DIG1),
    .DIG2(DIG2),
    .DIG3(DIG3),
    .DIG_DOT(DIG_DOT),
    .DIG_ENA(DIG_ENA),
    .DIG_CRT(DIG_CRT)
);

CortexM0_SoC SoC
(
    .clk(CLK),
    .RSTn(SWI[0]),
    .SWDIO(SWDIO),
    .SWCLK(SWCLK),
    .TXD(TXD),
    .RXD(RXD),
    .io_pin0({NC[15:0],LED,SWI}),
    .io_pin1({NC[23:0],PI4[19],PI4[17],PI4[15],PI4[13],PI4[11],PI4[9],PI4[7],PI4[5]}),
    .io_pin2({NC[3:0],DIG_CRT,DIG_ENA,DIG_DOT,DIG3,DIG2,DIG1,DIG0}),
    .io_pin3({NC[31:0]})
);

endmodule