// Verilog netlist created by TD v4.2.003
// Sat Aug 11 22:08:13 2018

`timescale 1ns / 1ps
module read_fifo  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(14)
  (
  clkr,
  clkw,
  di,
  re,
  rst,
  we,
  aempty_flag,
  do,
  empty_flag,
  full_flag
  );

  input clkr;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(25)
  input clkw;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(24)
  input [31:0] di;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(23)
  input re;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(25)
  input rst;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(22)
  input we;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(24)
  output aempty_flag;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(28)
  output [31:0] do;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(27)
  output empty_flag;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(28)
  output full_flag;  // F:/Anlogic_Project/EG4S20NG88_Sensor_VGA_Board/02_SDRAM_VGA_Display_1280720/src/Sdram_Control_2Port_512Kx4x32Bit/read_fifo.v(29)

  wire empty_flag_neg;
  wire full_flag_neg;

  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  not empty_flag_inv (empty_flag_neg, empty_flag);
  not full_flag_inv (full_flag_neg, full_flag);
  EG_PHY_FIFO #(
    .AE(32'b00000000000000000001000000000000),
    .AEP1(32'b00000000000000000001000000010000),
    .AF(32'b00000000000000000001111110100000),
    .AFM1(32'b00000000000000000001111110010000),
    .ASYNC_RESET_RELEASE("SYNC"),
    .DATA_WIDTH_A("18"),
    .DATA_WIDTH_B("18"),
    .E(32'b00000000000000000000000000000000),
    .EP1(32'b00000000000000000000000000010000),
    .F(32'b00000000000000000010000000000000),
    .FM1(32'b00000000000000000001111111110000),
    .GSR("ENABLE"),
    .MODE("FIFO8K"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"))
    logic_fifo_0 (
    .clkr(clkr),
    .clkw(clkw),
    .csr({2'b11,empty_flag_neg}),
    .csw({2'b11,full_flag_neg}),
    .dia(di[8:0]),
    .dib(di[17:9]),
    .orea(1'b0),
    .oreb(1'b0),
    .re(re),
    .rprst(rst),
    .rst(rst),
    .we(we),
    .aempty_flag(aempty_flag),
    .doa(do[8:0]),
    .dob(do[17:9]),
    .empty_flag(empty_flag),
    .full_flag(full_flag));
  EG_PHY_FIFO #(
    .AE(32'b00000000000000000001000000000000),
    .AEP1(32'b00000000000000000001000000010000),
    .AF(32'b00000000000000000001111110100000),
    .AFM1(32'b00000000000000000001111110010000),
    .ASYNC_RESET_RELEASE("SYNC"),
    .DATA_WIDTH_A("18"),
    .DATA_WIDTH_B("18"),
    .E(32'b00000000000000000000000000000000),
    .EP1(32'b00000000000000000000000000010000),
    .F(32'b00000000000000000010000000000000),
    .FM1(32'b00000000000000000001111111110000),
    .GSR("ENABLE"),
    .MODE("FIFO8K"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"))
    logic_fifo_1 (
    .clkr(clkr),
    .clkw(clkw),
    .csr({2'b11,empty_flag_neg}),
    .csw({2'b11,full_flag_neg}),
    .dia(di[26:18]),
    .dib({open_n48,open_n49,open_n50,open_n51,di[31:27]}),
    .orea(1'b0),
    .oreb(1'b0),
    .re(re),
    .rprst(rst),
    .rst(rst),
    .we(we),
    .doa(do[26:18]),
    .dob({open_n54,open_n55,open_n56,open_n57,do[31:27]}));

endmodule 

