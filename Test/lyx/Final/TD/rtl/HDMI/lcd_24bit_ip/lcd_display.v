`timescale 1ns/1ns

module lcd_display
#(
    parameter   LCD_STACK_WIDTH = 12,
	parameter	[27:0]	DELAY_TOP = 73_333333
)
(
	input	 			clk,		//system clock
	input				rst_n,		//sync clock
	
	input		[11:0]	lcd_xpos,	//lcd horizontal coordinate
	input		[11:0]	lcd_ypos,	//lcd vertical coordinate
	output	reg	[23:0]	lcd_data, 	//lcd data

    input               LCD_CMD_SIG,
    input       [31:0]  LCD_CMD
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
		else if(lcd_ypos >= (`V_DISP/8)*7 && lcd_ypos < (`V_DISP/8)*8)
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
		else if(lcd_xpos >= (`H_DISP/8)*7 && lcd_xpos < (`H_DISP/8)*8)
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

(* ram_style="block" *)reg[31:0] LCD_STACK[(2**LCD_STACK_WIDTH-1):0];

reg[31:0] LCD_STACK_PT;

always@(LCD_CMD_SIG or negedge rst_n)
begin
    if(!rst_n)
        LCD_STACK_PT <= 0;
    else
    begin
        LCD_STACK[LCD_STACK_PT] <= LCD_CMD;
        LCD_STACK_PT <= LCD_STACK_PT + 1;
    end
end 

reg[23:0] lcd_data_cmd;
integer i;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data_cmd <= 0;
	else if (LCD_STACK_PT == 0)
        lcd_data_cmd <= 0;
    else
    begin
        for(i=1; i>=0; i=i-1) 
        begin
            if(LCD_STACK[i][31:24] == 8'hFF && i<=LCD_STACK_PT-1)
            begin
                case (LCD_STACK[i][15:8])
                    //绘制像素
                    8'h00:
                    begin
                        if (lcd_xpos==LCD_STACK[i+1][31:16] && lcd_ypos==LCD_STACK[i+1][15:0])
                        begin
                            lcd_data_cmd <= LCD_STACK[i+2][23:0];
                        end
                    end
                    //绘制线条
                    8'h01:
                    begin
                        //
                    end
                    //绘制方块
                    8'h02:
                    begin
                        if (lcd_xpos>=LCD_STACK[i+1][31:16] && 
                            lcd_ypos>=LCD_STACK[i+1][15:0]  &&
                            lcd_xpos<=LCD_STACK[i+2][31:16] && 
                            lcd_ypos<=LCD_STACK[i+2][15:0] )
                        begin
                            lcd_data_cmd <= LCD_STACK[i+3][23:0];
                        end
                    end
                endcase
            end
        end
    end
end


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
    lcd_data<=lcd_data_cmd;
	// case(LCD_CMD[1:0])
	// 0:	lcd_data <= lcd_data0;
	// 1:	lcd_data <= lcd_data1;
	// 2:	lcd_data <= lcd_data2;
	// 3:	lcd_data <= lcd_data3;
	// endcase
end

endmodule
