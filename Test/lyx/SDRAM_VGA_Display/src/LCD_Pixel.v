module LCD_Pixel
#(
    parameter           H_DISP = 12'd1024,
    parameter           V_DISP = 12'd600
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
    output  reg [31:0]  sys_addr,
    output  reg [7:0]   sys_len
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

reg[23:0]   cnt;
reg         frame_sig;
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
    begin
        cnt<=24'h00_00_00;
        frame_sig<=1'b0;
    end
    else
    begin
        cnt<=cnt+1;
        if(cnt == 24'h00_00_00)
            frame_sig<=1'b1;
        else
            frame_sig<=1'b0;
    end
end

always @(posedge clk)
begin
    if (frame_sig==1'b1)
    begin
        sys_load<=1'b1;
        sys_addr<=31'h0000_0100;
        sys_len<=9'd128;
    end
    else
    begin
        sys_load<=1'b0;
        sys_data <= `RED;
    end
end

assign sys_we = 1'b1;


endmodule
