`timescale 1ns/1ns
module lcd_driver
(  	
	//global clock
	input			clk,			//system clock
	input			rst_n,     		//sync reset
	
	//lcd interface
	output			lcd_dclk,   	//lcd pixel clock
	output			lcd_blank,		//lcd blank
	output			lcd_sync,		//lcd sync

	//user interface
	output			lcd_request,	//lcd data request
	output	[11:0]	lcd_xpos,		//lcd horizontal coordinate
	output	[11:0]	lcd_ypos,		//lcd vertical coordinate
	input	[23:0]	lcd_data,		//lcd data

	//HDMI out pin
	output			HDMI_CLK_P,
	output			HDMI_D2_P,
	output			HDMI_D1_P,
	output			HDMI_D0_P
);	   
`define	H_FRONT	12'd160
`define	H_SYNC 	12'd20  
`define	H_BACK 	12'd140  
`define	H_DISP 	12'd1024
`define	H_TOTAL	12'd1344
				
`define	V_FRONT	12'd12
`define	V_SYNC 	12'd3 
`define	V_BACK 	12'd20  
`define	V_DISP 	12'd600  
`define	V_TOTAL	12'd635

wire			lcd_hs;	    	//lcd horizontal sync
wire			lcd_vs;	    	//lcd vertical sync
wire			lcd_en;			//lcd display enable
wire	[23:0]	lcd_rgb;		//lcd display data

/*******************************************
		SYNC--BACK--DISP--FRONT
*******************************************/
//------------------------------------------
//h_sync counter & generator
reg [11:0] hcnt; 
always @ (posedge clk or negedge rst_n)
begin
	if (!rst_n)
		hcnt <= 12'd0;
	else
		begin
        if(hcnt < `H_TOTAL - 1'b1)		//line over			
            hcnt <= hcnt + 1'b1;
        else
            hcnt <= 12'd0;
		end
end 
assign	lcd_hs = (hcnt <= `H_SYNC - 1'b1) ? 1'b0 : 1'b1;

//------------------------------------------
//v_sync counter & generator
reg [11:0] vcnt;
always@(posedge clk or negedge rst_n)
begin
	if (!rst_n)
		vcnt <= 12'b0;
	else if(hcnt == `H_TOTAL - 1'b1)		//line over
		begin
		if(vcnt < `V_TOTAL - 1'b1)		//frame over
			vcnt <= vcnt + 1'b1;
		else
			vcnt <= 12'd0;
		end
end
assign	lcd_vs = (vcnt <= `V_SYNC - 1'b1) ? 1'b0 : 1'b1;

//------------------------------------------
//LCELL	LCELL(.in(clk),.out(lcd_dclk));
assign	lcd_dclk = ~clk;
assign	lcd_blank = lcd_hs & lcd_vs;		
assign	lcd_sync = 1'b0;


//-----------------------------------------
assign	lcd_en		=	(hcnt >= `H_SYNC + `H_BACK  && hcnt < `H_SYNC + `H_BACK + `H_DISP) &&
						(vcnt >= `V_SYNC + `V_BACK  && vcnt < `V_SYNC + `V_BACK + `V_DISP) 
						? 1'b1 : 1'b0;
assign	lcd_rgb 	= 	lcd_en ? lcd_data : 24'h000000;	//ffffff;



//------------------------------------------
//ahead x clock
localparam	H_AHEAD = 	12'd1;
assign	lcd_request	=	(hcnt >= `H_SYNC + `H_BACK - H_AHEAD && hcnt < `H_SYNC + `H_BACK + `H_DISP - H_AHEAD) &&
						(vcnt >= `V_SYNC + `V_BACK && vcnt < `V_SYNC + `V_BACK + `V_DISP) 
						? 1'b1 : 1'b0;
//lcd xpos & ypos
assign	lcd_xpos	= 	lcd_request ? (hcnt - (`H_SYNC + `H_BACK - H_AHEAD)) : 12'd0;
assign	lcd_ypos	= 	lcd_request ? (vcnt - (`V_SYNC + `V_BACK)) : 12'd0;

//-----------------------------------
//HDMI TX Module

wire  			VGA_DE;
wire  			VGA_HS;      
wire  			VGA_VS;
wire  	[23:0]  VGA_RGB;

assign VGA_HS = lcd_hs;
assign VGA_VS = lcd_vs;
assign VGA_DE = lcd_en;
assign VGA_RGB = lcd_rgb;
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
