// Verilog netlist created by TD v5.0.30786
// Sun Aug 13 22:07:52 2023

`timescale 1ns / 1ps
module MemTest  // test.v(14)
  (
  addra,
  cea,
  clka,
  dia,
  ocea,
  rsta,
  wea,
  doa
  );

  input [10:0] addra;  // test.v(29)
  input cea;  // test.v(31)
  input clka;  // test.v(33)
  input [31:0] dia;  // test.v(28)
  input ocea;  // test.v(32)
  input rsta;  // test.v(34)
  input wea;  // test.v(30)
  output [31:0] doa;  // test.v(26)

  parameter ADDR_WIDTH_A = 11;
  parameter ADDR_WIDTH_B = 11;
  parameter DATA_DEPTH_A = 2048;
  parameter DATA_DEPTH_B = 2048;
  parameter DATA_WIDTH_A = 32;
  parameter DATA_WIDTH_B = 32;
  parameter REGMODE_A = "OUTREG";
  parameter WRITEMODE_A = "NORMAL";

  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  // address_offset=0;data_offset=0;depth=2048;width=16;num_section=1;width_per_section=16;section_size=32;working_depth=2048;working_width=16;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  EG_PHY_BRAM32K #(
    .CLKBMUX("0"),
    .CSBMUX("0"),
    .DATA_WIDTH_A("16"),
    .DATA_WIDTH_B("16"),
    .MODE("SP16K"),
    .OCEBMUX("0"),
    .REGMODE_A("OUTREG"),
    .REGMODE_B("NOREG"),
    .RSTBMUX("0"),
    .SRMODE("SYNC"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    inst_2048x32_sub_000000_000 (
    .addra(addra),
    .addrb(11'b00000000000),
    .bytewea(1'b0),
    .byteweb(1'b0),
    .clka(clka),
    .csa(cea),
    .dia(dia[15:0]),
    .ocea(ocea),
    .rsta(rsta),
    .wea(wea),
    .doa(doa[15:0]));
  // address_offset=0;data_offset=16;depth=2048;width=16;num_section=1;width_per_section=16;section_size=32;working_depth=2048;working_width=16;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  EG_PHY_BRAM32K #(
    .CLKBMUX("0"),
    .CSBMUX("0"),
    .DATA_WIDTH_A("16"),
    .DATA_WIDTH_B("16"),
    .MODE("SP16K"),
    .OCEBMUX("0"),
    .REGMODE_A("OUTREG"),
    .REGMODE_B("NOREG"),
    .RSTBMUX("0"),
    .SRMODE("SYNC"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    inst_2048x32_sub_000000_016 (
    .addra(addra),
    .addrb(11'b00000000000),
    .bytewea(1'b0),
    .byteweb(1'b0),
    .clka(clka),
    .csa(cea),
    .dia(dia[31:16]),
    .ocea(ocea),
    .rsta(rsta),
    .wea(wea),
    .doa(doa[31:16]));

endmodule 

