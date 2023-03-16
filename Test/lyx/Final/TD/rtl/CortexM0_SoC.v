/*** SoC顶层封装 ***/
module CortexM0_SoC 
(
    input  wire  clk,       //时钟
    input  wire  RSTn,      //SoC使能
    inout  wire  SWDIO,     //SW调试接口 数据
    input  wire  SWCLK,     //SW调试接口 时钟
    output wire  TXD,       //UART串口 输出
    input  wire  RXD,       //UART串口 输入
    inout  wire[31:0] ioPin //GPIO
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
wire        HREADY;         //未知

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

cortexm0ds_logic u_logic 
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
// AHBlite Interconncet
//------------------------------------------------------------------------------

/*** 外设接口 ***/

//P0
wire            HSEL_P0;
wire    [31:0]  HADDR_P0;
wire    [2:0]   HBURST_P0;
wire            HMASTLOCK_P0;
wire    [3:0]   HPROT_P0;
wire    [2:0]   HSIZE_P0;
wire    [1:0]   HTRANS_P0;
wire    [31:0]  HWDATA_P0;
wire            HWRITE_P0;
wire            HREADY_P0;
wire            HREADYOUT_P0;
wire    [31:0]  HRDATA_P0;
wire            HRESP_P0;

//P1
wire            HSEL_P1;
wire    [31:0]  HADDR_P1;
wire    [2:0]   HBURST_P1;
wire            HMASTLOCK_P1;
wire    [3:0]   HPROT_P1;
wire    [2:0]   HSIZE_P1;
wire    [1:0]   HTRANS_P1;
wire    [31:0]  HWDATA_P1;
wire            HWRITE_P1;
wire            HREADY_P1;
wire            HREADYOUT_P1;
wire    [31:0]  HRDATA_P1;
wire            HRESP_P1;

//P2
wire            HSEL_P2;
wire    [31:0]  HADDR_P2;
wire    [2:0]   HBURST_P2;
wire            HMASTLOCK_P2;
wire    [3:0]   HPROT_P2;
wire    [2:0]   HSIZE_P2;
wire    [1:0]   HTRANS_P2;
wire    [31:0]  HWDATA_P2;
wire            HWRITE_P2;
wire            HREADY_P2;
wire            HREADYOUT_P2;
wire    [31:0]  HRDATA_P2;
wire            HRESP_P2;

//P3
wire            HSEL_P3;
wire    [31:0]  HADDR_P3;
wire    [2:0]   HBURST_P3;
wire            HMASTLOCK_P3;
wire    [3:0]   HPROT_P3;
wire    [2:0]   HSIZE_P3;
wire    [1:0]   HTRANS_P3;
wire    [31:0]  HWDATA_P3;
wire            HWRITE_P3;
wire            HREADY_P3;
wire            HREADYOUT_P3;
wire    [31:0]  HRDATA_P3;
wire            HRESP_P3;


/*** 实例化AHBlite内部连接 ***/
AHBlite_Interconnect Interconncet
(
    .HCLK           (clk),
    .HRESETn        (cpuresetn),

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

    // P0
    .HSEL_P0        (HSEL_P0),
    .HADDR_P0       (HADDR_P0),
    .HBURST_P0      (HBURST_P0),
    .HMASTLOCK_P0   (HMASTLOCK_P0),
    .HPROT_P0       (HPROT_P0),
    .HSIZE_P0       (HSIZE_P0),
    .HTRANS_P0      (HTRANS_P0),
    .HWDATA_P0      (HWDATA_P0),
    .HWRITE_P0      (HWRITE_P0),
    .HREADY_P0      (HREADY_P0),
    .HREADYOUT_P0   (HREADYOUT_P0),
    .HRDATA_P0      (HRDATA_P0),
    .HRESP_P0       (HRESP_P0),

    // P1
    .HSEL_P1        (HSEL_P1),
    .HADDR_P1       (HADDR_P1),
    .HBURST_P1      (HBURST_P1),
    .HMASTLOCK_P1   (HMASTLOCK_P1),
    .HPROT_P1       (HPROT_P1),
    .HSIZE_P1       (HSIZE_P1),
    .HTRANS_P1      (HTRANS_P1),
    .HWDATA_P1      (HWDATA_P1),
    .HWRITE_P1      (HWRITE_P1),
    .HREADY_P1      (HREADY_P1),
    .HREADYOUT_P1   (HREADYOUT_P1),
    .HRDATA_P1      (HRDATA_P1),
    .HRESP_P1       (HRESP_P1),

    // P2
    .HSEL_P2        (HSEL_P2),
    .HADDR_P2       (HADDR_P2),
    .HBURST_P2      (HBURST_P2),
    .HMASTLOCK_P2   (HMASTLOCK_P2),
    .HPROT_P2       (HPROT_P2),
    .HSIZE_P2       (HSIZE_P2),
    .HTRANS_P2      (HTRANS_P2),
    .HWDATA_P2      (HWDATA_P2),
    .HWRITE_P2      (HWRITE_P2),
    .HREADY_P2      (HREADY_P2),
    .HREADYOUT_P2   (HREADYOUT_P2),
    .HRDATA_P2      (HRDATA_P2),
    .HRESP_P2       (HRESP_P2),

    // P3
    .HSEL_P3        (HSEL_P3),
    .HADDR_P3       (HADDR_P3),
    .HBURST_P3      (HBURST_P3),
    .HMASTLOCK_P3   (HMASTLOCK_P3),
    .HPROT_P3       (HPROT_P3),
    .HSIZE_P3       (HSIZE_P3),
    .HTRANS_P3      (HTRANS_P3),
    .HWDATA_P3      (HWDATA_P3),
    .HWRITE_P3      (HWRITE_P3),
    .HREADY_P3      (HREADY_P3),
    .HREADYOUT_P3   (HREADYOUT_P3),
    .HRDATA_P3      (HRDATA_P3),
    .HRESP_P3       (HRESP_P3)
);

//------------------------------------------------------------------------------
// AHB RAMCODE
//------------------------------------------------------------------------------

/*** 实例化RAMCODE的Interface ***/

wire [31:0] RAMCODE_RDATA;
wire [31:0] RAMCODE_WDATA;
wire [13:0] RAMCODE_WADDR;
wire [13:0] RAMCODE_RADDR;
wire [3:0]  RAMCODE_WRITE;

AHBlite_Block_RAM RAMCODE_Interface
(
    /* Connect to Interconnect Port 0 */
    .HCLK           (clk),
    .HRESETn        (cpuresetn),
    .HSEL           (HSEL_P0),
    .HADDR          (HADDR_P0),
    .HPROT          (HPROT_P0),
    .HSIZE          (HSIZE_P0),
    .HTRANS         (HTRANS_P0),
    .HWDATA         (HWDATA_P0),
    .HWRITE         (HWRITE_P0),
    .HRDATA         (HRDATA_P0),
    .HREADY         (HREADY_P0),
    .HREADYOUT      (HREADYOUT_P0),
    .HRESP          (HRESP_P0),
    .BRAM_WRADDR    (RAMCODE_WADDR),
    .BRAM_RDADDR    (RAMCODE_RADDR),
    .BRAM_RDATA     (RAMCODE_RDATA),
    .BRAM_WDATA     (RAMCODE_WDATA),
    .BRAM_WRITE     (RAMCODE_WRITE)
    /**********************************/
);

//------------------------------------------------------------------------------
// AHB RAMDATA
//------------------------------------------------------------------------------

/*** 实例化RAMDATA的Interface ***/

wire [31:0] RAMDATA_RDATA;
wire [31:0] RAMDATA_WDATA;
wire [13:0] RAMDATA_WADDR;
wire [13:0] RAMDATA_RADDR;
wire [3:0]  RAMDATA_WRITE;

AHBlite_Block_RAM RAMDATA_Interface
(
    /* Connect to Interconnect Port 1 */
    .HCLK           (clk),
    .HRESETn        (cpuresetn),
    .HSEL           (HSEL_P1),
    .HADDR          (HADDR_P1),
    .HPROT          (HPROT_P1),
    .HSIZE          (HSIZE_P1),
    .HTRANS         (HTRANS_P1),
    .HWDATA         (HWDATA_P1),
    .HWRITE         (HWRITE_P1),
    .HRDATA         (HRDATA_P1),
    .HREADY         (HREADY_P1),
    .HREADYOUT      (HREADYOUT_P1),
    .HRESP          (HRESP_P1),
    .BRAM_WRADDR    (RAMDATA_WADDR),
    .BRAM_RDADDR    (RAMDATA_RADDR),
    .BRAM_WDATA     (RAMDATA_WDATA),
    .BRAM_RDATA     (RAMDATA_RDATA),
    .BRAM_WRITE     (RAMDATA_WRITE)
    /**********************************/
);

//------------------------------------------------------------------------------
// AHB GPIO
//------------------------------------------------------------------------------

/*** 实例化GPIO的Interface ***/

wire [31:0] outEn;
wire [31:0] oData;
wire [31:0] iData;

AHBlite_GPIO GPIO_Interface
(
    /* Connect to Interconnect Port 2 */
    .HCLK			(clk),
    .HRESETn		(cpuresetn),
    .HSEL			(HSEL_P2),
    .HADDR			(HADDR_P2),
    .HPROT			(HPROT_P2),
    .HSIZE			(HSIZE_P2),
    .HTRANS			(HTRANS_P2),
    .HWDATA		    (HWDATA_P2),
    .HWRITE			(HWRITE_P2),
    .HRDATA			(HRDATA_P2),
    .HREADY			(HREADY_P2),
    .HREADYOUT		(HREADYOUT_P2),
    .HRESP			(HRESP_P2),
    .outEn          (outEn),
    .oData          (oData),
    .iData          (iData)
    /**********************************/ 
);

//------------------------------------------------------------------------------
// AHB UART
//------------------------------------------------------------------------------

/*** 实例化UART的Interface ***/
wire state;
wire [7:0] UART_RX_data;
wire [7:0] UART_TX_data;
wire tx_en;

AHBlite_UART UART_Interface
(
    .HCLK           (clk),
    .HRESETn        (cpuresetn),
    .HSEL           (HSEL_P3),
    .HADDR          (HADDR_P3),
    .HPROT          (HPROT_P3),
    .HSIZE          (HSIZE_P3),
    .HTRANS         (HTRANS_P3),
    .HWDATA         (HWDATA_P3),
    .HWRITE         (HWRITE_P3),
    .HRDATA         (HRDATA_P3),
    .HREADY         (HREADY_P3),
    .HREADYOUT      (HREADYOUT_P3),
    .HRESP          (HRESP_P3),
    .UART_RX        (UART_RX_data),
    .state          (state),
    .tx_en          (tx_en),
    .UART_TX        (UART_TX_data)
);

//------------------------------------------------------------------------------
// RAM
//------------------------------------------------------------------------------

// RAMCODE和RAMDATA均是Block_RAM的实例，前者是程序空间，后者是数据空间

/*** 实例化RAMCODE ***/
Block_RAM RAM_CODE
(
    .clka           (clk),
    .addra          (RAMCODE_WADDR),
    .addrb          (RAMCODE_RADDR),
    .dina           (RAMCODE_WDATA),
    .doutb          (RAMCODE_RDATA),
    .wea            (RAMCODE_WRITE)
);

/*** 实例化RAMDATA ***/
Block_RAM RAM_DATA
(
    .clka           (clk),
    .addra          (RAMDATA_WADDR),
    .addrb          (RAMDATA_RADDR),
    .dina           (RAMDATA_WDATA),
    .doutb          (RAMDATA_RDATA),
    .wea            (RAMDATA_WRITE)
);

//------------------------------------------------------------------------------
// GPIO
//------------------------------------------------------------------------------

/*** 实例化GPIO ***/
GPIO GPIO
(
    .outEn(outEn),
    .oData(oData),
    .iData(iData),
    .clk(clk),
    .RSTn(cpuresetn),
    .ioPin(ioPin)
);


//------------------------------------------------------------------------------
// UART
//------------------------------------------------------------------------------

wire clk_uart;
wire bps_en;
wire bps_en_rx,bps_en_tx;

assign bps_en = bps_en_rx | bps_en_tx;

/*** 实例化UART时钟分频器 ***/
clkuart_pwm clkuart_pwm
(
    .clk(clk),
    .RSTn(cpuresetn),
    .clk_uart(clk_uart),
    .bps_en(bps_en)
);

/*** 实例化UART输出TX ***/
UART_TX UART_TX
(
    .clk(clk),
    .clk_uart(clk_uart),
    .RSTn(cpuresetn),
    .data(UART_TX_data),
    .tx_en(tx_en),
    .TXD(TXD),
    .state(state),
    .bps_en(bps_en_tx)
);

/*** 实例化UART输入RX ***/
UART_RX UART_RX
(
    .clk(clk),
    .clk_uart(clk_uart),
    .RSTn(cpuresetn),
    .RXD(RXD),
    .data(UART_RX_data),
    .interrupt(interrupt_UART),
    .bps_en(bps_en_rx)
);

endmodule
