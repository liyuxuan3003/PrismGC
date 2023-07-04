/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module AHBLiteGPIO #(parameter PORT_NUM = 4)
(
    input           HCLK,    
    input           HRESETn, 
    input           HSEL,    
    input[31:0]     HADDR,   
    input[1:0]      HTRANS,  
    input[2:0]      HSIZE,   
    input[3:0]      HPROT,   
    input           HWRITE,  
    input[31:0]     HWDATA,  
    input           HREADY,  
    output          HREADYOUT, 
    output[31:0]    HRDATA,  
    output          HRESP,
    inout[31:0]     io_pin0,
    inout[31:0]     io_pin1,
    inout[31:0]     io_pin2,
    inout[31:0]     io_pin3
);

localparam ADDR_WIDTH = 8;

assign HRESP = 1'b0;
assign HREADYOUT = 1'b1;

wire enableWrite = HREADY & HSEL & HTRANS[1] & ( HWRITE);
wire enableRead  = HREADY & HSEL & HTRANS[1] & (~HWRITE);

wire[3:0] sizeDecode;
reg [3:0] sizeDecodeReg;

SizeDecoder uSizeDecoder
(
    .addr(HADDR[1:0]),
    .size(HSIZE[1:0]),
    .sizeDecode(sizeDecode)
);

always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) 
        sizeDecodeReg <= 0;
    else if(enableWrite) 
        sizeDecodeReg <= sizeDecode;
end

reg [ADDR_WIDTH-1:0] addrReg;
always@(posedge HCLK or negedge HRESETn)
begin
    if(~HRESETn) 
        addrReg <= 0;
    else if(HREADY & HSEL & HTRANS[1]) 
        addrReg <= HADDR[(ADDR_WIDTH+1):2];
end

reg enableWriteReg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) 
        enableWriteReg <= 1'b0;
    else if(HREADY) 
        enableWriteReg <= enableWrite;
    else 
        enableWriteReg <= 1'b0;
end

GPIO #(.PORT_NUM(PORT_NUM)) uGPIO
(
    .clk(HCLK),
    .rstn(HRESETn),
    .addrIn(addrReg),
    .addrOut(HADDR[(ADDR_WIDTH+2-1):2]),
    .sizeDecode(enableWriteReg ? sizeDecodeReg : 4'b0000),
    .dataIn(HWDATA),
    .dataOut(HRDATA),
    .ioPin({io_pin3,io_pin2,io_pin1,io_pin0})
);

endmodule
