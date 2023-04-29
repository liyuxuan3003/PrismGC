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
    output reg    [31:0] HRDATA,  
    output wire          HRESP,
    output      TXD,            //UART串口 输出
    input       RXD             //UART串口 输入
);

wire state;
wire [7:0] UART_RX;
wire [7:0] UART_TX;
wire tx_en;

assign tx_en = wr_en_reg ? 1'b1 : 1'b0;
assign UART_TX = wr_en_reg ? HWDATA[7:0] : 8'b0;

assign HRESP = 1'b0;
assign HREADYOUT = 1'b1;

wire read_en;
assign read_en=HSEL&HTRANS[1]&(~HWRITE)&HREADY;

wire write_en;
assign write_en=HSEL&HTRANS[1]&(HWRITE)&HREADY;

reg [3:0] addr_reg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) addr_reg <= 4'h0;
    else if(read_en || write_en) addr_reg <= HADDR[3:0];
end

reg rd_en_reg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) rd_en_reg <= 1'b0;
    else if(read_en) rd_en_reg <= 1'b1;
    else rd_en_reg <= 1'b0;
end

reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn)
begin
    if(~HRESETn) wr_en_reg <= 1'b0;
    else if(write_en) wr_en_reg <= 1'b1;
    else  wr_en_reg <= 1'b0;
end

always@(*) 
begin
    if(rd_en_reg) 
    begin
        if(addr_reg == 4'h0) HRDATA <= {24'b0,UART_RX};
        else if(addr_reg == 4'h4) HRDATA <= {31'b0,state};
        else HRDATA <= 32'b0;
    end 
    else
        HRDATA <= 32'b0;
end

wire clk_uart;
wire bps_en;
wire bps_en_rx,bps_en_tx;

assign bps_en = bps_en_rx | bps_en_tx;

/*** 实例化UART时钟分频器 ***/
clkuart_pwm clkuart_pwm
(
    .clk(HCLK),
    .RSTn(HRESETn),
    .clk_uart(clk_uart),
    .bps_en(bps_en)
);

/*** 实例化UART输出TX ***/
UART_TX uUART_TX
(
    .clk(HCLK),
    .clk_uart(clk_uart),
    .RSTn(HRESETn),
    .data(UART_TX),
    .tx_en(tx_en),
    .TXD(TXD),
    .state(state),
    .bps_en(bps_en_tx)
);

/*** 实例化UART输入RX ***/
UART_RX uUART_RX
(
    .clk(HCLK),
    .clk_uart(clk_uart),
    .RSTn(HRESETn),
    .RXD(RXD),
    .data(UART_RX),
    .interrupt(interrupt_UART),
    .bps_en(bps_en_rx)
);

endmodule


