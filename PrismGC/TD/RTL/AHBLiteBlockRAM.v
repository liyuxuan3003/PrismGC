module AHBLiteBlockRAM #(parameter ADDR_WIDTH = 12)
(
    input  wire                     HCLK,    
    input  wire                     HRESETn, 
    input  wire                     HSEL,    
    input  wire   [31:0]            HADDR,   
    input  wire   [1:0]             HTRANS,  
    input  wire   [2:0]             HSIZE,   
    input  wire   [3:0]             HPROT,   
    input  wire                     HWRITE,  
    input  wire   [31:0]            HWDATA,   
    input  wire                     HREADY, 
    output wire                     HREADYOUT, 
    output wire   [31:0]            HRDATA,  
    output wire                     HRESP
);

assign HRESP = 1'b0;

//Block RAM 总是可以在一个时钟内完全任务
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

BlockRAM uBlockRAM
(
    .clk(HCLK),
    .addrIn(HADDR[(ADDR_WIDTH+2-1):2]),
    .addrOut(HADDR[(ADDR_WIDTH+2-1):2]),
    .sizeDecode(sizeDecodeReg),
    .dataIn(HWDATA),
    .dataOut(HRDATA)
);

endmodule
