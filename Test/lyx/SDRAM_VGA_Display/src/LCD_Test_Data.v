`timescale 1 ns / 1 ns
module LCD_Test_Data
#(
    parameter           H_DISP = 12'd640,
    parameter           V_DISP = 12'd480
)
(
    input               clk,            //globan clock    
    input               rst_n,          //Global reset    
    input               sys_vaild,      //the device is ready
    input       [7:0]   DIVIDE_PARAM,   //0-255
    
    //sys 2 sdram control
    output  reg         sys_load,
    output  reg [23:0]  sys_data,
    output              sys_we,
    output  reg [31:0]  sys_addr
);

localparam      DISP_DELAY_CNT    =    28'hFFFFFFF;    //30MHZ- 2.237S

//Define the color parameter RGB--8|8|8
//----------------------------------------------------------------
localparam  RED     =   24'hFF0000;   /*11111111,00000000,00000000*/
localparam  GREEN   =   24'h00FF00;   /*00000000,11111111,00000000*/
localparam  BLUE    =   24'h0000FF;   /*00000000,00000000,11111111*/
localparam  WHITE   =   24'hFFFFFF;   /*11111111,11111111,11111111*/
localparam  BLACK   =   24'h000000;   /*00000000,00000000,00000000*/
localparam  YELLOW  =   24'hFFFF00;   /*11111111,11111111,00000000*/
localparam  CYAN    =   24'hFF00FF;   /*11111111,00000000,11111111*/
localparam  ROYAL   =   24'h00FFFF;   /*00000000,11111111,11111111*/ 

//----------------------------------------------------------------
localparam      H_TOTAL = H_DISP + 11'd16;
localparam      V_TOTAL = V_DISP + 11'd1;


//-------------------------------------
//Divide for data write clock
reg    [7:0]    cnt;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt <= 0;
    else if(DIVIDE_PARAM == 8'd0)
        cnt <= 0;
    else 
        cnt <= (cnt < DIVIDE_PARAM) ? cnt + 1'b1 : 8'd0;
end
wire    write_flag  =   (cnt == 0) ? 1'b1 : 1'b0;
wire    write_en    =   (DIVIDE_PARAM <= 0) ? 1'b1 : 
                        (DIVIDE_PARAM <= 1) ? ((cnt == 1) ? 1'b1 : 1'b0) :
                        (cnt == (DIVIDE_PARAM + 1'b1)/2) ? 1'b1 : 1'b0;


//---------------------------------------
reg    [10:0]   lcd_xpos;
reg    [10:0]   lcd_ypos;
reg             sys_hs;
reg    [10:0]   px_cnt;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        lcd_xpos <= 11'd0;
        lcd_ypos <= 11'd0;
        sys_load <= 1'b0;
        sys_data <= 0;
        sys_hs <= 0;
        sys_addr <= 0;
    end
    else if(sys_vaild & write_flag)
    begin
        sys_hs <= (lcd_xpos <= H_DISP - 1'b1 && lcd_ypos <= V_DISP - 1'b1) ? 1'b1 : 1'b0;
        // sys_load <= 1'b0;

        if(lcd_xpos < H_TOTAL - 1'b1)
            lcd_xpos <= lcd_xpos + 1'b1;
        else
        begin
            lcd_xpos <= 11'd0;
            if(lcd_ypos < 256 - 1'b1 && lcd_ypos > 128)
                lcd_ypos <= lcd_ypos + 1'b1;
            else
            begin
                lcd_ypos <= 11'd0;
                // sys_load <= 1'b1;
            end
        end

        if(lcd_xpos <= H_DISP - 1'b1 && lcd_ypos <= V_DISP - 1'b1)
        begin
            sys_data <= `RED;
            // sys_data[7:0] <= lcd_xpos[7:0] + lcd_ypos[7:0];
            // sys_data[15:8] <=  lcd_xpos[7:0];
            // sys_data[23:16] <= lcd_ypos[7:0];
        end
        else
            sys_data <= 0;
    end
end
assign  sys_we = sys_hs & write_en;

endmodule
