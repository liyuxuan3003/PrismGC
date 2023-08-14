/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

 `include "GlobalDefine.v"
 
module BlockROM #(parameter MEM_ADDR_WIDTH = 0)   
(
    input                       clk,
    input [MEM_ADDR_WIDTH-1:0]  addrIn,
    input [MEM_ADDR_WIDTH-1:0]  addrOut,
    input [3:0]                 sizeDecode,
    input  [31:0]               dataIn,
    output [31:0]               dataOut
);

assign cea = (sizeDecode==4'b1111)?1:0;

EG_LOGIC_BRAM #( 
    .DATA_WIDTH_A(32),
    .DATA_WIDTH_B(32),
    .ADDR_WIDTH_A(MEM_ADDR_WIDTH),
    .ADDR_WIDTH_B(MEM_ADDR_WIDTH),
    .DATA_DEPTH_A(2**MEM_ADDR_WIDTH),
    .DATA_DEPTH_B(2**MEM_ADDR_WIDTH),
    .MODE("PDPW"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"),
    .RESETMODE("SYNC"),
    .IMPLEMENT("32K"),
    .INIT_FILE("MIF/code.mif"),
    .FILL_ALL("NONE"))
inst(
    .dia(dataIn),
    .dib({32{1'b0}}),
    .addra(addrIn),
    .addrb(addrOut),
    .cea(cea),
    .ceb(1'b1),
    .ocea(1'b0),
    .oceb(1'b0),
    .clka(clk),
    .clkb(clk),
    .wea(1'b1),
    .web(1'b0),
    .bea(1'b0),
    .beb(1'b0),
    .rsta(1'b0),
    .rstb(1'b0),
    .doa(),
    .dob(dataOut));

endmodule