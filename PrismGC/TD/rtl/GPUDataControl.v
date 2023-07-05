/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */
 
module GPUDataControl
#(
    parameter           H_DISP = 0,
    parameter           V_DISP = 0
)
(
    input               clk,
    input               rstn,
    input[15:0]         xpos,
    input[15:0]         ypos,
    input[23:0]         len,
    input               enable, 
    output reg          busy,

    //sys 2 sdram control
    input               sysVaild,
    output reg          sysLoad,
    output              sysWriteEnable,
    output reg[7:0]     sysWriteRefresh,
    output reg[31:0]    sysAddrMin,
    output reg[31:0]    sysAddrMax,
    input               sysFull,
    input               sysEmpty,

    output reg[23:0]    wrCount
);

reg[2:0]  wrState;
reg[2:0]  wrDiv;

always @(posedge clk or negedge rstn) 
begin
    if(!rstn)
	begin
        wrState <= 0;
		wrCount <= 0;
		wrDiv <= 0;
        busy <= 0;
        sysWriteRefresh <= 0;
	end
    else

        begin
        case (wrState)
            0: begin
                busy <= 0;
                sysWriteRefresh <= 0;
                wrState <= enable ? 1:0;
            end
            1: begin
                busy <= 1;
                sysAddrMin <= xpos + ypos * H_DISP;
                sysAddrMax <= H_DISP * (V_DISP  + 1);
                sysLoad <= 1'b1;
                wrState <= 2;
                wrDiv <= 0;
            end
            2: begin
                busy <= 1;
                sysLoad <= 1'b0;
                wrCount <= 0;
                wrDiv <= 0;
                wrState <= 3;
            end
            3: begin
                busy <= 1;
                wrDiv <= wrDiv + 1;
                if(wrDiv == 0)
                begin
                    wrCount <= wrCount + 1;
                    if(wrCount == len+7)
                    begin
                        wrState <= 4;
                    end 
                end
            end
            4: begin
                busy <= 0;
                wrState <= enable ? 4:0;
                sysWriteRefresh <= 0;
            end
            default: wrState <= 0;
        endcase
        end
end
assign sysWriteEnable = ((wrDiv==1) && (wrState==3))? 1:0;
endmodule
