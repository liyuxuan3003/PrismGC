module AHBlite_Interconnect
(
    // CLK & RST
    input   wire    HCLK,
    input   wire    HRESETn,

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

    // Peripheral 2
    output  wire            HSEL_P2,
    output  wire    [31:0]  HADDR_P2,
    output  wire    [2:0]   HBURST_P2,
    output  wire            HMASTLOCK_P2,
    output  wire    [3:0]   HPROT_P2,
    output  wire    [2:0]   HSIZE_P2,
    output  wire    [1:0]   HTRANS_P2,
    output  wire    [31:0]  HWDATA_P2,
    output  wire            HWRITE_P2,
    output  wire            HREADY_P2,
    input   wire            HREADYOUT_P2,
    input   wire    [31:0]  HRDATA_P2,
    input   wire            HRESP_P2,

    // Peripheral 3
    output  wire            HSEL_P3,
    output  wire    [31:0]  HADDR_P3,
    output  wire    [2:0]   HBURST_P3,
    output  wire            HMASTLOCK_P3,
    output  wire    [3:0]   HPROT_P3,
    output  wire    [2:0]   HSIZE_P3,
    output  wire    [1:0]   HTRANS_P3,
    output  wire    [31:0]  HWDATA_P3,
    output  wire            HWRITE_P3,
    output  wire            HREADY_P3,
    input   wire            HREADYOUT_P3,
    input   wire    [31:0]  HRDATA_P3,
    input   wire            HRESP_P3,

    // Peripheral 4
    output  wire            HSEL_P4,
    output  wire    [31:0]  HADDR_P4,
    output  wire    [2:0]   HBURST_P4,
    output  wire            HMASTLOCK_P4,
    output  wire    [3:0]   HPROT_P4,
    output  wire    [2:0]   HSIZE_P4,
    output  wire    [1:0]   HTRANS_P4,
    output  wire    [31:0]  HWDATA_P4,
    output  wire            HWRITE_P4,
    output  wire            HREADY_P4,
    input   wire            HREADYOUT_P4,
    input   wire    [31:0]  HRDATA_P4,
    input   wire            HRESP_P4,

    // Peripheral 5
    output  wire            HSEL_P5,
    output  wire    [31:0]  HADDR_P5,
    output  wire    [2:0]   HBURST_P5,
    output  wire            HMASTLOCK_P5,
    output  wire    [3:0]   HPROT_P5,
    output  wire    [2:0]   HSIZE_P5,
    output  wire    [1:0]   HTRANS_P5,
    output  wire    [31:0]  HWDATA_P5,
    output  wire            HWRITE_P5,
    output  wire            HREADY_P5,
    input   wire            HREADYOUT_P5,
    input   wire    [31:0]  HRDATA_P5,
    input   wire            HRESP_P5,

    // Peripheral 6
    output  wire            HSEL_P6,
    output  wire    [31:0]  HADDR_P6,
    output  wire    [2:0]   HBURST_P6,
    output  wire            HMASTLOCK_P6,
    output  wire    [3:0]   HPROT_P6,
    output  wire    [2:0]   HSIZE_P6,
    output  wire    [1:0]   HTRANS_P6,
    output  wire    [31:0]  HWDATA_P6,
    output  wire            HWRITE_P6,
    output  wire            HREADY_P6,
    input   wire            HREADYOUT_P6,
    input   wire    [31:0]  HRDATA_P6,
    input   wire            HRESP_P6,

    // Peripheral 7
    output  wire            HSEL_P7,
    output  wire    [31:0]  HADDR_P7,
    output  wire    [2:0]   HBURST_P7,
    output  wire            HMASTLOCK_P7,
    output  wire    [3:0]   HPROT_P7,
    output  wire    [2:0]   HSIZE_P7,
    output  wire    [1:0]   HTRANS_P7,
    output  wire    [31:0]  HWDATA_P7,
    output  wire            HWRITE_P7,
    output  wire            HREADY_P7,
    input   wire            HREADYOUT_P7,
    input   wire    [31:0]  HRDATA_P7,
    input   wire            HRESP_P7
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

endmodule