`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: anlgoic
// Author: 	xg 
//////////////////////////////////////////////////////////////////////////////////

module hdmi_tx_display
(
    input           FPGA_SYS_50M_CLK_P,

    //HDMI
    output			HDMI_CLK_P,
    output			HDMI_D2_P,
    output			HDMI_D1_P,
    output			HDMI_D0_P,
            
    //VGA
    output			VGA_HS,
    output			VGA_VS,
    output [4:0]	VGA_R,		
    output [5:0]	VGA_G,		
    output [4:0]	VGA_B,

    input [31:0]    HDMI_DATA		
);
	
wire clk25m,pxlclk_5x_i;
wire pxlclk_i,locked;
	

wire 	reset;
assign  reset = 1'b0;

reg	[7:0]	rst_cnt=0;	
always @(posedge FPGA_SYS_50M_CLK_P)
begin
	if (rst_cnt[7])
		rst_cnt <=  rst_cnt;
	else
		rst_cnt <=  rst_cnt+1'b1;
end

tx_pll inst
(
    .refclk(FPGA_SYS_50M_CLK_P),
    .reset(!rst_cnt[7]),
    .extlock(locked),
    .clk0_out(clk25m),
    .clk1_out(pxlclk_i),
    .clk2_out(pxlclk_5x_i)
);
	
hdmi_top ux_hdmi
(   
	.PXLCLK_I	(pxlclk_i),
	.PXLCLK_5X_I(pxlclk_5x_i),
	.RST_I		(reset),
	.DEN_TPG	(1'b1 ),
	.TPG_mode	(HDMI_DATA[3:0]),
	.HDMI_CLK_P	(HDMI_CLK_P	),
	.HDMI_D2_P	(HDMI_D2_P	),
	.HDMI_D1_P	(HDMI_D1_P	),
	.HDMI_D0_P	(HDMI_D0_P	),	
	.VGA_HS     (VGA_HS),
	.VGA_VS	    (VGA_VS),
	.VGA_R		(VGA_R),
    .VGA_G	    (VGA_G),
    .VGA_B      (VGA_B)	
);		

	
endmodule
