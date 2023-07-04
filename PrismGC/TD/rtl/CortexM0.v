/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module CortexM0
(
    input           CLK,
    input           RSTn,
    inout           SWDIO,
    input           SWCLK,
    input[31:0]     IRQ,
    output          HRESETn,
    output[31:0]    HADDR,
    output[2:0]     HBURST,
    output          HMASTLOCK,
    output[3:0]     HPROT,
    output[2:0]     HSIZE,
    output[1:0]     HTRANS,
    output[31:0]    HWDATA,
    output          HWRITE,
    input           HREADY,
    input[31:0]     HRDATA,
    input           HRESP
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
// RESET AND DEBUG
//------------------------------------------------------------------------------

wire SYSRESETREQ;
reg  CPURSTn;

always @(posedge CLK or negedge RSTn)
begin
    if (~RSTn) CPURSTn <= 1'b0;
    else if (SYSRESETREQ) CPURSTn <= 1'b0;
    else CPURSTn <= 1'b1;
end

assign HRESETn = CPURSTn;

wire CDBGPWRUPREQ;
reg  CDBGPWRUPACK;

always @(posedge CLK or negedge RSTn)
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
    .FCLK           (CLK),           //FREE running clock 
    .SCLK           (CLK),           //system clock
    .HCLK           (CLK),           //AHB clock
    .DCLK           (CLK),           //Debug clock
    .PORESETn       (RSTn),          //Power on reset
    .HRESETn        (CPURSTn),       //AHB and System reset
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
    .RXEV           (1'b0),         // Generate event when a DMA operation completed.
    .EDBGRQ         (1'b0)          // multi-core synchronous halt request
);

endmodule
