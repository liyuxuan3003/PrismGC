`timescale 1ns / 1ps
module HDMI_TX_Display
(
    input           clk,
    
    //HDMI
    output			HDMI_CLK_P,
    output			HDMI_D2_P,
    output			HDMI_D1_P,
    output			HDMI_D0_P,

    output[60:1] PI4
);


//----------------------------------
//sync global clock and reset signal
wire	clk_ref;
wire	clk_pixel;
wire    clk_pixel_5x;

wire    clk_sdram;
wire    clk_sdram_sft;

wire	sys_rst_n;
system_ctrl_pll	u_system_ctrl_pll
(
	.clk			(clk),		    //50MHz
	.rst_n			(1'b1),			//global reset

	.sys_rst_n		(sys_rst_n),	//system reset
	.clk_c0			(clk_ref),		//100MHz
	.clk_c1			(clk_pixel),	//1x pixel clock
	.clk_c2			(clk_pixel_5x),	//5x pixel clock
    .clk_c3         (clk_sdram),    //sdram clock
    .clk_c4         (clk_sdram_sft) //sdram shift 180 clock
);
localparam  PIXEL_CLOCK = 74_250000;

assign PI4[5]=clk;
assign PI4[7]=clk_ref;
assign PI4[9]=clk_pixel;
assign PI4[11]=clk_pixel_5x;
	
//-------------------------------------
//LCD driver timing
wire  			VGA_DE;
wire  			VGA_HS;      
wire  			VGA_VS;
wire  	[23:0]  VGA_RGB;
wire	[11:0]	lcd_xpos;		//lcd horizontal coordinate
wire	[11:0]	lcd_ypos;		//lcd vertical coordinate
wire	[23:0]	lcd_data;		//lcd data
lcd_driver u_lcd_driver
(
	//global clock
	.clk			(clk_pixel),		
	.rst_n			(sys_rst_n), 
	 
	 //lcd interface
	.lcd_dclk		(),//(lcd_dclk),
	.lcd_blank		(),//lcd_blank
	.lcd_sync		(),		    	
	.lcd_hs			(VGA_HS),		
	.lcd_vs			(VGA_VS),
	.lcd_en			(VGA_DE),		
	.lcd_rgb		(VGA_RGB),

	
	//user interface
	.lcd_request	(),
	.lcd_data		(lcd_data),	
	.lcd_xpos		(lcd_xpos),	
	.lcd_ypos		(lcd_ypos)
);

//-------------------------------------
//lcd data simulation
lcd_display	
#(
	.DELAY_TOP		(PIXEL_CLOCK)
)
u_lcd_display
(
	//global clock
	.clk			(clk_pixel),		
	.rst_n			(sys_rst_n), 
	
	.lcd_xpos		(lcd_xpos),	
	.lcd_ypos		(lcd_ypos),
	.lcd_data		(lcd_data),

    .App_rd_en(App_rd_en),
    .App_rd_addr(App_rd_addr),
    .Sdr_rd_en(Sdr_rd_en),
    .Sdr_rd_dout(Sdr_rd_dout)
);

//-----------------------------------
//HDMI TX Module
hdmi_tx #(.FAMILY("EG4"))	//EF2、EF3、EG4、AL3、PH1
u3_hdmi_tx
(
	.PXLCLK_I	    (clk_pixel),
	.PXLCLK_5X_I    (clk_pixel_5x),
	.RST_N 		    (~sys_rst_n),
	
	//VGA
	.VGA_HS         (VGA_HS ),
	.VGA_VS         (VGA_VS ),
	.VGA_DE         (VGA_DE ),
	.VGA_RGB        (VGA_RGB),

	//HDMI
	.HDMI_CLK_P     (HDMI_CLK_P),
	.HDMI_D2_P      (HDMI_D2_P ),
	.HDMI_D1_P      (HDMI_D1_P ),
	.HDMI_D0_P      (HDMI_D0_P )	
);

//-----------------------------------
//SDRAM Module

wire 	    				    App_wr_en;
wire   [`ADDR_WIDTH-1:0]	    App_wr_addr;
wire   [`DM_WIDTH-1:0]	        App_wr_dm;
wire   [`DATA_WIDTH-1:0]	    App_wr_din;

wire 	    				    App_rd_en;
wire   [`ADDR_WIDTH-1:0]	    App_rd_addr;
wire 	    				    Sdr_rd_en;
wire   [`DATA_WIDTH-1:0]	    Sdr_rd_dout;

sdram_top u_sdram_top
(
    .SYS_CLK(clk),
    .local_clk(clk_ref),
    .Clk(clk_sdram),
    .Clk_sft(clk_sdram_sft),

    .App_wr_en(App_wr_en),
    .App_wr_addr(App_wr_addr),
    .App_wr_dm(App_wr_dm),
    .App_wr_din(App_wr_din),

    .App_rd_en(App_rd_en),
    .App_rd_addr(App_rd_addr),
    .Sdr_rd_en(Sdr_rd_en),
    .Sdr_rd_dout(Sdr_rd_dout)
);

// /******************************************/

// reg	[2:0]	judge_cnt;
// reg			tx_vld;
// reg	[13:0]	tx_cnt;
// reg			wr_en;
// reg	[`ADDR_WIDTH-1:0]	wr_addr,wr_addr_1d;
// reg	[`DATA_WIDTH-1:0]	wr_din;
// reg						rd_en;
// reg	[`ADDR_WIDTH-1:0]	rd_addr,rd_addr_1d;
	
	
// wire Clk=clk_sdram;
// wire Rst=sys_rst_n;

// always @(posedge Clk)
// begin
// 	if(Rst)
// 		judge_cnt <= 'd0;
// 	else
// 		judge_cnt <= judge_cnt+1'b1;
// end	
	
	
// always @(posedge Clk)
// begin
// 	if(Rst)
// 		tx_vld <= 'd0;
// 	else if(judge_cnt==3'b111)
// 		tx_vld <= 1'b1;
// 	else if(tx_cnt[13])
// 		tx_vld <= 1'b0;
// end

// always @(posedge Clk)
// begin
// 	if(Rst)
// 		tx_cnt <= 'd0;
// 	else if(tx_vld)
// 		tx_cnt <= tx_cnt+1'b1;
// 	else
// 		tx_cnt <= 'd0;
// end



// always @(posedge Clk)
// begin
// 	if(Rst)
// 	begin	
//         wr_en <= 1'b0;
//         wr_addr <= 'd0;
//         wr_din <= 'd0;
        
//         wr_addr_1d <= 'd0;
// 	end
// 	else 
//     begin
//         wr_en <= 1'b1;
//         wr_addr <= wr_addr+1'b1;
//         wr_din <= wr_din+1'b1;
//     end
// 	wr_addr_1d <= wr_addr;
// end
// assign		App_wr_en=wr_en;
// assign  	App_wr_addr=wr_addr_1d;
// assign		App_wr_dm=4'b0000;
// assign		App_wr_din=wr_din;

endmodule
