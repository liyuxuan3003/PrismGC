/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

`include "GlobalDefine.v"

module GPU 
(
    input               clk,
    input               rstn,
    input[7:0]          addrIn,
    input[7:0]          addrOut,
    input[3:0]          sizeDecode,
    input[31:0]         dataIn,
    output reg[31:0]    dataOut,
    output              HDMI_CLK_P,
    output              HDMI_D2_P,
    output              HDMI_D1_P,
    output              HDMI_D0_P
);

`define X_POS       0
`define Y_POS       1
`define PIXEL       2
`define LEN         3
`define ENABLE      4
`define SYS_WR_LEN  5
`define SYS_VAILD   6
`define BUSY        7
`define PING_PONG   8

reg [31:0] mem [15:0];
reg enableState;
always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[`X_POS] <= 0;
        mem[`Y_POS] <= 0;
        mem[`PIXEL] <= 0;
        mem[`LEN] <= 0;
        mem[`ENABLE] <= 0;
        mem[`SYS_WR_LEN] <= 0;
        mem[`SYS_VAILD] <= 0;
        mem[`BUSY] <= 0;
        mem[`PING_PONG] <= 0;
        enableState <= 0;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[3:0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[3:0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[3:0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[3:0]][31:24] <= dataIn[31:24];

        mem[`SYS_VAILD] <= {31'b0,sysVaild};
        mem[`BUSY] <= {31'b0,busy};

        dataOut <= mem[addrOut[3:0]]; 

        if (mem[`BUSY][0] & mem[`ENABLE][0])
            enableState <= 1;
        if(enableState & ~mem[`BUSY][0] & mem[`ENABLE][0])
            enableState <= 0;
    end
end

wire sysVaild;
wire busy;

// SDRAM_HDMI_Display u_SDRAM_HDMI_Display
// (
//     .clk(clk),
//     .rst_n(rstn),
    
//     .HDMI_CLK_P(HDMI_CLK_P),
//     .HDMI_D2_P(HDMI_D2_P),
//     .HDMI_D1_P(HDMI_D1_P),
//     .HDMI_D0_P(HDMI_D0_P),

//     .bitPingPong(mem[`PING_PONG][0]),

//     .x_pos(mem[`X_POS][15:0]),
//     .y_pos(mem[`Y_POS][15:0]),
//     .pixel(mem[`PIXEL][23:0]),
//     .len(mem[`LEN][23:0]),
//     .enable(mem[`ENABLE][0]),
//     .sys_wr_len(mem[`SYS_WR_LEN][8:0]),
//     .sys_vaild(sysVaild),
//     .busy(busy)
// );


// System PLL
wire clkRef;       //sdram ctrl clock
wire clkRefOut;    //sdram clock output
wire clkPixel;
wire clkPixel5x;
wire sysRstn;      //sysRstn assign by SystemCrtlPLL
SystemCrtlPLL uSystemCrtlPLL
(
    .clk            (clk),          //50MHz
	.rst_n			(rstn),
    
    .sys_rst_n      (sysRstn),
    .clk_c0         (clkRef),
    .clk_c1         (clkRefOut),
	.clk_c2			(clkPixel),
	.clk_c3			(clkPixel5x)
);


// LCD Control
wire        sysLoad;
wire[23:0]  sysData;
wire        sysWriteEnable;
wire[31:0]  sysAddrMin;
wire[31:0]  sysAddrMax;

LCD_Control#(
    .H_DISP             (`H_DISP),
    .V_DISP             (`V_DISP)
)
u_LCD_Control
(
    .clk                (clkRef),        
    .rst_n              (sysRstn),     
    
    .sys_vaild          (sysVaild),
    .sys_load           (sysLoad),
    .sys_data           (sysData),    
    .sys_we             (sysWriteEnable),
    .sys_addr_min       (sysAddrMin),
    .sys_addr_max       (sysAddrMax),
    .sys_refresh        (Sdram_Write_Refresh),
    
    .x_pos(mem[`X_POS][15:0]),
    .y_pos(mem[`Y_POS][15:0]),
    .pixel(mem[`PIXEL][23:0]),
    .len(mem[`LEN][23:0]),
    .enable(mem[`ENABLE][0]),
    .busy(busy)
);

//EM638325 SDRAM_512Kx4x32bit
wire            sdram_clk;      //sdram clock
wire            sdram_cke;      //sdram clock enable
wire            sdram_cs_n;     //sdram chip select
wire            sdram_we_n;     //sdram write enable
wire            sdram_cas_n;    //sdram column address strobe
wire            sdram_ras_n;    //sdram row address strobe
wire    [3:0]   sdram_dqm;      //sdram data enable
wire    [1:0]   sdram_ba;       //sdram bank address
wire    [10:0]  sdram_addr;     //sdram address
wire    [31:0]  sdram_data;     //sdram data

EG_PHY_SDRAM_2M_32 uSDRAM
(
    .clk(sdram_clk),
    .ras_n(sdram_ras_n),
    .cas_n(sdram_cas_n),
    .we_n(sdram_we_n),
    .addr(sdram_addr),
    .ba(sdram_ba),
    .dq(sdram_data),
    .cs_n(sdram_cs_n),
    .dm0(sdram_dqm[0]),
    .dm1(sdram_dqm[1]),
    .dm2(sdram_dqm[2]),
    .dm3(sdram_dqm[3]),
    .cke(sdram_cke)
);

//Sdram_Control_2Port module     
//sdram write port
wire[31:0]  sysDataIn = {sysData, sysData[7:0]};
//sdram read port
wire[31:0]  sysDataOut;
wire        sysReadRequest;

`define PING_PONG_0 21'h0
`define PING_PONG_1 21'h100_000

wire bitPingPong=mem[`PING_PONG][0];

wire [20:0] wr_min_addr = bitPingPong ? (`PING_PONG_0 | sysAddrMin) : (`PING_PONG_1 | sysAddrMin);
wire [20:0] wr_max_addr = bitPingPong ? (`PING_PONG_0 | sysAddrMax) : (`PING_PONG_1 | sysAddrMax);

wire [20:0] rd_min_addr = bitPingPong ? (`PING_PONG_1) : (`PING_PONG_0);
wire [20:0] rd_max_addr = bitPingPong ? (`PING_PONG_1 | (`H_DISP * `V_DISP)) : (`PING_PONG_0 | (`H_DISP * `V_DISP));

wire [7:0] Sdram_Write_Refresh;

Sdram_Control_2Port    u_Sdram_Control_2Port
(
    //    HOST Side
    .REF_CLK            (clkRef),          //sdram module clock
    .OUT_CLK            (clkRefOut),       //sdram clock input
    .RESET_N            (sysRstn),        //sdram module reset

    //    SDRAM Side
    .SDR_CLK            (sdram_clk),        //sdram clock
    .CKE                (sdram_cke),        //sdram clock enable
    .CS_N               (sdram_cs_n),       //sdram chip select
    .WE_N               (sdram_we_n),       //sdram write enable
    .CAS_N              (sdram_cas_n),      //sdram column address strobe
    .RAS_N              (sdram_ras_n),      //sdram row address strobe
    .DQM                (sdram_dqm),        //sdram data output enable
    .BA                 (sdram_ba),         //sdram bank address
    .SA                 (sdram_addr),       //sdram address
    .DQ                 (sdram_data),       //sdram data

    //    FIFO Write Side
    .WR_CLK             (clkRef),        //write fifo clock
    .WR_LOAD            (sysLoad),         //write register load & fifo clear
    .WR_DATA            (sysDataIn),      //write data input
    .WR                 (sysWriteEnable),           //write data request
    .WR_MIN_ADDR        (wr_min_addr),     //write start address
    .WR_MAX_ADDR        (wr_max_addr),     //write max address
    .WR_LENGTH          (mem[`SYS_WR_LEN][8:0]),       //write burst length


    .WR_EMPTY           (WR_EMPTY),
    .WR_FULL            (WR_FULL),
    .WR_AFULL           (WR_AFULL),

    //    FIFO Read Side
    .RD_CLK             (clkPixel),         //read fifo clock
    .RD_LOAD            (1'b0),             //read register load & fifo clear
    .RD_DATA            (sysDataOut),     //read data output
    .RD                 (sysReadRequest),       //read request
    .RD_MIN_ADDR        (rd_min_addr),         //read start address
    .RD_MAX_ADDR        (rd_max_addr),//read max address
    .RD_LENGTH          (9'd256),           //read length

    .Sdram_Init_Done    (sysVaild),  //SDRAM init done signal
    .Sdram_Read_Valid   (1'b1),             //Enable to read
    .Sdram_Write_Refresh  (Sdram_Write_Refresh)
);

wire CounterX;
wire CounterY;

GPUHDMIEncoder uGPUHDMIEncoder
(
    .clk(clkPixel),
    .clk_TMDS(clkPixel5x),
    .rstn(sysRstn),
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D0_P(HDMI_D0_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D2_P(HDMI_D2_P),
    .CounterX(CounterX),
    .CounterY(CounterY),
    .RGB(sysDataOut[31:8]),
    .Request(sysReadRequest)
);

endmodule