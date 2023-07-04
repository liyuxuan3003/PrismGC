/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

`include "GlobalDefine.v"

module KeyBoard 
(
    input               clk,
    input               rstn,
    input[7:0]          addrIn,
    input[7:0]          addrOut,
    input[3:0]          sizeDecode,
    input[31:0]         dataIn,
    output reg[31:0]    dataOut,
    input[3:0]          COL,
    output reg [3:0]    ROW
);

reg [31:0] mem [0:0];

wire[3:0]   keyCode;
wire        keyEnable;

always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[0] <= 32'hFFFF_FFFF;
    end
    else
    begin
        // if(sizeDecode[0]) mem[addrIn][7:0]   <= dataIn[7:0];
        // if(sizeDecode[1]) mem[addrIn][15:8]  <= dataIn[15:8];
        // if(sizeDecode[2]) mem[addrIn][23:16] <= dataIn[23:16];
        // if(sizeDecode[3]) mem[addrIn][31:24] <= dataIn[31:24];

        if(keyEnable)
            mem[0] <= {28'h0000_000,keyCode};
        else
            mem[0] <= {32'hFFFF_FFFF};

        dataOut <= mem[0]; 
    end
end

reg[15:0]   key;
reg[1:0]    keyScanCnt;

always @(posedge clk) 
begin
    keyScanCnt <= keyScanCnt + 1;
    case (keyScanCnt)
        2'b00 : begin key[3:0]  <= COL; ROW <= 4'b1101; end
        2'b01 : begin key[7:4]  <= COL; ROW <= 4'b1011; end
        2'b10 : begin key[11:8] <= COL; ROW <= 4'b0111; end
        2'b11 : begin key[15:12]<= COL; ROW <= 4'b1110; end  
    endcase    
end


Encoder16_4 uEncoder16_4
(
    .signal(~key),
    .code(keyCode),
    .enable(keyEnable)
);

endmodule