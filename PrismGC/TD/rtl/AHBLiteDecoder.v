/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

`include "GlobalDefine.v"

module AHBLiteDecoder
(
    input[31:0] HADDR,
    output[2**`DEVICES_EXP-1:0] HSEL_A
);

assign HSEL_A[`idRAMCode]   = (HADDR[31:16] == `addrRAMCode)    ? 1'b1 : 1'b0;
assign HSEL_A[`idRAMData]   = (HADDR[31:16] == `addrRAMData)    ? 1'b1 : 1'b0;
assign HSEL_A[`idSDRAM]     = (HADDR[31:16] == `addrSDRAM)      ? 1'b1 : 1'b0;
assign HSEL_A[`idTimer]     = (HADDR[31:16] == `addrTimer)      ? 1'b1 : 1'b0;
assign HSEL_A[`idGPIO]      = (HADDR[31:16] == `addrGPIO)       ? 1'b1 : 1'b0;
assign HSEL_A[`idUART]      = (HADDR[31:16] == `addrUART)       ? 1'b1 : 1'b0;
assign HSEL_A[`idIIC]       = (HADDR[31:16] == `addrIIC)        ? 1'b1 : 1'b0;
assign HSEL_A[`idHDMI]      = (HADDR[31:16] == `addrHDMI)       ? 1'b1 : 1'b0;
assign HSEL_A[`idGPULite]   = (HADDR[31:16] == `addrGPULite)    ? 1'b1 : 1'b0;
assign HSEL_A[`idBuzzer]    = (HADDR[31:16] == `addrBuzzer)     ? 1'b1 : 1'b0;
assign HSEL_A[`idDigit]     = (HADDR[31:16] == `addrDigit)      ? 1'b1 : 1'b0;
assign HSEL_A[`idKeyBoard]  = (HADDR[31:16] == `addrKeyBoard)   ? 1'b1 : 1'b0;
assign HSEL_A[2**`DEVICES_EXP-1:`idMAX] = 0;

endmodule