`timescale 1ns/1ns

`include "../sdram_global_def.v"

module lcd_display
#(
	parameter	[27:0]	DELAY_TOP = 73_333333
)
(
	input	 			clk,		//system clock
	input				rst_n,		//sync clock
	
	input		[11:0]	lcd_xpos,	//lcd horizontal coordinate
	input		[11:0]	lcd_ypos,	//lcd vertical coordinate
	output	reg	[23:0]	lcd_data,	//lcd data
    output 	    				    App_rd_en,
    output   [`ADDR_WIDTH-1:0]	    App_rd_addr,
    input 	    				    Sdr_rd_en,
    input    [`DATA_WIDTH-1:0]	    Sdr_rd_dout
);

`include "lcd_para.v" 
`define	VGA_HORIZONTAL_COLOR
`define	VGA_VERICAL_COLOR
`define	VGA_GRAY_GRAPH
`define	VGA_GRAFTAL_GRAPH


//-------------------------------------------
`ifdef VGA_HORIZONTAL_COLOR
reg	[23:0]	lcd_data0;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data0 <= 0;
	else
		begin
		if	(lcd_ypos >= 0 && lcd_ypos < (`V_DISP/8)*1)
			lcd_data0 <= `RED;
		else if(lcd_ypos >= (`V_DISP/8)*1 && lcd_ypos < (`V_DISP/8)*2)
			lcd_data0 <= `GREEN;
		else if(lcd_ypos >= (`V_DISP/8)*2 && lcd_ypos < (`V_DISP/8)*3)
			lcd_data0 <= `BLUE;
		else if(lcd_ypos >= (`V_DISP/8)*3 && lcd_ypos < (`V_DISP/8)*4)
			lcd_data0 <= `WHITE;
		else if(lcd_ypos >= (`V_DISP/8)*4 && lcd_ypos < (`V_DISP/8)*5)
			lcd_data0 <= `BLACK;
		else if(lcd_ypos >= (`V_DISP/8)*5 && lcd_ypos < (`V_DISP/8)*6)
			lcd_data0 <= `YELLOW;
		else if(lcd_ypos >= (`V_DISP/8)*6 && lcd_ypos < (`V_DISP/8)*7)
			lcd_data0 <= `CYAN;
		else// if(lcd_ypos >= (`V_DISP/8)*7 && lcd_ypos < (`V_DISP/8)*8)
			lcd_data0 <= `ROYAL;
		end
end
`endif

//-------------------------------------------
`ifdef VGA_VERICAL_COLOR
reg	[23:0]	lcd_data1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data1 <= 0;
	else
		begin
		if	(lcd_xpos >= 0 && lcd_xpos < (`H_DISP/8)*1)
			lcd_data1 <= `RED;
		else if(lcd_xpos >= (`H_DISP/8)*1 && lcd_xpos < (`H_DISP/8)*2)
			lcd_data1 <= `GREEN;
		else if(lcd_xpos >= (`H_DISP/8)*2 && lcd_xpos < (`H_DISP/8)*3)
			lcd_data1 <= `BLUE;
		else if(lcd_xpos >= (`H_DISP/8)*3 && lcd_xpos < (`H_DISP/8)*4)
			lcd_data1 <= `WHITE;
		else if(lcd_xpos >= (`H_DISP/8)*4 && lcd_xpos < (`H_DISP/8)*5)
			lcd_data1 <= `BLACK;
		else if(lcd_xpos >= (`H_DISP/8)*5 && lcd_xpos < (`H_DISP/8)*6)
			lcd_data1 <= `YELLOW;
		else if(lcd_xpos >= (`H_DISP/8)*6 && lcd_xpos < (`H_DISP/8)*7)
			lcd_data1 <= `CYAN;
		else// if(lcd_xpos >= (`H_DISP/8)*7 && lcd_xpos < (`H_DISP/8)*8)
			lcd_data1 <= `ROYAL;
		end
end
`endif

	
//-------------------------------------------
`ifdef VGA_GRAFTAL_GRAPH
reg	[23:0]	lcd_data2;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data2 <= 0;
	else
		lcd_data2 <= lcd_xpos * lcd_ypos;
end
`endif

//-------------------------------------------
`ifdef VGA_GRAY_GRAPH
reg	[23:0]	lcd_data3;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data3 <= 0;
	else
		begin
		if(lcd_ypos < `V_DISP/2)
			lcd_data3 <= {lcd_ypos[7:0], lcd_ypos[7:0], lcd_ypos[7:0]};
		else
			lcd_data3 <= {lcd_xpos[7:0], lcd_xpos[7:0], lcd_xpos[7:0]};
		end
end
`endif

//-------------------------------------------
//DATA FROM RAM

reg	[13:0]	tx_cnt;

always @(posedge clk)
begin
	if(rst_n)
		tx_cnt <= 'd0;
	else
		tx_cnt <= tx_cnt+1'b1;
end

reg	[23:0]	lcd_ram_data;
reg 	    				App_rd_en_reg;
reg [`ADDR_WIDTH-1:0]	    App_rd_addr_reg;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_ram_data <= 0;
	else
    begin		
        if(tx_cnt[12:11]==2'b11)
        begin
            App_rd_en_reg <= 1;
            App_rd_addr_reg <= lcd_xpos + 1024 * lcd_ypos;   //或许要更换为宏定义？
        end
		else
        begin
            App_rd_en_reg <= 0;
            App_rd_addr_reg <= lcd_xpos + 1024 * lcd_ypos;   //或许要更换为宏定义？
        end
        lcd_ram_data <= `RED;
        if(Sdr_rd_en == 1)
            lcd_ram_data <= `BLUE;
            // lcd_ram_data <= Sdr_rd_dout[23:0];
    end
end
assign App_rd_en    =   App_rd_en_reg;
assign APP_rd_addr  =   App_rd_addr_reg;

//------------------------------------
//0.5S Delay
reg [27:0]	delay_cnt;
//localparam	DELAT_TOP 50_000000/2
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		delay_cnt <= 0;
	else
		delay_cnt <= (delay_cnt < DELAY_TOP - 1'b1) ? delay_cnt + 1'b1 : 28'd0;
end
wire	delay_0S5_flag = (delay_cnt == DELAY_TOP - 1'b1) ? 1'b1 : 1'b0;

//------------------------------------
//4 picture cycle cnt
reg	[1:0]	image_cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		image_cnt <= 0;
	else if(delay_0S5_flag)
		image_cnt <= image_cnt + 1'b1;
	else
		image_cnt <= image_cnt;
end

// ------------------------------------
// 4 picture cycle
always@(*)
begin
	case(image_cnt)
	0:	lcd_data <= lcd_data0;
	1:	lcd_data <= lcd_data1;
	2:	lcd_data <= lcd_ram_data;
	3:	lcd_data <= lcd_data3;
	endcase
end

// always@(posedge Sdr_rd_en)
// begin
//     lcd_data <= lcd_ram_data;
// end

endmodule
