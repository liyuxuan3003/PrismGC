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
    output  reg [23:0]  sys_data,
    output              sys_we
);
//`define    IMAGE_STEADY_MODE            //Steady Image mode
`define    IMAGE_DYNAMIC_MODE           //Dynamic Image mode
//`define    IMAGE_SIGNAL_MODE            //Signal Image mode
`define    IMAGE_REPEAT_MODE            //Multiple Image mode

localparam      DISP_DELAY_CNT    =    28'hFFFFFFF;    //30MHZ- 2.237S
//localparam    DISP_DELAY_CNT    =    28'hFFFFFFF;    //150MHZ- 1.78S
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
//delay for 1s for next image
//localparam    DISP_DELAY_CNT    =    28'hFFFFFFF;
reg     [1:0]   img_state;
reg     [27:0]  disp_cnt;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        disp_cnt <= 0;
    else if(img_state == 2'd2)
        if(disp_cnt < DISP_DELAY_CNT)    //500us
            disp_cnt <= disp_cnt + 1'b1;
        else
            disp_cnt <= disp_cnt;
    else
        disp_cnt <= 0;
end
wire    display_done = (disp_cnt == DISP_DELAY_CNT) ? 1'b1 : 1'b0;


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
reg    [1:0]    img_cnt;
//reg    [1:0]    img_state;
reg    [10:0]   lcd_xpos;
reg    [10:0]   lcd_ypos;
reg             sys_hs;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        lcd_xpos <= 0;
        lcd_ypos <= 0;
        sys_data <= 0;
        sys_hs <= 0;
        img_cnt <= 0;
        img_state <= 0;
    end
    else if(sys_vaild & write_flag)
    begin
        case(img_state)
            2'd0:    
            begin
                img_cnt <= 0;
                lcd_xpos <= 0;
                lcd_ypos <= 0;
                sys_data <= 0;
                sys_hs <= 0;
                img_state <= 2'd1;
            end
            2'd1:    
            begin
                sys_hs <= (lcd_xpos <= H_DISP - 1'b1 && lcd_ypos <= V_DISP - 1'b1) ? 1'b1 : 1'b0;
                if(lcd_xpos == H_TOTAL - 1'b1 && lcd_ypos == V_TOTAL - 1'b1)
                    img_state <= 2'd2;
                else
                    img_state <= 2'd1;    
    
                if(lcd_xpos < H_TOTAL - 1'b1)
                    lcd_xpos <= lcd_xpos + 1'b1;
                else
                    lcd_xpos <= 11'd0;
                    
                if(lcd_xpos == H_TOTAL - 1'b1)
                begin
                    if(lcd_ypos < V_TOTAL - 1'b1)
                        lcd_ypos <= lcd_ypos + 1'b1;
                    else
                        lcd_ypos <= 11'd0;
                end
                else
                    lcd_ypos <= lcd_ypos;

                if(lcd_xpos <= H_DISP - 1'b1 && lcd_ypos <= V_DISP - 1'b1)
                begin
                    case(img_cnt)
                        2'd0:    sys_data <=
                        (lcd_xpos >= 100 && lcd_xpos < 200 && lcd_ypos >= 100 && lcd_ypos < 200) ?
                        RED : WHITE;
                        2'd1:    sys_data <=
                        (lcd_xpos >= 200 && lcd_xpos < 300 && lcd_ypos >= 200 && lcd_ypos < 300) ?
                        RED : WHITE;
                        2'd2:    sys_data <=
                        (lcd_xpos >= 300 && lcd_xpos < 400 && lcd_ypos >= 300 && lcd_ypos < 400) ?
                        RED : WHITE;
                        2'd3:    sys_data <=
                        (lcd_xpos >= 400 && lcd_xpos < 500 && lcd_ypos >= 400 && lcd_ypos < 500) ?
                        RED : WHITE;
                    endcase
                end
                else
                    sys_data <= 0;
            end
            2'd2:    
            begin
                sys_hs <= 0;
                lcd_xpos <= 0;
                lcd_ypos <= 0;
                sys_data <= 0;
                if(display_done)
                begin
                    `ifdef    IMAGE_STEADY_MODE     //Steady Image
                    img_cnt <= img_cnt;             //2'd0            
                    `endif
                    `ifdef    IMAGE_DYNAMIC_MODE    //Move Image
                    img_cnt <= img_cnt + 1'b1;    
                    `endif
                    img_state <= 2'd3;
                end
                else
                begin
                    img_cnt <= img_cnt;            
                    img_state <= 2'd2;
                end
            end
            2'd3:    
            begin
                `ifdef    IMAGE_SIGNAL_MODE        //Signal Image write
                img_state <= 2'd3;                    
                `endif
                `ifdef    IMAGE_REPEAT_MODE         //Multiple Image write
                img_state <= 2'd1;
                `endif
            end
        endcase
    end
end
assign    sys_we = sys_hs & write_en;

endmodule
