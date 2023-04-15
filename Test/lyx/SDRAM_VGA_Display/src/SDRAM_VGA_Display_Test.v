`include "lcd_24bit_ip/lcd_para.v"

`timescale 1ns / 1ns
module SDRAM_VGA_Display_Test
(
    //global clock 24MHz
    input               clk_24m,          //24MHz
//    input               rst_n,          //global reset
    
	//HDMI
	output			HDMI_CLK_P,
	output			HDMI_D2_P,
	output			HDMI_D1_P,
	output			HDMI_D0_P
);

//---------------------------------------------
//system global clock control
wire    clk_ref;    //sdram ctrl clock
wire    clk_refout; //sdram clock output
wire	clk_pixel, clk_pixel_5x;
wire    sys_rst_n;  //global reset
system_ctrl_pll u_system_ctrl_pll
(
    .clk            (clk_24m),      //24MHz
	.rst_n			(1'b1),			//global reset
    
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

wire[15:0]         x_pos;
wire[15:0]         y_pos;
wire[23:0]         pixel;
wire[23:0]         len;
wire               enable;

wire               busy;

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

    .x_pos(x_pos),
    .y_pos(y_pos),
    .pixel(pixel),
    .len(len),
    .enable(enable),
    .busy(busy)
);

LCD_ControlTest u_LCD_ControlTest
(
    .clk                (clk_ref),        
    .rst_n              (sys_rst_n),     

    .x_pos(x_pos),
    .y_pos(y_pos),
    .pixel(pixel),
    .len(len),
    .enable(enable),
    .busy(busy)
);

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
    .WR_CLK             (clk_write),        //write fifo clock
    .WR_LOAD            (sys_load),         //write register load & fifo clear
    .WR_DATA            (sys_data_in),      //write data input
    .WR                 (sys_we),           //write data request
    .WR_MIN_ADDR        (sys_addr_min),     //write start address
    .WR_MAX_ADDR        (sys_addr_max),     //write max address
    .WR_LENGTH          (9'd32),           //write burst length

    //    FIFO Read Side
    .RD_CLK             (clk_read),         //read fifo clock
    .RD_LOAD            (1'b0),             //read register load & fifo clear
    .RD_DATA            (sys_data_out),     //read data output
    .RD                 (sys_rd_out),       //read request
    .RD_MIN_ADDR        (21'd0),            //read start address
    .RD_MAX_ADDR        (`H_DISP * `V_DISP),//read max address
    .RD_LENGTH          (9'd256),           //read length
    
    //User interface add by CrazyBingo
    .Sdram_Init_Done    (sdram_init_done),  //SDRAM init done signal
    .Sdram_Read_Valid   (1'b1),             //Enable to read
    .Sdram_PingPong_EN  (1'b0)              //SDRAM PING-PONG operation enable
);


//-------------------------------------
//LCD driver timing
wire  			VGA_DE;
wire  			VGA_HS;      
wire  			VGA_VS;
wire  	[23:0]  VGA_RGB;
lcd_driver u_lcd_driver
(
    //global clock
    .clk                (clk_pixel),        
    .rst_n              (sys_rst_n), 
     
	 //lcd interface
	.lcd_dclk			(),
	.lcd_blank			(),
	.lcd_sync			(),		    	
	.lcd_hs				(VGA_HS),		
	.lcd_vs				(VGA_VS),
	.lcd_en				(VGA_DE),		
	.lcd_rgb			(VGA_RGB),

    
    //user interface
    .lcd_request        (sys_rd_out),
    .lcd_data           (sys_data_out[31:8]),    
    .lcd_xpos           (),    
    .lcd_ypos           ()
);

//-----------------------------------
//HDMI TX Module
hdmi_tx #(.FAMILY("EG4"))	//EF2、EF3、EG4、AL3、PH1
u3_hdmi_tx
(
	.PXLCLK_I	        (clk_pixel),
	.PXLCLK_5X_I        (clk_pixel_5x),
	.RST_N 		        (~sys_rst_n),
        
	//VGA   
	.VGA_HS             (VGA_HS ),
	.VGA_VS             (VGA_VS ),
	.VGA_DE             (VGA_DE ),
	.VGA_RGB            (VGA_RGB),
    
	//HDMI  
	.HDMI_CLK_P         (HDMI_CLK_P),
	.HDMI_D2_P          (HDMI_D2_P ),
	.HDMI_D1_P          (HDMI_D1_P ),
	.HDMI_D0_P          (HDMI_D0_P )	
);

endmodule