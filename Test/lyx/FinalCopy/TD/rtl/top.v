/*** 顶层模块 ***/
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
    inout[31:0] NC              //悬空管脚
);

// AHBLite总线相关
wire        HRESETn;
wire [31:0] HADDR;          //传输地址 ADDR-Address
wire [ 2:0] HBURST;         //Burst类型
wire        HMASTLOCK;      //未知 某种锁？
wire [ 3:0] HPROT;          //未知
wire [ 2:0] HSIZE;          //数据宽度 00-8bit 01-16bit 10-32bit
wire [ 1:0] HTRANS;         //传输类型 00-IDLE(无操作) 01-BUSY 10-NONSEQ(主要传输方式) 11-SEQ
wire [31:0] HWDATA;         //由内核发出的写数据
wire        HWRITE;         //读写选择 0-读 1-写
wire [31:0] HRDATA;         //由外设返回的读数据
wire        HRESP;          //传输是否成功 通常为0 传输成功为1
wire        HMASTER;        //未知
wire        HREADY;         //未知

// Interrupt
wire [31:0] IRQ;            //M0的IRQ中断信号

CortexM0 uCortexM0
(
    .CLK(CLK),
    .RSTn(SWI[0]),
    .SWDIO(SWDIO),
    .SWCLK(SWCLK),
    .IRQ            (IRQ),
    .HRESETn        (HRESETn),
    .HADDR          (HADDR),
    .HTRANS         (HTRANS),
    .HSIZE          (HSIZE),
    .HBURST         (HBURST),
    .HPROT          (HPROT),
    .HMASTLOCK      (HMASTLOCK),
    .HWRITE         (HWRITE),
    .HWDATA         (HWDATA),
    .HRDATA         (HRDATA),
    .HREADY         (HREADY),
    .HRESP          (HRESP)
);

AHBLite uAHBLite
(
    .HCLK           (CLK),
    .HRESETn        (HRESETn),

    // CORE SIDE
    .HADDR          (HADDR),
    .HTRANS         (HTRANS),
    .HSIZE          (HSIZE),
    .HBURST         (HBURST),
    .HPROT          (HPROT),
    .HMASTLOCK      (HMASTLOCK),
    .HWRITE         (HWRITE),
    .HWDATA         (HWDATA),
    .HRDATA         (HRDATA),
    .HREADY         (HREADY),
    .HRESP          (HRESP),
    .IRQ(IRQ),                  //中断信号
    .TXD(TXD),                  //UART串口 输出
    .RXD(RXD),                  //UART串口 输入
    .PI4(PI4),
    .HDMI_CLK_P(HDMI_CLK_P),    //HDMI CLK
    .HDMI_D2_P(HDMI_D2_P),      //HDMI D2
    .HDMI_D1_P(HDMI_D1_P),      //HDMI D1
    .HDMI_D0_P(HDMI_D0_P),      //HDMI D0
    .VGA_R(VGA_R),              //VGA R
    .VGA_G(VGA_G),              //VGA G
    .VGA_B(VGA_B),              //VGA B
    .VGA_HS(VGA_HS),            //VGA HS
    .VGA_VS(VGA_VS),            //VGA VS
    .SEG(SEG),                  //八段数码管 段码
    .SEGCS(SEGCS),              //八段数码管 位码
    .io_pin0({NC[15:0],LED,SWI}),
    .io_pin1({NC[31:0]}),
    .io_pin2({NC[31:0]}),
    .io_pin3({NC[31:0]})
);

endmodule