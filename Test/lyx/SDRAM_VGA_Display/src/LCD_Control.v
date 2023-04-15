`timescale 1 ns / 1 ns
module LCD_Control
#(
    parameter           H_DISP = 12'd1024,
    parameter           V_DISP = 12'd600
)
(
    input               clk,            //globan clock    
    input               rst_n,          //Global reset    
    input               sys_vaild,      //the device is ready
    input[15:0]         x_pos,
    input[15:0]         y_pos,
    input[23:0]         pixel,
    input[23:0]         len,
    input               enable, 
    
    //sys 2 sdram control
    output  reg         sys_load,
    output  reg [23:0]  sys_data,
    output              sys_we,
    output  reg [31:0]  sys_addr_min,
    output  reg [31:0]  sys_addr_max,
    output  reg         busy
);

reg[4:0] cnt_div;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_div <= 0;
    else
        cnt_div <= cnt_div + 1;
end

reg[23:0] cnt;
reg state;
reg done;
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
    begin
        state <= 0;
        sys_addr_max <= H_DISP * V_DISP;
        done <= 0;
        cnt <= 0;
    end
    else if(sys_vaild)
    begin
        if(enable == 1'b0)
            done = 1'b0;
        else if(enable == 1'b1 & busy == 1'b0 & done == 1'b0)
        begin
            busy <= 1'b1;
            sys_addr_min <= x_pos + y_pos * H_DISP;
            sys_addr_max <= H_DISP * (V_DISP  + 1);
            sys_load <= 1'b1;
            cnt <= 0;
            state <= 1'b0;
        end
        else if(busy == 1'b1)
        begin
            sys_load <= 1'b0;
            // state <= ~state;
            if(cnt_div==0)
            begin
                if (pixel == `GREEN)
                    sys_data <= cnt;
                cnt <= cnt + 1;
                if(cnt == len+254)
                begin
                    busy <= 1'b0;
                    done <= 1'b1;
                end
            end        
        end
    end
end

assign sys_we = (cnt_div==1) & busy;

endmodule
