`timescale 1ns/1ns
module lcd_display
#(
	parameter	[27:0]	DELAY_TOP = 74_250000
)
(
	input	 			clk,		//system clock
	input				rst_n,		//sync clock
	input		[7:0]	Displaymode,
    input		[31:0]	Displaycontent, 
	input		[11:0]	lcd_xpos,	//lcd horizontal coordinate
	input		[11:0]	lcd_ypos,	//lcd vertical coordinate
	output	reg	[23:0]	lcd_data	//lcd data
);
`include "lcd_para.v" 
`define	NOTE


//音符
integer i;
//integer pixel_left;
//integer pixel_right;
reg	[25:0] note [0:15];
always@(Displaycontent or negedge rst_n)
	begin
    if(!rst_n)
    	begin
        for(i=0;i<=15;i=i+1)
            	begin
            	note[i] <= 28'b0;
                end
        end
	note[Displaycontent[31:26]][25:0] <= Displaycontent[25:0];
	end
reg [0:15] in_bar_black;
reg [0:15] in_bar_red;
always @(*)
	begin
    for(i=0;i<=15;i=i+1)
    		begin
            case(note[i][25:24])
            //pixel_left = key*320+(720-lcd_ypos)/5;
            //pixel_right = key*320+320+(720-lcd_ypos)/10;
            //pixel_left = key*320;
            //pixel_right = pixel_left+320;
          	2'b00:in_bar_black[i] <= ((lcd_xpos>note[i][23:12])&(lcd_xpos<note[i][11:0])&(lcd_ypos>180)&(lcd_ypos<360));
            2'b01:in_bar_red[i] <= ((lcd_xpos>note[i][23:12])&(lcd_xpos<note[i][11:0])&(lcd_ypos>180)&(lcd_ypos<360));
            2'b10:in_bar_black[i] <= ((lcd_xpos>note[i][23:12])&(lcd_xpos<note[i][11:0])&(lcd_ypos>360)&(lcd_ypos<540));
            2'b11:in_bar_red[i] <= ((lcd_xpos>note[i][23:12])&(lcd_xpos<note[i][11:0])&(lcd_ypos>360)&(lcd_ypos<540));
            endcase
          	end
	end

//-------------------------------------------
`ifdef NOTE
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data <= 0;
	else
		begin
       	if(in_bar_black) 
        	begin
			lcd_data <= `BLACK;
      		end
       	else if(in_bar_red) 
        	begin
			lcd_data <= `RED;
      		end   
        else
        	begin
            lcd_data <= `WHITE;
        	end
		end
end
`endif





endmodule
