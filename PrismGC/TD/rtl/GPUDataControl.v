/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */
 
module GPUDataControl
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
    output  reg         busy,

    //sys 2 sdram control
    output  reg         sys_load,
    output  reg [23:0]  sys_data,
    output              sys_we,
    output  reg [7:0]   sys_refresh,
    output  reg [31:0]  sys_addr_min,
    output  reg [31:0]  sys_addr_max
);

reg[2:0]  wrState;
reg[2:0]  wrDiv;
reg[23:0] wrCount;
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
	begin
        wrState <= 0;
		wrCount <= 0;
		wrDiv <= 0;
        busy <= 0;
        sys_refresh <= 0;
	end
    else

        begin
        case (wrState)
            0: begin
                busy <= 0;
                sys_refresh <= 0;
                wrState <= enable ? 1:0;
                end
            1: begin
                busy <= 1;
                sys_addr_min <= x_pos + y_pos * H_DISP;
                sys_addr_max <= H_DISP * (V_DISP  + 1);
                sys_load <= 1'b1;
                wrState <= 2;
                wrDiv <= 0;
                end
            2: begin
                busy <= 1;
                sys_load <= 1'b0;
                wrCount <= 0;
                wrDiv <= 0;
                wrState <= 3;
                end
            3: begin
                busy <= 1;
                wrDiv <= wrDiv + 1;
                sys_data <= pixel;
                if(wrDiv == 0)
                begin
                    wrCount <= wrCount + 1;
                    if(wrCount == len+255)
                    begin
                    	wrState <= 4;
                        //sys_refresh <= len[7:0];
                    end 
                end
                end
            4: begin
                busy <= 0;
                wrState <= enable ? 4:0;
                sys_refresh <= 0;
                end
            default: wrState <= 0;
        endcase
        end
end
assign sys_we = ((wrDiv==1) && (wrState==3))? 1:0;
endmodule
