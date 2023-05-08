module AHBLiteUART
(
    input  wire          HCLK,    
    input  wire          HRESETn, 
    input  wire          HSEL,    
    input  wire   [31:0] HADDR,   
    input  wire    [1:0] HTRANS,  
    input  wire    [2:0] HSIZE,   
    input  wire    [3:0] HPROT,   
    input  wire          HWRITE,  
    input  wire   [31:0] HWDATA,  
    input  wire          HREADY,  
    output wire          HREADYOUT, 
    output wire   [31:0] HRDATA,  
    output wire          HRESP,
    output               IRQ,            //中断
    output               TXD,            //UART串口 输出
    input                RXD             //UART串口 输入
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

UART uUART
(
    .clk(HCLK),
    .rstn(HRESETn),
    .addrIn(addrReg),
    .addrOut(HADDR[(ADDR_WIDTH+2-1):2]),
    .sizeDecode(enableWriteReg ? sizeDecodeReg : 4'b0000),
    .dataIn(HWDATA),
    .dataOut(HRDATA),
    .IRQ(IRQ),
    .TXD(TXD),
    .RXD(RXD)
);

endmodule


