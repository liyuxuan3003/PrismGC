module top
(
	input CLK,
    input SWI,
	output HDMI_D0_P,
    output HDMI_D1_P,
    output HDMI_D2_P,
	output HDMI_CLK_P
);

wire clkPixel;
wire clkTMDS;

HDMIEncoder uHDMIEncoder
(
    .clk(clkPixel),
    .clk_TMDS(clkTMDS),
    .HDMI_D0_P(HDMI_D0_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D2_P(HDMI_D2_P),
    .HDMI_CLK_P(HDMI_CLK_P)
);


SystemPLL uSystemPLL
(
    .refclk(CLK),
    .reset(SWI),
    .clk0_out(clkPixel),
    .clk1_out(clkTMDS)
);

endmodule