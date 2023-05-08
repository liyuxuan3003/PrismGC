/*** SoC顶层封装 ***/
module CortexM0_SoC 
(
    input       clk,            //时钟
    input       RSTn,           //SoC使能
    inout       SWDIO,          //SW调试接口 数据
    input       SWCLK,          //SW调试接口 时钟
    output      TXD,            //UART串口 输出
    input       RXD,            //UART串口 输入
    output      HDMI_CLK_P,     //HDMI CLK
    output      HDMI_D2_P,      //HDMI D2
    output      HDMI_D1_P,      //HDMI D1
    output      HDMI_D0_P,      //HDMI D0
    output[4:0] VGA_R,          //VGA R
    output[5:0] VGA_G,          //VGA G
    output[4:0] VGA_B,          //VGA B
    output      VGA_HS,         //VGA HS
    output      VGA_VS,         //VGA VS
    inout[31:0] io_pin0,        //GPIO-0
    inout[31:0] io_pin1,        //GPIO-1
    inout[31:0] io_pin2,        //GPIO-2
    inout[31:0] io_pin3         //GPIO-3
);

//------------------------------------------------------------------------------
// DEBUG IOBUF 
//------------------------------------------------------------------------------

wire SWDI;      //SW调试接口 输入
wire SWDO;      //SW调试接口 输出
wire SWDOEN;    //SW调试接口 输出使能

//输入模式下，SWDIO输入的信号接至SWDI
assign SWDI = SWDIO;

//输出模式下，SWDIO输出SWDO的值，但如果SWDOEN=0，SWDIO输出高阻态
assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

//------------------------------------------------------------------------------
// Interrupt
//------------------------------------------------------------------------------

wire [31:0] IRQ;        //M0的IRQ中断信号

wire interrupt_UART;    //UART产生的中断信号

/*Connect the IRQ with UART*/
assign IRQ = {31'b0,interrupt_UART};
/***************************/

wire RXEV;
assign RXEV = 1'b0;     //?????

//------------------------------------------------------------------------------
// AHB
//------------------------------------------------------------------------------

// AHBLite总线相关
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
wire        HREADY;         //总线数据准备完成

//------------------------------------------------------------------------------
// RESET AND DEBUG
//------------------------------------------------------------------------------

wire SYSRESETREQ;
reg  cpuresetn;

always @(posedge clk or negedge RSTn)
begin
    if (~RSTn) cpuresetn <= 1'b0;
    else if (SYSRESETREQ) cpuresetn <= 1'b0;
    else cpuresetn <= 1'b1;
end

wire CDBGPWRUPREQ;
reg  CDBGPWRUPACK;

always @(posedge clk or negedge RSTn)
begin
    if (~RSTn) CDBGPWRUPACK <= 1'b0;
    else CDBGPWRUPACK <= CDBGPWRUPREQ;
end

//------------------------------------------------------------------------------
// Instantiate Cortex-M0 processor logic level
//------------------------------------------------------------------------------

cortexm0ds_logic uCortexM0 
(
    // System inputs
    .FCLK           (clk),           //FREE running clock 
    .SCLK           (clk),           //system clock
    .HCLK           (clk),           //AHB clock
    .DCLK           (clk),           //Debug clock
    .PORESETn       (RSTn),          //Power on reset
    .HRESETn        (cpuresetn),     //AHB and System reset
    .DBGRESETn      (RSTn),          //Debug Reset
    .RSTBYPASS      (1'b0),          //Reset bypass
    .SE             (1'b0),          // dummy scan enable port for synthesis

    // Power management inputs
    .SLEEPHOLDREQn  (1'b1),          // Sleep extension request from PMU
    .WICENREQ       (1'b0),          // WIC enable request from PMU
    .CDBGPWRUPACK   (CDBGPWRUPACK),  // Debug Power Up ACK from PMU

    // Power management outputs
    .CDBGPWRUPREQ   (CDBGPWRUPREQ),
    .SYSRESETREQ    (SYSRESETREQ),

    // System bus
    .HADDR          (HADDR[31:0]),
    .HTRANS         (HTRANS[1:0]),
    .HSIZE          (HSIZE[2:0]),
    .HBURST         (HBURST[2:0]),
    .HPROT          (HPROT[3:0]),
    .HMASTER        (HMASTER),
    .HMASTLOCK      (HMASTLOCK),
    .HWRITE         (HWRITE),
    .HWDATA         (HWDATA[31:0]),
    .HRDATA         (HRDATA[31:0]),
    .HREADY         (HREADY),
    .HRESP          (HRESP),

    // Interrupts
    .IRQ            (IRQ),          //Interrupt
    .NMI            (1'b0),         //Watch dog interrupt
    .IRQLATENCY     (8'h0),
    .ECOREVNUM      (28'h0),

    // Systick
    .STCLKEN        (1'b0),
    .STCALIB        (26'h0),

    // Debug - JTAG or Serial wire
    // Inputs
    .nTRST          (1'b1),
    .SWDITMS        (SWDI),
    .SWCLKTCK       (SWCLK),
    .TDI            (1'b0),
    // Outputs
    .SWDO           (SWDO),
    .SWDOEN         (SWDOEN),

    .DBGRESTART     (1'b0),

    // Event communication
    .RXEV           (RXEV),         // Generate event when a DMA operation completed.
    .EDBGRQ         (1'b0)          // multi-core synchronous halt request
);

//------------------------------------------------------------------------------
// AHBLite
//------------------------------------------------------------------------------

AHBLite uAHBLite
(
    .HCLK(clk),
    .HRESETn(cpuresetn),
    .HADDR(HADDR),
    .HBURST(HBURST),
    .HMASTLOCK(HMASTLOCK),
    .HPROT(HPROT),
    .HSIZE(HSIZE),
    .HTRANS(HTRANS),
    .HWDATA(HWDATA),
    .HWRITE(HWRITE),
    .HREADY(HREADY),
    .HRDATA(HRDATA),
    .HRESP(HRESP)
);

endmodule
