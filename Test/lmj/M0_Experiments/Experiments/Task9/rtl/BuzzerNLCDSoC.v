module BuzzerNLCDSoC(input  wire clk,
                 input  wire RSTn,
                 inout  wire SWDIO,  
                 input  wire SWCLK,
                 input  wire[3:0] col,
                 output wire[3:0] row,
                 output wire PWM,
                 output wire       LCD_CS,
                 output wire       LCD_RS,
                 output wire       LCD_WR,
                 output wire       LCD_RD,
                 output wire       LCD_RST,
                 output wire[15:0] LCD_DATA,
                 output wire       LCD_BL_CTR);
 
//------------------------------------------------------------------------------
// DEBUG IOBUF 
//------------------------------------------------------------------------------

    wire SWDO;
    wire SWDOEN;
    wire SWDI;

    assign SWDI = SWDIO;
    assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

//------------------------------------------------------------------------------
// Interrupt
//------------------------------------------------------------------------------

    wire KeyboardINT,LCD_INI_FINISH,BeatFinIRQ;
    wire [31:0] IRQ;
    assign IRQ = {29'b0,BeatFinIRQ,LCD_INI_FINISH,KeyboardINT};

    wire RXEV;
    assign RXEV = 1'b0;

//------------------------------------------------------------------------------
// AHB
//------------------------------------------------------------------------------

    wire [31:0] HADDR;
    wire [ 2:0] HBURST;
    wire        HMASTLOCK;
    wire [ 3:0] HPROT;
    wire [ 2:0] HSIZE;
    wire [ 1:0] HTRANS;
    wire [31:0] HWDATA;
    wire        HWRITE;
    wire [31:0] HRDATA;
    wire        HRESP;
    wire        HMASTER;
    wire        HREADY;

//------------------------------------------------------------------------------
// RESET AND DEBUG
//------------------------------------------------------------------------------

    wire SYSRESETREQ;
    reg cpuresetn;

    always @(posedge clk or negedge RSTn)begin
            if (~RSTn) cpuresetn <= 1'b0;
            else if (SYSRESETREQ) cpuresetn <= 1'b0;
            else cpuresetn <= 1'b1;
    end

    wire CDBGPWRUPREQ;
    reg CDBGPWRUPACK;

    always @(posedge clk or negedge RSTn)begin
            if (~RSTn) CDBGPWRUPACK <= 1'b0;
            else CDBGPWRUPACK <= CDBGPWRUPREQ;
    end


//------------------------------------------------------------------------------
// Instantiate Cortex-M0 processor logic level
//------------------------------------------------------------------------------

    cortexm0ds_logic u_logic (

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
// Instantiate BuzzerSoC AHB Bus Matrix
//------------------------------------------------------------------------------

    //AHB to APB Port
    wire       AHB2APB_HSEL;
    wire[31:0] AHB2APB_HADDR;
    wire[1:0]  AHB2APB_HTRANS;
    wire[2:0]  AHB2APB_HSIZE;
    wire[3:0]  AHB2APB_HPROT;
    wire       AHB2APB_HWRITE;
    wire       AHB2APB_HREADY;
    wire[31:0] AHB2APB_HWDATA;

    wire       AHB2APB_HREADYOUT;
    wire[31:0] AHB2APB_HRDATA;
    wire       AHB2APB_HRESP; 

    //SBDMA Port
    wire[31:0] SBDMA_HADDR;
    wire[1:0]  SBDMA_HTRANS;
    wire       SBDMA_HWRITE;
    wire[31:0] SBDMA_HRDATA;
    wire       SBDMA_HREADY;

    //BBDMA Port
    wire[31:0] BBDMA_HADDR;
    wire[1:0]  BBDMA_HTRANS;
    wire       BBDMA_HWRITE;
    wire[31:0] BBDMA_HRDATA;
    wire       BBDMA_HREADY;

    //RAMCODE Port
    wire       RAMCODE_HSEL;
    wire[31:0] RAMCODE_HADDR;
    wire[1:0]  RAMCODE_HTRANS;
    wire[2:0]  RAMCODE_HSIZE;
    wire[3:0]  RAMCODE_HPROT;
    wire       RAMCODE_HWRITE;
    wire[31:0] RAMCODE_HWDATA;
    wire       RAMCODE_HREADY;
    wire       RAMCODE_HREADYOUT;
    wire[31:0] RAMCODE_HRDATA;
    wire[1:0]  RAMCODE_HRESP;

    //RAMDATA Port
    wire       RAMDATA_HSEL;
    wire[31:0] RAMDATA_HADDR;
    wire[1:0]  RAMDATA_HTRANS;
    wire[2:0]  RAMDATA_HSIZE;
    wire[3:0]  RAMDATA_HPROT;
    wire       RAMDATA_HWRITE;
    wire[31:0] RAMDATA_HWDATA;
    wire       RAMDATA_HREADY;
    wire       RAMDATA_HREADYOUT;
    wire[31:0] RAMDATA_HRDATA;
    wire[1:0]  RAMDATA_HRESP;

    BuzzerSoCBusMtx BuzzerSoCBusMtx(
        //General Signals
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .REMAP          (4'b0),

        //Master0 Signals Cortex-M0
        .HSELS0                             (1'b1),
        .HADDRS0                            (HADDR),
        .HTRANSS0                           (HTRANS),
        .HWRITES0                           (HWRITE),
        .HSIZES0                            (HSIZE),
        .HBURSTS0                           (HBURST),
        .HPROTS0                            (HPROT),
        .HMASTERS0                          (4'b0000),
        .HWDATAS0                           (HWDATA),
        .HMASTLOCKS0                        (HMASTLOCK),
        .HREADYS0                           (HREADY),
        .HAUSERS0                           (32'b0),
        .HWUSERS0                           (32'b0),
        .HRDATAS0                           (HRDATA),
        .HREADYOUTS0                        (HREADY),
        .HRESPS0                            (HRESP),
        .HRUSERS0                           (),

        //Master1 Signals SBDMA
        .HSELS1                             (1'b1),
        .HADDRS1                            (SBDMA_HADDR),
        .HTRANSS1                           (SBDMA_HTRANS),
        .HWRITES1                           (1'b0),
        .HSIZES1                            (3'b001),
        .HBURSTS1                           (3'b000),
        .HPROTS1                            (4'b0000),
        .HMASTERS1                          (4'b0000),
        .HWDATAS1                           (32'b0),
        .HMASTLOCKS1                        (1'b0),
        .HREADYS1                           (SBDMA_HREADY),
        .HAUSERS1                           (32'b0),
        .HWUSERS1                           (32'b0),
        .HREADYOUTS1                        (SBDMA_HREADY),
        .HRESPS1                            (),
        .HRUSERS1                           (),
        .HRDATAS1                           (SBDMA_HRDATA),

        //Master2 Signals BBDMA
        .HSELS2                             (1'b1),
        .HADDRS2                            (BBDMA_HADDR),
        .HTRANSS2                           (BBDMA_HTRANS),
        .HWRITES2                           (1'b0),
        .HSIZES2                            (3'b001),
        .HBURSTS2                           (3'b000),
        .HPROTS2                            (4'b0000),
        .HMASTERS2                          (4'b0000),
        .HWDATAS2                           (32'b0),
        .HMASTLOCKS2                        (1'b0),
        .HREADYS2                           (BBDMA_HREADY),
        .HAUSERS2                           (32'b0),
        .HWUSERS2                           (32'b0),
        .HREADYOUTS2                        (BBDMA_HREADY),
        .HRESPS2                            (),
        .HRUSERS2                           (),
        .HRDATAS2                           (BBDMA_HRDATA),

        //Slave0 Signals RAMCODE
        .HSELM0                             (RAMCODE_HSEL),
        .HADDRM0                            (RAMCODE_HADDR),
        .HTRANSM0                           (RAMCODE_HTRANS),
        .HWRITEM0                           (RAMCODE_HWRITE),
        .HSIZEM0                            (RAMCODE_HSIZE),
        .HBURSTM0                           (),
        .HPROTM0                            (RAMCODE_HPROT),
        .HMASTERM0                          (),
        .HWDATAM0                           (RAMCODE_HWDATA),
        .HMASTLOCKM0                        (),
        .HREADYMUXM0                        (RAMCODE_HREADY),
        .HAUSERM0                           (),
        .HWUSERM0                           (),
        .HRDATAM0                           (RAMCODE_HRDATA),
        .HREADYOUTM0                        (RAMCODE_HREADYOUT),
        .HRESPM0                            (RAMCODE_HRESP),
        .HRUSERM0                           (32'b0),

        //Slave1 Signals RAMDATA
        .HSELM1                             (RAMDATA_HSEL),
        .HADDRM1                            (RAMDATA_HADDR),
        .HTRANSM1                           (RAMDATA_HTRANS),
        .HWRITEM1                           (RAMDATA_HWRITE),
        .HSIZEM1                            (RAMDATA_HSIZE),
        .HBURSTM1                           (),
        .HPROTM1                            (RAMDATA_HPROT),
        .HMASTERM1                          (),
        .HWDATAM1                           (RAMDATA_HWDATA),
        .HMASTLOCKM1                        (),
        .HREADYMUXM1                        (RAMDATA_HREADY),
        .HAUSERM1                           (),
        .HWUSERM1                           (),
        .HRDATAM1                           (RAMDATA_HRDATA),
        .HREADYOUTM1                        (RAMDATA_HREADYOUT),
        .HRESPM1                            (RAMDATA_HRESP),
        .HRUSERM1                           (32'b0),

        //Slave2 Signals AHB2APB
        .HSELM2                             (AHB2APB_HSEL),
        .HADDRM2                            (AHB2APB_HADDR),
        .HTRANSM2                           (AHB2APB_HTRANS),
        .HWRITEM2                           (AHB2APB_HWRITE),
        .HSIZEM2                            (AHB2APB_HSIZE),
        .HBURSTM2                           (),
        .HPROTM2                            (AHB2APB_HPROT),
        .HMASTERM2                          (),
        .HWDATAM2                           (AHB2APB_HWDATA),
        .HMASTLOCKM2                        (),
        .HREADYMUXM2                        (AHB2APB_HREADY),
        .HAUSERM2                           (),
        .HWUSERM2                           (),
        .HRDATAM2                           (AHB2APB_HRDATA),
        .HREADYOUTM2                        (AHB2APB_HREADYOUT),
        .HRESPM2                            (AHB2APB_HRESP),
        .HRUSERM2                           (32'b0),

        //Scan chain
        .SCANENABLE                         (1'b0),
        .SCANINHCLK                         (1'b0),
        .SCANOUTHCLK                        ()
    );

//------------------------------------------------------------------------------
// Synq AHB to APB Bridge
//------------------------------------------------------------------------------

    //APB Port
    wire[15:0]          PADDR;
    wire                PENABLE;
    wire                PWRITE;
    wire[31:0]          PWDATA;
    wire                PSEL;

    wire[31:0]          PRDATA;
    wire                PREADY;
    wire                PSLVERR;

    cmsdk_ahb_to_apb #(
        .ADDRWIDTH(16),
        .REGISTER_RDATA(0),
        .REGISTER_WDATA(0)
    ) ahb_to_apb(
        //General Signals
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .PCLKEN         (1'b1),

        //AHB Port
        .HSEL           (AHB2APB_HSEL),
        .HADDR          (AHB2APB_HADDR[15:0]),
        .HTRANS         (AHB2APB_HTRANS),
        .HSIZE          (AHB2APB_HSIZE),
        .HPROT          (AHB2APB_HPROT),
        .HWRITE         (AHB2APB_HWRITE),
        .HREADY         (AHB2APB_HREADY),
        .HWDATA         (AHB2APB_HWDATA),
        
        .HREADYOUT      (AHB2APB_HREADYOUT),
        .HRDATA         (AHB2APB_HRDATA),
        .HRESP          (AHB2APB_HRESP),

        //APB Port
        .PADDR          (PADDR),
        .PENABLE        (PENABLE),
        .PWRITE         (PWRITE),
        .PSTRB          (),
        .PPROT          (),
        .PWDATA         (PWDATA),
        .PSEL           (PSEL),

        .APBACTIVE      (),
        
        .PRDATA         (PRDATA),
        .PREADY         (PREADY),
        .PSLVERR        (PSLVERR)
    );

//------------------------------------------------------------------------------
// APB Slave MUX
//------------------------------------------------------------------------------

    //BDMAC port
    wire[31:0] BDMAC_PRDATA;
    wire       BDMAC_PREADYOUT;
    wire[1:0]  BDMAC_PRESP;
    wire       BDMAC_PSEL;
    wire       BDMAC_PREADY;
    wire[31:0] BDMAC_PADDR;
    wire[1:0]  BDMAC_PTRANS;
    wire       BDMAC_PWRITE;
    wire[31:0] BDMAC_PWDATA;

    //Keyboard Port
    wire[31:0] Keyboard_PRDATA;

    //LCD Port
    wire       LCD_PSEL;
    wire       LCD_PREADYOUT;


    cmsdk_apb_slave_mux #(
        .PORT0_ENABLE (1),
        .PORT1_ENABLE (1),
        .PORT2_ENABLE (1),
        .PORT3_ENABLE (0),
        .PORT4_ENABLE (0),
        .PORT5_ENABLE (0),
        .PORT6_ENABLE (0),
        .PORT7_ENABLE (0),
        .PORT8_ENABLE (0),
        .PORT9_ENABLE (0),
        .PORT10_ENABLE(0),
        .PORT11_ENABLE(0),
        .PORT12_ENABLE(0),
        .PORT13_ENABLE(0),
        .PORT14_ENABLE(0),
        .PORT15_ENABLE(0)
    )
    cmsdk_apb_slave_mux(
        .DECODE4BIT     (PADDR[15:12]),
        .PSEL           (PSEL),

        .PSEL0          (BDMAC_PSEL),
        .PREADY0        (BDMAC_PREADYOUT),
        .PRDATA0        (BDMAC_PRDATA),
        .PSLVERR0       (1'b0),

        .PSEL1          (),
        .PREADY1        (1'b1),
        .PRDATA1        (Keyboard_PRDATA),
        .PSLVERR1       (1'b0),

        .PSEL2          (LCD_PSEL),
        .PREADY2        (LCD_PREADYOUT),
        .PRDATA2        (32'b0),
        .PSLVERR2       (1'b0),

        .PSEL3          (),
        .PREADY3        (1'b0),
        .PRDATA3        (32'b0),
        .PSLVERR3       (1'b0),

        .PSEL4          (),
        .PREADY4        (1'b0),
        .PRDATA4        (32'b0),
        .PSLVERR4       (1'b0),

        .PSEL5          (),
        .PREADY5        (1'b0),
        .PRDATA5        (32'b0),
        .PSLVERR5       (1'b0),

        .PSEL6          (),
        .PREADY6        (1'b0),
        .PRDATA6        (32'b0),
        .PSLVERR6       (1'b0),

        .PSEL7          (),
        .PREADY7        (1'b0),
        .PRDATA7        (32'b0),
        .PSLVERR7       (1'b0),

        .PSEL8          (),
        .PREADY8        (1'b0),
        .PRDATA8        (32'b0),
        .PSLVERR8       (1'b0),

        .PSEL9          (),
        .PREADY9        (1'b0),
        .PRDATA9        (32'b0),
        .PSLVERR9       (1'b0),

        .PSEL10         (),
        .PREADY10       (1'b0),
        .PRDATA10       (32'b0),
        .PSLVERR10      (1'b0),

        .PSEL11         (),
        .PREADY11       (1'b0),
        .PRDATA11       (32'b0),
        .PSLVERR11      (1'b0),

        .PSEL12         (),
        .PREADY12       (1'b0),
        .PRDATA12       (32'b0),
        .PSLVERR12      (1'b0),

        .PSEL13         (),
        .PREADY13       (1'b0),
        .PRDATA13       (32'b0),
        .PSLVERR13      (1'b0),

        .PSEL14         (),
        .PREADY14       (1'b0),
        .PRDATA14       (32'b0),
        .PSLVERR14      (1'b0),

        .PSEL15         (),
        .PREADY15       (1'b0),
        .PRDATA15       (32'b0),
        .PSLVERR15      (1'b0),

        .PREADY         (PREADY),
        .PRDATA         (PRDATA),
        .PSLVERR        (PSLVERR)
    );

//------------------------------------------------------------------------------
// Instantiate Buzzer
//------------------------------------------------------------------------------

    Buzzer #(.isSim(0) ,.isAHB(0)) Buzzer(
        //General Signals
        .clk            (clk),
        .rst_n          (cpuresetn),
        
        //BDMAC Master Port
        .BDMAC_RDATA    (BDMAC_PRDATA),
        .BDMAC_READYOUT (BDMAC_PREADYOUT),
        .BDMAC_RESP     (BDMAC_PRESP),
        .BDMAC_SEL      (BDMAC_PSEL),
        .BDMAC_READY    (BDMAC_PREADY),
        .BDMAC_ADDR     (BDMAC_PADDR),
        .BDMAC_TRANS    (BDMAC_PTRANS),
        .BDMAC_WRITE    (BDMAC_PWRITE),
        .BDMAC_WDATA    (BDMAC_PWDATA),

        //SBDMA Slave Port
        .SBDMA_HADDR     (SBDMA_HADDR),
        .SBDMA_HTRANS    (SBDMA_HTRANS),
        .SBDMA_HWRITE    (SBDMA_HWRITE),
        .SBDMA_HRDATA    (SBDMA_HRDATA),
        .SBDMA_HREADY    (SBDMA_HREADY),

        //BBDMA Slave Port
        .BBDMA_HADDR     (BBDMA_HADDR),
        .BBDMA_HTRANS    (BBDMA_HTRANS),
        .BBDMA_HWRITE    (BBDMA_HWRITE),
        .BBDMA_HRDATA    (BBDMA_HRDATA),
        .BBDMA_HREADY    (BBDMA_HREADY),

        //PWM
        .PWM(PWM),
        //IRQ
        .BeatFinIRQ      (BeatFinIRQ)
    );

    assign BDMAC_READY  = 1'b1;
    assign BDMAC_PADDR  = {16'b0,PADDR};
    assign BDMAC_PTRANS = {1'b0,PENABLE};
    assign BDMAC_PWRITE = PWRITE;
    assign BDMAC_PWDATA = PWDATA;

//------------------------------------------------------------------------------
// AHB RAMCODE
//------------------------------------------------------------------------------

    wire [31:0] RAMCODE_RDATA,RAMCODE_WDATA;
    wire [11:0] RAMCODE_WADDR;
    wire [11:0] RAMCODE_RADDR;
    wire [3:0]  RAMCODE_WRITE;

    AHBlite_Block_RAM RAMCODE_Interface(
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .HSEL           (RAMCODE_HSEL),
        .HADDR          (RAMCODE_HADDR),
        .HPROT          (RAMCODE_HPROT),
        .HSIZE          (RAMCODE_HSIZE),
        .HTRANS         (RAMCODE_HTRANS),
        .HWDATA         (RAMCODE_HWDATA),
        .HWRITE         (RAMCODE_HWRITE),
        .HRDATA         (RAMCODE_HRDATA),
        .HREADY         (RAMCODE_HREADY),
        .HREADYOUT      (RAMCODE_HREADYOUT),
        .HRESP          (RAMCODE_HRESP),
        .BRAM_WRADDR    (RAMCODE_WADDR),
        .BRAM_RDADDR    (RAMCODE_RADDR),
        .BRAM_RDATA     (RAMCODE_RDATA),
        .BRAM_WDATA     (RAMCODE_WDATA),
        .BRAM_WRITE     (RAMCODE_WRITE)
    );

//------------------------------------------------------------------------------
// AHB RAMDATA
//------------------------------------------------------------------------------

    wire [31:0] RAMDATA_RDATA;
    wire [31:0] RAMDATA_WDATA;
    wire [11:0] RAMDATA_WADDR;
    wire [11:0] RAMDATA_RADDR;
    wire [3:0]  RAMDATA_WRITE;

    AHBlite_Block_RAM RAMDATA_Interface(
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .HSEL           (RAMDATA_HSEL),
        .HADDR          (RAMDATA_HADDR),
        .HPROT          (RAMDATA_HPROT),
        .HSIZE          (RAMDATA_HSIZE),
        .HTRANS         (RAMDATA_HTRANS),
        .HWDATA         (RAMDATA_HWDATA),
        .HWRITE         (RAMDATA_HWRITE),
        .HRDATA         (RAMDATA_HRDATA),
        .HREADY         (RAMDATA_HREADY),
        .HREADYOUT      (RAMDATA_HREADYOUT),
        .HRESP          (RAMDATA_HRESP),
        .BRAM_WRADDR    (RAMDATA_WADDR),
        .BRAM_RDADDR    (RAMDATA_RADDR),
        .BRAM_WDATA     (RAMDATA_WDATA),
        .BRAM_RDATA     (RAMDATA_RDATA),
        .BRAM_WRITE     (RAMDATA_WRITE)
    );

//------------------------------------------------------------------------------
// RAM
//------------------------------------------------------------------------------

    Block_RAM RAM_CODE(
        .clka           (clk),
        .addra          (RAMCODE_WADDR),
        .addrb          (RAMCODE_RADDR),
        .dina           (RAMCODE_WDATA),
        .doutb          (RAMCODE_RDATA),
        .wea            (RAMCODE_WRITE)
    );

    Block_RAM RAM_DATA(
        .clka           (clk),
        .addra          (RAMDATA_WADDR),
        .addrb          (RAMDATA_RADDR),
        .dina           (RAMDATA_WDATA),
        .doutb          (RAMDATA_RDATA),
        .wea            (RAMDATA_WRITE)
    );

//------------------------------------------------------------------------------
// APB_Keyboard
//------------------------------------------------------------------------------

    APB_Keyboard APB_Keyboard(
        .clk            (clk),
        .rst_n          (cpuresetn),
        .col_in         (col),
        .row            (row),
        .PRDATA         (Keyboard_PRDATA),
        .KeyboardINT    (KeyboardINT)
    );


//------------------------------------------------------------------------------
// AHB LCD
//------------------------------------------------------------------------------

    wire            LCD_CS_run;
    wire            LCD_RS_run;
    wire            LCD_WR_run;
    wire            LCD_RD_run;
    wire            LCD_RST_run;
    wire   [15:0]   LCD_DATA_run;
    wire            LCD_BL_CTR_run;

    wire     LCD_INI_en;
    wire     LCD_MODE;

    AHBlite_LCD LCD_Interface(
            .HCLK           (clk),
            .HRESETn        (cpuresetn),
            .HSEL           (LCD_PSEL),
            .HADDR          ({16'b0,PADDR}),
            .HTRANS         ({PENABLE,1'b0}),
            .HSIZE          (3'b0),
            .HPROT          (4'b0),
            .HWRITE         (PWRITE),
            .HWDATA         (PWDATA),
            .HREADY         (1'b1),
            .HREADYOUT      (LCD_PREADYOUT),

            .LCD_CS         (LCD_CS_run),
            .LCD_RS         (LCD_RS_run),
            .LCD_WR         (LCD_WR_run),
            .LCD_RD         (LCD_RD_run),
            .LCD_RST        (LCD_RST_run),
            .LCD_DATA       (LCD_DATA_run),
            .LCD_BL_CTR     (LCD_BL_CTR_run),

            .LCD_INI_en     (LCD_INI_en),
            .LCD_MODE       (LCD_MODE)
    );

//------------------------------------------------------------------------------
// LCD
//------------------------------------------------------------------------------

    wire            LCD_CS_INI;
    wire            LCD_RS_INI;
    wire            LCD_WR_INI;
    wire            LCD_RD_INI;
    wire            LCD_RST_INI;
    wire   [15:0]   LCD_DATA_INI;
    wire            LCD_BL_CTR_INI;

    LCD_INI LCD_INI(
            .clk             (clk)
            ,.rstn            (cpuresetn)
            ,.en              (LCD_INI_en)
            ,.Initial_finish  (LCD_INI_FINISH)
            ,.LCD_CS          (LCD_CS_INI)
            ,.LCD_RST         (LCD_RST_INI)
            ,.LCD_RS          (LCD_RS_INI)
            ,.LCD_WR          (LCD_WR_INI)
            ,.LCD_RD          (LCD_RD_INI)
            ,.LCD_DATA        (LCD_DATA_INI)
            ,.LCD_BL_CTR      (LCD_BL_CTR_INI)
    );

    assign LCD_CS      = ( LCD_MODE == 1'b1 ) ? LCD_CS_run     : LCD_CS_INI     ;
    assign LCD_RST     = ( LCD_MODE == 1'b1 ) ? LCD_RST_run    : LCD_RST_INI    ;
    assign LCD_RS      = ( LCD_MODE == 1'b1 ) ? LCD_RS_run     : LCD_RS_INI     ;
    assign LCD_WR      = ( LCD_MODE == 1'b1 ) ? LCD_WR_run     : LCD_WR_INI     ;
    assign LCD_RD      = ( LCD_MODE == 1'b1 ) ? LCD_RD_run     : LCD_RD_INI     ;
    assign LCD_DATA    = ( LCD_MODE == 1'b1 ) ? LCD_DATA_run   : LCD_DATA_INI   ;
    assign LCD_BL_CTR  = ( LCD_MODE == 1'b1 ) ? LCD_BL_CTR_run : LCD_BL_CTR_INI ;


endmodule