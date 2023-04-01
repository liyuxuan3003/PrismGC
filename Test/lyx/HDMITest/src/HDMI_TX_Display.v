//-------------------------------
//modukle   :   hdmi_tx_display
//data      :   2022-03-15
//author    :   CrazyBingo

`timescale 1ns / 1ps
module HDMI_TX_Display
(
		input           clk_24m,
		
		//HDMI
		output			HDMI_CLK_P,
		output			HDMI_D2_P,
		output			HDMI_D1_P,
		output			HDMI_D0_P,

        output[60:1] PI4
);

// clk_div
// (
//     .clk(clk),
//     .clk_24m(clk_24m)
// );


//----------------------------------
//sync global clock and reset signal
wire	clk_ref;
wire	clk_pixel, clk_pixel_5x;
wire	sys_rst_n;
system_ctrl_pll	u_system_ctrl_pll
(
	.clk			(clk_24m),		//24MHz
	.rst_n			(1'b1),			//global reset

	.sys_rst_n		(sys_rst_n),	//system reset
	.clk_c0			(clk_ref),		//100MHz
	.clk_c1			(clk_pixel),	//1x pixel clock
	.clk_c2			(clk_pixel_5x)	//5x pixel clock
);
localparam  PIXEL_CLOCK = 74_250000;

assign PI4[5]=clk_24m;
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
	.lcd_data		(lcd_data)
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
    
endmodule

// module clk_div
// (
//     input clk,
//     output clk_24m
// );

// reg clk_24m_reg;

// always @(posedge clk) 
// begin
//     clk_24m_reg=~clk_24m_reg;
// end

// assign clk_24m=clk_24m_reg;

// endmodule
