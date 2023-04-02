/*-----------------------------------------------------------------------
                                 \\\|///
                               \\  - -  //
                                (  @ @  )
+-----------------------------oOOo-(_)-oOOo-----------------------------+
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo (Thereturnofbingo).
In the event of publication, the following notice is applicable:
Copyright (C) 2012-20xx CrazyBingo Corporation.
The entire notice above must be reproduced on all authorized copies.
Author                  :       CrazyBingo
Official Websites       :       http://www.crazyfpga.com
Email Address           :       crazyfpga@qq.com
Filename                :       lcd_display.v
Data                    :       2012-02-18
Description             :       LCD/VGA display simulation.
Modification History    :
Data            Author          Version     Change Description
=========================================================================
12/02/18        CrazyBingo      1.0         Original
12/03/19        CrazyBingo      1.1         Modification
12/03/21        CrazyBingo      1.2         Modification
12/05/13        CrazyBingo      1.3         Modification
13/11/07        CrazyBingo      2.1         Modification
17/04/02        CrazyBingo      3.0         Modify for 12bit width logic
-------------------------------------------------------------------------
|                                     Oooo                              |
+------------------------------oooO--(   )------------------------------+
                              (   )   ) /
                               \ (   (_/
                                \_)
-----------------------------------------------------------------------*/

`timescale 1ns/1ns
module lcd_display
(
    //global clock
    input               clk,            //50MHz
    input               rst_n,          //global reset 
    
    //user interface
    input       [11:0]  lcd_xpos,       //lcd horizontal coordinate
    input       [11:0]  lcd_ypos,       //lcd vertical coordinate
    output  reg [23:0]  lcd_data        //lcd data
);
`include "lcd_para.v" 
//`define     VGA_VERTICAL_COLOR
//`define     VGA_HORIZONTAL_COLOR
`define     VGA_GRAFTAL_GRAPH
//`define     VGA_GRAY_GRAPH


//-------------------------------------------
`ifdef VGA_VERTICAL_COLOR
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        lcd_data <= 24'h0;
    else
        begin
        if     (lcd_xpos >= 0 && lcd_xpos < (`H_DISP/8)*1)
            lcd_data <= `RED;
        else if(lcd_xpos >= (`H_DISP/8)*1 && lcd_xpos < (`H_DISP/8)*2)
            lcd_data <= `GREEN;
        else if(lcd_xpos >= (`H_DISP/8)*2 && lcd_xpos < (`H_DISP/8)*3)
            lcd_data <= `BLUE;
        else if(lcd_xpos >= (`H_DISP/8)*3 && lcd_xpos < (`H_DISP/8)*4)
            lcd_data <= `WHITE;
        else if(lcd_xpos >= (`H_DISP/8)*4 && lcd_xpos < (`H_DISP/8)*5)
            lcd_data <= `BLACK;
        else if(lcd_xpos >= (`H_DISP/8)*5 && lcd_xpos < (`H_DISP/8)*6)
            lcd_data <= `YELLOW;
        else if(lcd_xpos >= (`H_DISP/8)*6 && lcd_xpos < (`H_DISP/8)*7)
            lcd_data <= `CYAN;
        else// if(lcd_xpos >= (`H_DISP/8)*7 && lcd_xpos < (`H_DISP/8)*8)
            lcd_data <= `ROYAL;
        end
end
`endif

 //-------------------------------------------
`ifdef VGA_HORIZONTAL_COLOR
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        lcd_data <= 24'h0;
    else
        begin
        if     (lcd_ypos >= 0 && lcd_ypos < (`V_DISP/8)*1)
            lcd_data <= `RED;
        else if(lcd_ypos >= (`V_DISP/8)*1 && lcd_ypos < (`V_DISP/8)*2)
            lcd_data <= `GREEN;
        else if(lcd_ypos >= (`V_DISP/8)*2 && lcd_ypos < (`V_DISP/8)*3)
            lcd_data <= `BLUE;
        else if(lcd_ypos >= (`V_DISP/8)*3 && lcd_ypos < (`V_DISP/8)*4)
            lcd_data <= `WHITE;
        else if(lcd_ypos >= (`V_DISP/8)*4 && lcd_ypos < (`V_DISP/8)*5)
            lcd_data <= `BLACK;
        else if(lcd_ypos >= (`V_DISP/8)*5 && lcd_ypos < (`V_DISP/8)*6)
            lcd_data <= `YELLOW;
        else if(lcd_ypos >= (`V_DISP/8)*6 && lcd_ypos < (`V_DISP/8)*7)
            lcd_data <= `CYAN;
        else// if(lcd_ypos >= (`V_DISP/8)*7 && lcd_ypos < (`V_DISP/8)*8)
            lcd_data <= `ROYAL;
        end
end
`endif

  
//-------------------------------------------
`ifdef VGA_GRAFTAL_GRAPH
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        lcd_data <= 24'h0;
    else
        lcd_data <= lcd_xpos * lcd_ypos;
end
`endif

//-------------------------------------------
`ifdef VGA_GRAY_GRAPH
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        lcd_data <= 24'h0;
    else
        begin
        if(lcd_ypos < `V_DISP/2)
            lcd_data <= {lcd_ypos[7:0], lcd_ypos[7:0], lcd_ypos[7:0]};
        else
            lcd_data <= {lcd_xpos[7:0], lcd_xpos[7:0], lcd_xpos[7:0]};
        end
end
`endif


endmodule
