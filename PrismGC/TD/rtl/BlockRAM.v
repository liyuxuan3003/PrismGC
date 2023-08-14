/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

 `include "GlobalDefine.v"
 
module BlockRAM #(parameter MEM_ADDR_WIDTH = 0)   
(
    input                       clk,
    input [MEM_ADDR_WIDTH-1:0]  addrIn,
    input [MEM_ADDR_WIDTH-1:0]  addrOut,
    input [3:0]                 sizeDecode,
    input  [31:0]               dataIn,
    output reg [31:0]           dataOut
);

(* ram_style="block" *)reg [31:0] mem [(2**MEM_ADDR_WIDTH-1):0];

always@(posedge clk) 
begin
    if(sizeDecode[0]) mem[addrIn][7:0]   <= dataIn[7:0];
    if(sizeDecode[1]) mem[addrIn][15:8]  <= dataIn[15:8];
    if(sizeDecode[2]) mem[addrIn][23:16] <= dataIn[23:16];
    if(sizeDecode[3]) mem[addrIn][31:24] <= dataIn[31:24];

    dataOut <= mem[addrOut];
end

endmodule