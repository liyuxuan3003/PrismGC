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

parameter DATA_WIDTH_A = 32; 
parameter ADDR_WIDTH_A = 13;
parameter DATA_DEPTH_A = 8192;
parameter DATA_WIDTH_B = 32;
parameter ADDR_WIDTH_B = 13;
parameter DATA_DEPTH_B = 8192;
parameter REGMODE_A    = "NOREG";
parameter REGMODE_B    = "NOREG";
parameter WRITEMODE_A  = "NORMAL";
parameter WRITEMODE_B  = "NORMAL";

EG_LOGIC_BRAM #( .DATA_WIDTH_A(DATA_WIDTH_A),
            .DATA_WIDTH_B(DATA_WIDTH_B),
            .ADDR_WIDTH_A(ADDR_WIDTH_A),
            .ADDR_WIDTH_B(ADDR_WIDTH_B),
            .DATA_DEPTH_A(DATA_DEPTH_A),
            .DATA_DEPTH_B(DATA_DEPTH_B),
            .MODE("PDPW"),
            .REGMODE_A(REGMODE_A),
            .REGMODE_B(REGMODE_B),
            .WRITEMODE_A(WRITEMODE_A),
            .WRITEMODE_B(WRITEMODE_B),
            .RESETMODE("SYNC"),
            .IMPLEMENT("32K"),
            .INIT_FILE("NONE"),
            .FILL_ALL("11111111111111111111111111111111"))
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