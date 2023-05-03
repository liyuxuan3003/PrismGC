`include "lcd_24bit_ip/lcd_para.v"

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

    input[31:0]     pingAddr,
    input[31:0]     pongAddr,

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
    // .WR_MIN_ADDR        (pongAddr + sys_addr_min),     //write start address
    // .WR_MAX_ADDR        (pongAddr + sys_addr_max),     //write max address
    .WR_LENGTH          (sys_wr_len),       //write burst length

    //    FIFO Read Side
    .RD_CLK             (clk_read),         //read fifo clock
    // .RD_LOAD            (1'b0),             //read register load & fifo clear
    //.RD_LOAD            (CounterX == `H_TOTAL-1 && CounterY == `V_TOTAL-1),//read register load & fifo clear
    .RD_LOAD            (sys_rload),
    .RD_DATA            (sys_data_out),     //read data output
    .RD                 (sys_rd_out),       //read request
    .RD_MIN_ADDR        (0),         //read start address
    .RD_MAX_ADDR        (`H_DISP * `V_DISP),//read max address
    // .RD_MIN_ADDR        (pingAddr),         //read start address
    // .RD_MAX_ADDR        (pingAddr + `H_DISP * `V_DISP),//read max address
    .RD_LENGTH          (9'd256),           //read length
    
    //User interface add by CrazyBingo
    .Sdram_Init_Done    (sdram_init_done),  //SDRAM init done signal
    .Sdram_Read_Valid   (1'b1),             //Enable to read
    .Sdram_PingPong_EN  (1'b0)              //SDRAM PING-PONG operation enable
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
/*
localparam  H_DISP = 12'd1024;  
localparam	V_DISP = 12'd600; 
assign sys_vaild = sdram_init_done;

always @(negedge rst_n)
begin
	pingAddr <= 0;
	pongAddr <= 0;
end

reg[1:0]  wrState;
reg[4:0]  wrDiv;
reg[23:0] wrCount;
reg sysForceWriteReg;
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
	begin
        wrState <= 0;
		wrCount <= 0;
		wrDiv <= 0;
	end
    else
    begin
        case (wrState)
            0: wrState <= enable ? 1:0;
            1: begin
                sys_waddr_min <= pingAddr + x_pos + y_pos * H_DISP;
                sys_waddr_max <= pingAddr + H_DISP * (V_DISP  + 1);
                sys_wload <= 1'b1;
                wrState <= 2;
                end
            2: begin
                sys_wload <= 1'b0;
                wrCount <= 0;
                wrDiv <= 0;
                wrState <= 3;
                end
            3: begin
                wrDiv <= wrDiv + 1;
                sys_wdata <= pixel;
                if(wrDiv == 0)
                begin
                    wrCount <= wrCount + 1;
                    if(wrCount == len+254)
                        wrState <= 4;
                    //if(wrCount == len)
                    //begin
                    //	wrState <= 4;
                    //	if(len<256)
                    //		sysForceWriteReg <= 1;
                end
                end
            4: begin
                wrState <= enable ? 4:0;
                sysForceWriteReg <= 0;
                end
            default: wrState <= 0;
        endcase
    end
end
assign busy = (wrState==1) | (wrState==2) | (wrState==3);
assign sys_we = (wrDiv==1) & (wrState==3);
assign sys_we_force = sysForceWriteReg;
*/

// //-------------------------------------
// //LCD driver timing
// wire  			VGA_DE;
// wire  			VGA_HS;      
// wire  			VGA_VS;
// wire  	[23:0]  VGA_RGB;
// lcd_driver u_lcd_driver
// (
//     //global clock
//     .clk                (clk_pixel),        
//     .rst_n              (sys_rst_n), 
     
// 	 //lcd interface
// 	.lcd_dclk			(),
// 	.lcd_blank			(),
// 	.lcd_sync			(),		    	
// 	.lcd_hs				(VGA_HS),		
// 	.lcd_vs				(VGA_VS),
// 	.lcd_en				(VGA_DE),		
// 	.lcd_rgb			(VGA_RGB),

    
//     //user interface
//     .lcd_request        (sys_rd_out),
//     .lcd_data           (sys_data_out[31:8]),    
//     .lcd_xpos           (),    
//     .lcd_ypos           ()
// );

// //-----------------------------------
// //HDMI TX Module
// hdmi_tx #(.FAMILY("EG4"))	//EF2、EF3、EG4、AL3、PH1
// u3_hdmi_tx
// (
// 	.PXLCLK_I	        (clk_pixel),
// 	.PXLCLK_5X_I        (clk_pixel_5x),
// 	.RST_N 		        (~sys_rst_n),
        
// 	//VGA   
// 	.VGA_HS             (VGA_HS ),
// 	.VGA_VS             (VGA_VS ),
// 	.VGA_DE             (VGA_DE ),
// 	.VGA_RGB            (VGA_RGB),
    
// 	//HDMI  
// 	.HDMI_CLK_P         (HDMI_CLK_P),
// 	.HDMI_D2_P          (HDMI_D2_P ),
// 	.HDMI_D1_P          (HDMI_D1_P ),
// 	.HDMI_D0_P          (HDMI_D0_P )	
// );

endmodule