module AHBLite
(
    // CLK & RST
    input   wire    HCLK,
    input   wire    HRESETn,
    input   wire    RSTn,

    // CORE SIDE
    input   wire    [31:0]  HADDR,
    input   wire    [2:0]   HBURST,
    input   wire            HMASTLOCK,
    input   wire    [3:0]   HPROT,
    input   wire    [2:0]   HSIZE,
    input   wire    [1:0]   HTRANS,
    input   wire    [31:0]  HWDATA,
    input   wire            HWRITE,
    output  wire            HREADY,
    output  wire    [31:0]  HRDATA,
    output  wire            HRESP,
    
    output      TXD,           //UART串口 输出
    input       RXD,           //UART串口 输入
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

// Peripheral 0
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

// Peripheral 1
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

//P4
wire            HSEL_P4;
wire    [31:0]  HADDR_P4;
wire    [2:0]   HBURST_P4;
wire            HMASTLOCK_P4;
wire    [3:0]   HPROT_P4;
wire    [2:0]   HSIZE_P4;
wire    [1:0]   HTRANS_P4;
wire    [31:0]  HWDATA_P4;
wire            HWRITE_P4;
wire            HREADY_P4;
wire            HREADYOUT_P4;
wire    [31:0]  HRDATA_P4;
wire            HRESP_P4;

//P5
wire            HSEL_P5;
wire    [31:0]  HADDR_P5;
wire    [2:0]   HBURST_P5;
wire            HMASTLOCK_P5;
wire    [3:0]   HPROT_P5;
wire    [2:0]   HSIZE_P5;
wire    [1:0]   HTRANS_P5;
wire    [31:0]  HWDATA_P5;
wire            HWRITE_P5;
wire            HREADY_P5;
wire            HREADYOUT_P5;
wire    [31:0]  HRDATA_P5;
wire            HRESP_P5;

//P6
wire            HSEL_P6;
wire    [31:0]  HADDR_P6;
wire    [2:0]   HBURST_P6;
wire            HMASTLOCK_P6;
wire    [3:0]   HPROT_P6;
wire    [2:0]   HSIZE_P6;
wire    [1:0]   HTRANS_P6;
wire    [31:0]  HWDATA_P6;
wire            HWRITE_P6;
wire            HREADY_P6;
wire            HREADYOUT_P6;
wire    [31:0]  HRDATA_P6;
wire            HRESP_P6;

//P7
wire            HSEL_P7;
wire    [31:0]  HADDR_P7;
wire    [2:0]   HBURST_P7;
wire            HMASTLOCK_P7;
wire    [3:0]   HPROT_P7;
wire    [2:0]   HSIZE_P7;
wire    [1:0]   HTRANS_P7;
wire    [31:0]  HWDATA_P7;
wire            HWRITE_P7;
wire            HREADY_P7;
wire            HREADYOUT_P7;
wire    [31:0]  HRDATA_P7;
wire            HRESP_P7;

// Public signals--------------------------------
//-----------------------------------------------

// HADDR
assign  HADDR_P0    =   HADDR;
assign  HADDR_P1    =   HADDR;
assign  HADDR_P2    =   HADDR;
assign  HADDR_P3    =   HADDR;
assign  HADDR_P4    =   HADDR;
assign  HADDR_P5    =   HADDR;
assign  HADDR_P6    =   HADDR;
assign  HADDR_P7    =   HADDR;

// HBURST
assign  HBURST_P0   =   HBURST;
assign  HBURST_P1   =   HBURST;
assign  HBURST_P2   =   HBURST;
assign  HBURST_P3   =   HBURST;
assign  HBURST_P4   =   HBURST;
assign  HBURST_P5   =   HBURST;
assign  HBURST_P6   =   HBURST;
assign  HBURST_P7   =   HBURST;

// HMASTLOCK
assign HMASTLOCK_P0 =   HMASTLOCK;
assign HMASTLOCK_P1 =   HMASTLOCK;
assign HMASTLOCK_P2 =   HMASTLOCK;
assign HMASTLOCK_P3 =   HMASTLOCK;
assign HMASTLOCK_P4 =   HMASTLOCK;
assign HMASTLOCK_P5 =   HMASTLOCK;
assign HMASTLOCK_P6 =   HMASTLOCK;
assign HMASTLOCK_P7 =   HMASTLOCK;

// HPROT
assign HPROT_P0     =   HPROT;
assign HPROT_P1     =   HPROT;
assign HPROT_P2     =   HPROT;
assign HPROT_P3     =   HPROT;
assign HPROT_P4     =   HPROT;
assign HPROT_P5     =   HPROT;
assign HPROT_P6     =   HPROT;
assign HPROT_P7     =   HPROT;

// HSIZE
assign HSIZE_P0     =   HSIZE;
assign HSIZE_P1     =   HSIZE;
assign HSIZE_P2     =   HSIZE;
assign HSIZE_P3     =   HSIZE;
assign HSIZE_P4     =   HSIZE;
assign HSIZE_P5     =   HSIZE;
assign HSIZE_P6     =   HSIZE;
assign HSIZE_P7     =   HSIZE;

// HTRANS
assign HTRANS_P0     =   HTRANS;
assign HTRANS_P1     =   HTRANS;
assign HTRANS_P2     =   HTRANS;
assign HTRANS_P3     =   HTRANS;
assign HTRANS_P4     =   HTRANS;
assign HTRANS_P5     =   HTRANS;
assign HTRANS_P6     =   HTRANS;
assign HTRANS_P7     =   HTRANS;

// HWDATA
assign HWDATA_P0     =   HWDATA;
assign HWDATA_P1     =   HWDATA;
assign HWDATA_P2     =   HWDATA;
assign HWDATA_P3     =   HWDATA;
assign HWDATA_P4     =   HWDATA;
assign HWDATA_P5     =   HWDATA;
assign HWDATA_P6     =   HWDATA;
assign HWDATA_P7     =   HWDATA;

// HWRITE
assign HWRITE_P0     =   HWRITE;
assign HWRITE_P1     =   HWRITE;
assign HWRITE_P2     =   HWRITE;
assign HWRITE_P3     =   HWRITE;
assign HWRITE_P4     =   HWRITE;
assign HWRITE_P5     =   HWRITE;
assign HWRITE_P6     =   HWRITE;
assign HWRITE_P7     =   HWRITE;

// HREADY
assign HREADY_P0     =   HREADY;
assign HREADY_P1     =   HREADY;
assign HREADY_P2     =   HREADY;
assign HREADY_P3     =   HREADY;
assign HREADY_P4     =   HREADY;
assign HREADY_P5     =   HREADY;
assign HREADY_P6     =   HREADY;
assign HREADY_P7     =   HREADY;

// Decoder---------------------------------------
//-----------------------------------------------

AHBLiteDecoder Decoder
(
    .HADDR      (HADDR),
    .HSEL_A     ({HSEL_P7,HSEL_P6,HSEL_P5,HSEL_P4,HSEL_P3,HSEL_P2,HSEL_P1,HSEL_P0})
);

// Slave MUX-------------------------------------
//-----------------------------------------------
AHBLiteSlaveMux SlaveMUX
(
    // CLOCK & RST
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
    .HREADY         (HREADY),

    .HSEL_A        ({HSEL_P7,HSEL_P6,HSEL_P5,HSEL_P4,HSEL_P3,HSEL_P2,HSEL_P1,HSEL_P0}),
    .HREADYOUT_A   ({HREADYOUT_P7,HREADYOUT_P6,HREADYOUT_P5,HREADYOUT_P4,HREADYOUT_P3,HREADYOUT_P2,HREADYOUT_P1,HREADYOUT_P0}),
    .HRESP_A       ({HRESP_P7,HRESP_P6,HRESP_P5,HRESP_P4,HRESP_P3,HRESP_P2,HRESP_P1,HRESP_P0}),
    .HRDATA_A      ({HRDATA_P7,HRDATA_P6,HRDATA_P5,HRDATA_P4,HRDATA_P3,HRDATA_P2,HRDATA_P1,HRDATA_P0}),

    .HREADYOUT      (HREADY),
    .HRESP          (HRESP),
    .HRDATA         (HRDATA)
);

//------------------------------------------------------------------------------
// AHB RAMCODE/RAMDATA
//------------------------------------------------------------------------------

/*** 实例化RAMCODE的Interface ***/

AHBLiteBlockRAM RAMCODE_Interface
(
    /* Connect to Interconnect Port 0 */
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
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
    .HRESP          (HRESP_P0)
    /**********************************/
);

/*** 实例化RAMDATA的Interface ***/

AHBLiteBlockRAM RAMDATA_Interface
(
    /* Connect to Interconnect Port 1 */
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
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
    .HRESP          (HRESP_P1)
    /**********************************/
);

//------------------------------------------------------------------------------
// AHB GPIO
//------------------------------------------------------------------------------

/*** 实例化GPIO的Interface ***/

wire [31:0] GPIO0_O_ENA;
wire [31:0] GPIO0_O_DAT;
wire [31:0] GPIO0_I_DAT;

wire [31:0] GPIO1_O_ENA;
wire [31:0] GPIO1_O_DAT;
wire [31:0] GPIO1_I_DAT;

wire [31:0] GPIO2_O_ENA;
wire [31:0] GPIO2_O_DAT;
wire [31:0] GPIO2_I_DAT;

wire [31:0] GPIO3_O_ENA;
wire [31:0] GPIO3_O_DAT;
wire [31:0] GPIO3_I_DAT;

wire [3:0]  GPIO_WRITE;

AHBlite_GPIO GPIO_Interface
(
    /* Connect to Interconnect Port 2 */
    .HCLK			(HCLK),
    .HRESETn		(HRESETn),
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
    .GPIO_WRITE     (GPIO_WRITE),
    .GPIO0_O_ENA     (GPIO0_O_ENA),
    .GPIO0_O_DAT     (GPIO0_O_DAT),
    .GPIO0_I_DAT     (GPIO0_I_DAT),
    .GPIO1_O_ENA     (GPIO1_O_ENA),
    .GPIO1_O_DAT     (GPIO1_O_DAT),
    .GPIO1_I_DAT     (GPIO1_I_DAT),
    .GPIO2_O_ENA     (GPIO2_O_ENA),
    .GPIO2_O_DAT     (GPIO2_O_DAT),
    .GPIO2_I_DAT     (GPIO2_I_DAT),
    .GPIO3_O_ENA     (GPIO3_O_ENA),
    .GPIO3_O_DAT     (GPIO3_O_DAT),
    .GPIO3_I_DAT     (GPIO3_I_DAT)
    /**********************************/ 
);

/*** 实例化GPIO ***/
GPIO GPIO
(
    .write_byte(GPIO_WRITE),
    .o_ena0(GPIO0_O_ENA),
    .o_dat0(GPIO0_O_DAT),
    .i_dat0(GPIO0_I_DAT), 
    .o_ena1(GPIO1_O_ENA),
    .o_dat1(GPIO1_O_DAT),
    .i_dat1(GPIO1_I_DAT), 
    .o_ena2(GPIO2_O_ENA),
    .o_dat2(GPIO2_O_DAT),
    .i_dat2(GPIO2_I_DAT), 
    .o_ena3(GPIO3_O_ENA),
    .o_dat3(GPIO3_O_DAT),
    .i_dat3(GPIO3_I_DAT), 
    .clk(HCLK),
    .RSTn(HRESETn),
    .io_pin0(io_pin0),
    .io_pin1(io_pin1),
    .io_pin2(io_pin2),
    .io_pin3(io_pin3)
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
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
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

wire clk_uart;
wire bps_en;
wire bps_en_rx,bps_en_tx;

assign bps_en = bps_en_rx | bps_en_tx;

/*** 实例化UART时钟分频器 ***/
clkuart_pwm clkuart_pwm
(
    .clk(HCLK),
    .RSTn(HRESETn),
    .clk_uart(clk_uart),
    .bps_en(bps_en)
);

/*** 实例化UART输出TX ***/
UART_TX UART_TX
(
    .clk(HCLK),
    .clk_uart(clk_uart),
    .RSTn(HRESETn),
    .data(UART_TX_data),
    .tx_en(tx_en),
    .TXD(TXD),
    .state(state),
    .bps_en(bps_en_tx)
);

/*** 实例化UART输入RX ***/
UART_RX UART_RX
(
    .clk(HCLK),
    .clk_uart(clk_uart),
    .RSTn(HRESETn),
    .RXD(RXD),
    .data(UART_RX_data),
    .interrupt(interrupt_UART),
    .bps_en(bps_en_rx)
);

//------------------------------------------------------------------------------
// AHB HDMI
//------------------------------------------------------------------------------

wire    [15:0] X_POS;
wire    [15:0] Y_POS;
wire    [23:0] PIXEL;
wire    [23:0] LEN;
wire           ENABLE;
wire    [8:0]  SYS_WR_LEN;
wire           SYS_VAILD;
wire           BUSY;

AHBlite_HDMI HDMI_Interface
(
    /* Connect to Interconnect Port 4 */
    .HCLK                   (HCLK),
    .HRESETn                (HRESETn),
    .HSEL                   (HSEL_P4),
    .HADDR                  (HADDR_P4),
    .HPROT                  (HPROT_P4),
    .HSIZE                  (HSIZE_P4),
    .HTRANS                 (HTRANS_P4),
    .HWDATA                 (HWDATA_P4),
    .HWRITE                 (HWRITE_P4),
    .HRDATA                 (HRDATA_P4),
    .HREADY                 (HREADY_P4),
    .HREADYOUT              (HREADYOUT_P4),
    .HRESP                  (HRESP_P4),
    .X_POS                  (X_POS),
    .Y_POS                  (Y_POS),
    .PIXEL                  (PIXEL),
    .LEN                    (LEN),
    .ENABLE                 (ENABLE),
    .SYS_WR_LEN             (SYS_WR_LEN),
    .SYS_VAILD              (SYS_VAILD),
    .BUSY                   (BUSY)
    /**********************************/ 
);

SDRAM_HDMI_Display u_SDRAM_HDMI_Display
(
    .clk(HCLK),
    .rst_n(RSTn),
    
    //HDMI
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D2_P(HDMI_D2_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D0_P(HDMI_D0_P),

    .x_pos(X_POS),
    .y_pos(Y_POS),
    .pixel(PIXEL),
    .len(LEN),
    .enable(ENABLE),
    .sys_wr_len(SYS_WR_LEN),
    .sys_vaild(SYS_VAILD),
    .busy(BUSY)
);

endmodule