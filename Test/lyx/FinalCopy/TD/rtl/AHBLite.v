`include "GlobalDefine.v"

module AHBLite
(
    // CLK & RST
    input       HCLK,
    input       HRESETn,

    // CORE SIDE
    input       [31:0]  HADDR,
    input       [2:0]   HBURST,
    input               HMASTLOCK,
    input       [3:0]   HPROT,
    input       [2:0]   HSIZE,
    input       [1:0]   HTRANS,
    input       [31:0]  HWDATA,
    input               HWRITE,
    output              HREADY,
    output      [31:0]  HRDATA,
    output              HRESP,
    
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
    output[7:0] SEG,            //八段数码管
    output[3:0] SEGCS,          //八段数码管的位选
    inout[31:0] io_pin0,        //GPIO-0
    inout[31:0] io_pin1,        //GPIO-1
    inout[31:0] io_pin2,        //GPIO-2
    inout[31:0] io_pin3         //GPIO-3
);

wire[2**`DEVICES_EXP-1:0]    HSEL_A;
wire[2**`DEVICES_EXP-1:0]    HREADYOUT_A;
wire[2**`DEVICES_EXP-1:0]    HRESP_A;
wire[2**`DEVICES_EXP*32-1:0] HRDATA_A;

// Decoder---------------------------------------
//-----------------------------------------------

AHBLiteDecoder uDecoder
(
    .HADDR      (HADDR),
    .HSEL_A     (HSEL_A)
);

// Slave MUX-------------------------------------
//-----------------------------------------------
AHBLiteSlaveMux uSlaveMUX
(
    // CLOCK & RST
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
    .HREADY         (HREADY),

    .HSEL_A         (HSEL_A),
    .HREADYOUT_A    (HREADYOUT_A),
    .HRESP_A        (HRESP_A),
    .HRDATA_A       (HRDATA_A),

    .HREADYOUT      (HREADY),
    .HRESP          (HRESP),
    .HRDATA         (HRDATA)
);

AHBLiteBlockRAM #(.ADDR_WIDTH(`RAM_CODE_WIDTH)) uAHBRAMCode
(
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
    .HSEL           (HSEL_A[`idRAMCode]),
    .HADDR          (HADDR),
    .HPROT          (HPROT),
    .HSIZE          (HSIZE),
    .HTRANS         (HTRANS),
    .HWDATA         (HWDATA),
    .HWRITE         (HWRITE),
    .HRDATA         (HRDATA_A[`idRAMCode*32+:32]),
    .HREADY         (HREADY),
    .HREADYOUT      (HREADYOUT_A[`idRAMCode]),
    .HRESP          (HRESP_A[`idRAMCode])
);

AHBLiteBlockRAM #(.ADDR_WIDTH(`RAM_DATA_WIDTH)) uAHBRAMData
(
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
    .HSEL           (HSEL_A[`idRAMData]),
    .HADDR          (HADDR),
    .HPROT          (HPROT),
    .HSIZE          (HSIZE),
    .HTRANS         (HTRANS),
    .HWDATA         (HWDATA),
    .HWRITE         (HWRITE),
    .HRDATA         (HRDATA_A[`idRAMData*32+:32]),
    .HREADY         (HREADY),
    .HREADYOUT      (HREADYOUT_A[`idRAMData]),
    .HRESP          (HRESP_A[`idRAMData])
);


AHBLiteGPIO uAHBGPIO
(
    .HCLK			(HCLK),
    .HRESETn		(HRESETn),
    .HSEL			(HSEL_A[`idGPIO]),
    .HADDR			(HADDR),
    .HPROT			(HPROT),
    .HSIZE			(HSIZE),
    .HTRANS			(HTRANS),
    .HWDATA		    (HWDATA),
    .HWRITE			(HWRITE),
    .HRDATA			(HRDATA_A[`idGPIO*32+:32]),
    .HREADY			(HREADY),
    .HREADYOUT		(HREADYOUT_A[`idGPIO]),
    .HRESP			(HRESP_A[`idGPIO]),
    .io_pin0(io_pin0),
    .io_pin1(io_pin1),
    .io_pin2(io_pin2),
    .io_pin3(io_pin3)
);

AHBLiteUART uAHBUART
(
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
    .HSEL           (HSEL_A[`idUART]),
    .HADDR          (HADDR),
    .HPROT          (HPROT),
    .HSIZE          (HSIZE),
    .HTRANS         (HTRANS),
    .HWDATA         (HWDATA),
    .HWRITE         (HWRITE),
    .HRDATA         (HRDATA_A[`idUART*32+:32]),
    .HREADY         (HREADY),
    .HREADYOUT      (HREADYOUT_A[`idUART]),
    .HRESP          (HRESP_A[`idUART]),
    .TXD(TXD),
    .RXD(RXD)
);

AHBLiteHDMI uAHBHDMI
(
    .HCLK                   (HCLK),
    .HRESETn                (HRESETn),
    .HSEL                   (HSEL_A[`idHDMI]),
    .HADDR                  (HADDR),
    .HPROT                  (HPROT),
    .HSIZE                  (HSIZE),
    .HTRANS                 (HTRANS),
    .HWDATA                 (HWDATA),
    .HWRITE                 (HWRITE),
    .HRDATA                 (HRDATA_A[`idHDMI*32+:32]),
    .HREADY                 (HREADY),
    .HREADYOUT              (HREADYOUT_A[`idHDMI]),
    .HRESP                  (HRESP_A[`idHDMI]),
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D2_P(HDMI_D2_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D0_P(HDMI_D0_P)
);

AHBLiteDigit uAHBDigit
(
    .HCLK			(HCLK),
    .HRESETn		(HRESETn),
    .HSEL			(HSEL_A[`idDigit]),
    .HADDR			(HADDR),
    .HPROT			(HPROT),
    .HSIZE			(HSIZE),
    .HTRANS			(HTRANS),
    .HWDATA		    (HWDATA),
    .HWRITE			(HWRITE),
    .HRDATA			(HRDATA_A[`idDigit*32+:32]),
    .HREADY			(HREADY),
    .HREADYOUT		(HREADYOUT_A[`idDigit]),
    .HRESP			(HRESP_A[`idDigit]),
    .SEG            (SEG),
    .SEGCS          (SEGCS)
);

endmodule