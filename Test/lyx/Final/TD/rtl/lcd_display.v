`include "lcd_para.v" 

`timescale 1ns/1ns
module lcd_display
#(
	parameter	[27:0]	DELAY_TOP = 74_250000
)
(
	input	 			clk,		//system clock
	input				rst_n,		//sync clock
    input		[31:0]	HDMI_DATA,  //HDMI DATA
	input		[11:0]	lcd_xpos,	//lcd horizontal coordinate
	input		[11:0]	lcd_ypos,	//lcd vertical coordinate
	output	reg	[23:0]	lcd_data	//lcd data
);

//-------------------------------------------
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data <= 0;
	else
		lcd_data <= `RED;
end

endmodule
