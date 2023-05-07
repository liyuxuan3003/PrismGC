`include "../GlobalDefine.v"

`timescale 1ns / 1ns
module SDRAM_HDMI_Display
(
    //global clock
    input               clk,
    input               rst_n,          //global reset
    
	//HDMI
	output			HDMI_CLK_P,
	output			HDMI_D2_P,
	output			HDMI_D1_P,
	output			HDMI_D0_P,
    //output[60:1]    PI4,            //下侧双排针

    input           bitPingPong,   

    // input[31:0]     pingAddr,
    // input[31:0]     pongAddr,
    output          WR_EMPTY,
    output          WR_FULL,
    output          WR_AFULL,
    output          WR_EN,
    output          WR_LOAD,

    //LCD
    input[15:0]         x_pos,
    input[15:0]         y_pos,
    input[23:0]         pixel,
    input[23:0]         len,
    input               enable,
    input[8:0]          sys_wr_len,
    output              sys_vaild,
    output              busy
);

//---------------------------------------------
//system global clock control
wire    clk_ref;    //sdram ctrl clock
wire    clk_refout; //sdram clock output
wire	clk_pixel, clk_pixel_5x;
wire    sys_rst_n;  //global reset
system_ctrl_pll u_system_ctrl_pll
(
    .clk            (clk),          //50MHz
	.rst_n			(rst_n),	    //global reset
    
    .sys_rst_n      (sys_rst_n),    //global reset
    .clk_c0         (clk_ref),      //144MHz 
    .clk_c1         (clk_refout),   //144MHz -90deg
	.clk_c2			(clk_pixel),	//1x pixel clock
	.clk_c3			(clk_pixel_5x)	//5x pixel clock
);


//-------------------------------------------
//Generate LCD Test picture
wire            sys_load;
wire    [23:0]  sys_data;
wire            sys_we;
wire    [31:0]  sys_addr_min;
wire    [31:0]  sys_addr_max;

wire            sdram_init_done;            //sdram init done
assign WR_LOAD = sys_load;
assign WR_EN   = sys_we;

LCD_Control    
#(
    .H_DISP             (`H_DISP),
    .V_DISP             (`V_DISP)
)
u_LCD_Control
(
    .clk                (clk_ref),        
    .rst_n              (sys_rst_n),     
    
    .sys_vaild          (sdram_init_done),
    .sys_load           (sys_load),
    .sys_data           (sys_data),    
    .sys_we             (sys_we),
    .sys_addr_min       (sys_addr_min),
    .sys_addr_max       (sys_addr_max),
    .sys_refresh        (Sdram_Write_Refresh),
    
    .x_pos(x_pos),
    .y_pos(y_pos),
    .pixel(pixel),
    .len(len),
    .enable(enable),
    .busy(busy)
);

assign sys_vaild = sdram_init_done;

//-----------------------------------------
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
SDRAM_512Kx4x32bit	u_SDRAM_512Kx4x32bit
(
	.clk                (sdram_clk),    //sdram clock
	.cke                (sdram_cke),    //sdram clock enable
	.cs_n               (sdram_cs_n),   //sdram chip select
	.ras_n              (sdram_ras_n),  //sdram row address strobe
	.cas_n              (sdram_cas_n),  //sdram column address strobe
	.we_n               (sdram_we_n),   //sdram write enable
	.addr               (sdram_addr),   //sdram address[10:0] 
	.ba                 (sdram_ba),     //sdram bank address
	.dq                 (sdram_data),   //sdram data[31:0] 

	.dm0                (sdram_dqm[0]), //sdram data enable
	.dm1                (sdram_dqm[1]), //sdram data enable
	.dm2                (sdram_dqm[2]), //sdram data enable
	.dm3                (sdram_dqm[3])  //sdram data enable
);	
	
//-------------------------------------
//Sdram_Control_2Port module     
//sdram write port
wire            clk_write   =   clk_ref;    //Change with input signal
wire    [31:0]  sys_data_in =   {sys_data, sys_data[7:0]};
//sdram read port
wire            clk_read    =   clk_pixel;    //Change with vga timing    
wire    [31:0]  sys_data_out;
wire            sys_rd_out;
wire sys_rload;

`define PING_PONG_0 21'h0
`define PING_PONG_1 21'h100_000

wire [20:0] wr_min_addr = bitPingPong ? (`PING_PONG_0 | sys_addr_min) : (`PING_PONG_1 | sys_addr_min);
wire [20:0] wr_max_addr = bitPingPong ? (`PING_PONG_0 | sys_addr_max) : (`PING_PONG_1 | sys_addr_max);

wire [20:0] rd_min_addr = bitPingPong ? (`PING_PONG_1) : (`PING_PONG_0);
wire [20:0] rd_max_addr = bitPingPong ? (`PING_PONG_1 | (`H_DISP * `V_DISP)) : (`PING_PONG_0 | (`H_DISP * `V_DISP));

// wire [31:0] wr_min_addr = pongAddr | sys_addr_min;
// wire [31:0] wr_max_addr = pongAddr | sys_addr_max;
// wire [31:0] rd_min_addr = pingAddr;
// wire [31:0] rd_max_addr = pingAddr | (`H_DISP * `V_DISP);

wire [7:0] Sdram_Write_Refresh;

Sdram_Control_2Port    u_Sdram_Control_2Port
(
    //    HOST Side
    .REF_CLK            (clk_ref),          //sdram module clock
    .OUT_CLK            (clk_refout),       //sdram clock input
    .RESET_N            (sys_rst_n),        //sdram module reset

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
    .WR_CLK             (clk_ref),        //write fifo clock
    .WR_LOAD            (sys_load),         //write register load & fifo clear
    .WR_DATA            (sys_data_in),      //write data input
    .WR                 (sys_we),           //write data request
    // .WR_MIN_ADDR        (sys_addr_min),     //write start address
    // .WR_MAX_ADDR        (sys_addr_max),     //write max address
    .WR_MIN_ADDR        (wr_min_addr),     //write start address
    .WR_MAX_ADDR        (wr_max_addr),     //write max address
    .WR_LENGTH          (sys_wr_len),       //write burst length
    //.WR_LENGTH          (9'd256),       //write burst length


    .WR_EMPTY           (WR_EMPTY),
    .WR_FULL            (WR_FULL),
    .WR_AFULL           (WR_AFULL),

    //    FIFO Read Side
    .RD_CLK             (clk_read),         //read fifo clock
    .RD_LOAD            (1'b0),             //read register load & fifo clear
    // .RD_LOAD            (sys_rload),
    .RD_DATA            (sys_data_out),     //read data output
    .RD                 (sys_rd_out),       //read request
    // .RD_MIN_ADDR        (0),         //read start address
    // .RD_MAX_ADDR        (`H_DISP * `V_DISP),//read max address
    .RD_MIN_ADDR        (rd_min_addr),         //read start address
    .RD_MAX_ADDR        (rd_max_addr),//read max address
    .RD_LENGTH          (9'd256),           //read length

    .Sdram_Init_Done    (sdram_init_done),  //SDRAM init done signal
    .Sdram_Read_Valid   (1'b1),             //Enable to read
    .Sdram_Write_Refresh  (Sdram_Write_Refresh)
);

wire CounterX;
wire CounterY;

assign sys_rload=CounterX == `H_TOTAL-1 && CounterY == `V_TOTAL-1;

GPUHDMIEncoder uGPUHDMIEncoder
(
    .clk(clk_pixel),
    .clk_TMDS(clk_pixel_5x),
    .rstn(sys_rst_n),
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D0_P(HDMI_D0_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D2_P(HDMI_D2_P),
    .CounterX(CounterX),
    .CounterY(CounterY),
    .RGB(sys_data_out[31:8]),
    .Request(sys_rd_out)
);

endmodule