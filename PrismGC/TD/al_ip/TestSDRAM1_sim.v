// Verilog netlist created by TD v5.0.30786
// Mon Aug 14 10:56:59 2023

`timescale 1ns / 1ps
module TestSDRAM1  // TestSDRAM1.v(14)
  (
  addr,
  ba,
  cas_n,
  cke,
  clk,
  cs_n,
  dm0,
  dm1,
  dm2,
  dm3,
  ras_n,
  we_n,
  dq
  );

  input [10:0] addr;  // TestSDRAM1.v(19)
  input [1:0] ba;  // TestSDRAM1.v(20)
  input cas_n;  // TestSDRAM1.v(17)
  input cke;  // TestSDRAM1.v(27)
  input clk;  // TestSDRAM1.v(15)
  input cs_n;  // TestSDRAM1.v(22)
  input dm0;  // TestSDRAM1.v(23)
  input dm1;  // TestSDRAM1.v(24)
  input dm2;  // TestSDRAM1.v(25)
  input dm3;  // TestSDRAM1.v(26)
  input ras_n;  // TestSDRAM1.v(16)
  input we_n;  // TestSDRAM1.v(18)
  inout [31:0] dq;  // TestSDRAM1.v(21)


  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  EG_PHY_SDRAM_2M_32 sdram (
    .addr(addr),
    .ba(ba),
    .cas_n(cas_n),
    .cke(cke),
    .clk(clk),
    .cs_n(cs_n),
    .dm0(dm0),
    .dm1(dm1),
    .dm2(dm2),
    .dm3(dm3),
    .ras_n(ras_n),
    .we_n(we_n),
    .dq(dq));  // TestSDRAM1.v(29)

endmodule 

