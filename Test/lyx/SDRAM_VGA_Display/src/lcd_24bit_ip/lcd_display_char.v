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
Filename                :       lcd_display_char.v
Data                    :       2012-02-18
Description             :       LCD/VGA display for char.
Modification History    :
Data            Author          Version     Change Description
=========================================================================
12/02/18        CrazyBingo      1.0         Original
12/03/19        CrazyBingo      1.1         Modification
12/03/21        CrazyBingo      1.2         Modification
12/05/13        CrazyBingo      1.3         Modification
13/11/07        CrazyBingo      2.1         Modification
17/04/21        CrazyBingo      2.2         Modify file name
-------------------------------------------------------------------------
|                                     Oooo                              |
+------------------------------oooO--(   )------------------------------+
                              (   )   ) /
                               \ (   (_/
                                \_)
-----------------------------------------------------------------------*/

`timescale 1ns/1ns
module lcd_display_char
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
`define     LCD_COLOR_DEFAULT   `YELLOW
`define     LCD_ADDR_AHEAD      9'd2    //lcd address ahead, it is very important


//--------------------------------------------------------------
/****************************************************************
            Display : "Hello World*^_^*", 32*16 = 512 (Char: 32 * 64)
****************************************************************/
wire    vip_area1 = (lcd_xpos >= 64 && lcd_xpos < 576) && (lcd_ypos >= 128 && lcd_ypos < 192); 
wire    [63:0]  vip_data1;                            
wire    [8:0]   ip_addr1 = lcd_xpos[8:0] - (9'd64 - `LCD_ADDR_AHEAD);    //32*16 = 512
vip_rom1    u_vip_rom1 
(
    .clock              (clk),
    .address            (vip_addr1),
    .q                  (vip_data1)
);


//--------------------------------------------------------------
/****************************************************************
            Display : "I am CrazyBingo!", 32*16 = 512 (Char: 32 * 64)
****************************************************************/
wire    vip_area2 = (lcd_xpos >= 64 && lcd_xpos < 576) && (lcd_ypos >= 256 && lcd_ypos < 320);  
wire    [63:0]  vip_data2;                            
wire    [8:0]   vip_addr2 = lcd_xpos[8:0] - (9'd64 - `LCD_ADDR_AHEAD);    //32*16 = 512
vip_rom2    u_vip_rom2 
(
    .clock              (clk),
    .address            (vip_addr2),
    .q                  (vip_data2)
);


//--------------------------------------------------------------
//LCD char display with rom input
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        lcd_data <= 0;
    else
        begin
        //Display : "Hello World*^_^*"    
        if(vip_area1 == 1'b1)    
            if(vip_data1[6'd63-lcd_ypos[5:0]] == 1'b1)  lcd_data <= `BLUE;
            else                                        lcd_data <= `LCD_COLOR_DEFAULT;
        //Display : "I am CrazyBingo!"
        else if    (vip_area2 == 1'b1)        
            if(vip_data2[6'd63-lcd_ypos[5:0]] == 1'b1)  lcd_data <= `BLUE;
            else                                        lcd_data <= `LCD_COLOR_DEFAULT;
            
        //Display : WHITE AREA                
        else                                            lcd_data <= `LCD_COLOR_DEFAULT;
        end
end



endmodule
