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
    output  reg [31:0]  sys_addr_min,
    output  reg [31:0]  sys_addr_max
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
reg    [7:0]    status;
reg    [7:0]    cnt_bckg;
// // reg    [7:0]    cnt_line;
// reg    [10:0]   x1_line;
// reg    [10:0]   x2_line;
// reg    [10:0]   y_line;
reg    [23:0]   cnt_after;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        lcd_xpos <= 0;
        lcd_ypos <= H_DISP *1/4;
        sys_load <= 1'b0;
        sys_data <= 0;
        sys_hs <= 0;
        sys_addr_min <= H_DISP * V_DISP *1 / 4;
        sys_addr_max <= H_DISP * V_DISP *3 / 4;
        status <= 8'h01;
        cnt_bckg <= 0;
        // // cnt_line <= 0;
        // x1_line <= 256;
        // x2_line <= 512;
        // y_line  <= 300;
        cnt_after <= 0;
    end
    else if(sys_vaild & write_flag)
    begin
        case (status)
            // 8'b00 :
            // begin
            //     if(cnt_bckg==1)
            //     begin
            //         status<=8'b02;
            //         cnt_line<=8'b00;
            //     end
            //     else if(cnt_line==8)
            //     begin
            //     end
            // end 
            8'h01:
            begin
                sys_hs <= 1'b1;
                sys_load <= 1'b0;
                sys_addr_min <= H_DISP * V_DISP *1 / 4;
                sys_addr_max <= H_DISP * V_DISP *3 / 4;

                if(lcd_xpos < H_DISP - 1'b1)
                    lcd_xpos <= lcd_xpos + 1'b1;
                else
                begin
                    lcd_xpos <= 11'd0;
                    if(lcd_ypos < H_DISP *3 / 4 - 1'b1)
                        lcd_ypos <= lcd_ypos + 1'b1;
                    else
                    begin
                        cnt_bckg <= cnt_bckg +1;
                        // sys_load <= 1'b1;
                        status = 8'hFF;
                        // lcd_xpos <= x1_line;
                        // lcd_ypos <= y_line;
                    end
                end

                // sys_data <= `WHITE;
                sys_data <= lcd_xpos + lcd_ypos;
                // sys_data[15:8] <=  lcd_xpos[7:0];
                // sys_data[23:16] <= lcd_ypos[7:0];
            end
            // 8'h02:
            // begin
            //     sys_hs <= 1'b1;
            //     sys_addr_min <= x1_line + y_line * H_DISP;
            //     sys_addr_max <= V_DISP * H_DISP;

            //     // if(lcd_xpos <= x2_line)
            //     //     lcd_xpos <= lcd_xpos+1;
            //     // else
            //     // begin
            //     //     lcd_xpos <= x1_line;
            //     //     // status=8'hFF;
            //     // end
            //     sys_data <= `RED;
            // end
            8'hFF:
            begin
                sys_hs <= 1'b0;
                sys_load <= 1'b0;
                cnt_after <= cnt_after + 1;
                if (cnt_after[21:0] == 22'h00)
                begin
                    status=8'h01;
                    lcd_xpos <= 0;
                    lcd_ypos <= H_DISP *1 / 4;
                    // lcd_xpos <= 0;
                    // lcd_ypos <= 0;
                end
            end
        endcase
    end
end
assign  sys_we = sys_hs & write_en;

endmodule
