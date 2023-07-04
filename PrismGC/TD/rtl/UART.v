/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module UART
(
    input               clk,
    input               rstn,
    input[7:0]          addrIn,
    input[7:0]          addrOut,
    input[3:0]          sizeDecode,
    input[31:0]         dataIn,
    output reg[31:0]    dataOut,
    output              IRQ,
    output              TXD,
    input               RXD
);

reg [31:0] mem [3:0];

`define RXDATA 0
`define TXSTAT 1
`define TXDATA 2

wire state;
wire [7:0] UART_RX;
wire [7:0] UART_TX;
wire tx_en;

always@(posedge clk) 
begin
    if(sizeDecode[0]) mem[addrIn[1:0]][7:0]   <= dataIn[7:0];
    if(sizeDecode[1]) mem[addrIn[1:0]][15:8]  <= dataIn[15:8];
    if(sizeDecode[2]) mem[addrIn[1:0]][23:16] <= dataIn[23:16];
    if(sizeDecode[3]) mem[addrIn[1:0]][31:24] <= dataIn[31:24];

    mem[`RXDATA] <= UART_RX;
    mem[`TXSTAT] <= state;

    dataOut <= mem[addrOut[1:0]];
end

assign tx_en = sizeDecode[0] ? 1'b1 : 1'b0;
assign UART_TX = sizeDecode[0] ? mem[`TXDATA][7:0] : 8'b0;

wire clk_uart;
wire bps_en;
wire bps_en_rx,bps_en_tx;

assign bps_en = bps_en_rx | bps_en_tx;

/*** 实例化UART时钟分频器 ***/
UARTClock UARTClock
(
    .clk(clk),
    .RSTn(rstn),
    .clk_uart(clk_uart),
    .bps_en(bps_en)
);

/*** 实例化UART输出TX ***/
UART_TX uUART_TX
(
    .clk(clk),
    .clk_uart(clk_uart),
    .RSTn(rstn),
    .data(UART_TX),
    .tx_en(tx_en),
    .TXD(TXD),
    .state(state),
    .bps_en(bps_en_tx)
);

/*** 实例化UART输入RX ***/
UART_RX uUART_RX
(
    .clk(clk),
    .clk_uart(clk_uart),
    .RSTn(rstn),
    .RXD(RXD),
    .data(UART_RX),
    .interrupt(IRQ),
    .bps_en(bps_en_rx)
);

endmodule