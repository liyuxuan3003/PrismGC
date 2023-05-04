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

reg [7:0] cnt;
always @(posedge clk or negedge rst_n)
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

//cnt           0 1 0 1 0 1
//write flag    1 0 1 0 1 0
//write en      0 1 0 1 0 1


reg [23:0] cnt_display;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_display <= 0;
    else
        cnt_display <= cnt_display + 1;
end

reg [2:0]   status;
reg [23:0]  pos;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        sys_addr_min <= 0;
        sys_addr_max <= H_DISP * V_DISP;
        sys_load <= 1'b1;
        status <= 0;
        pos <= 0;
    end
    else if (sys_vaild & write_flag == 1'b1)
    begin
        if(status==3'd0)
        begin
            sys_load <= 1'b0;
            sys_data <= `RED;
            pos <= pos + 1;
            if (pos >= H_DISP * V_DISP)
                status <= status + 1;
        end
        else if(status==3'd1)
        begin
            sys_addr_min <= H_DISP * 100;
            sys_load <= 1'b1;
            pos <= 0;
            status <= status + 1;
        end
        else if(status==3'd2)
        begin
            sys_load <= 1'b0;
            sys_data <= cnt_display;
            pos <= pos + 1;
            if (pos >= H_DISP * 200)
                status <= status + 1;
        end
    end
end

assign  sys_we =  write_en & sys_vaild & (status==3'd0 || status==3'd2);

endmodule
