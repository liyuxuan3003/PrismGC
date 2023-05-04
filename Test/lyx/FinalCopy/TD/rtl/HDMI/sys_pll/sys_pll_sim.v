// Verilog netlist created by TD v5.0.30786
// Tue May  2 21:47:07 2023

`timescale 1ns / 1ps
module sys_pll  // sys_pll.v(25)
  (
  refclk,
  reset,
  clk0_out,
  clk1_out,
  clk2_out,
  clk3_out,
  extlock
  );

  input refclk;  // sys_pll.v(33)
  input reset;  // sys_pll.v(34)
  output clk0_out;  // sys_pll.v(36)
  output clk1_out;  // sys_pll.v(37)
  output clk2_out;  // sys_pll.v(38)
  output clk3_out;  // sys_pll.v(39)
  output extlock;  // sys_pll.v(35)

  wire clk0_buf;  // sys_pll.v(41)

  EG_PHY_GCLK bufg_feedback (
    .clki(clk0_buf),
    .clko(clk0_out));  // sys_pll.v(43)
  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  EG_PHY_PLL #(
    .CLKC0_CPHASE(9),
    .CLKC0_DIV(10),
    .CLKC0_DIV2_ENABLE("DISABLE"),
    .CLKC0_ENABLE("ENABLE"),
    .CLKC0_FPHASE(0),
    .CLKC1_CPHASE(6),
    .CLKC1_DIV(10),
    .CLKC1_DIV2_ENABLE("DISABLE"),
    .CLKC1_ENABLE("ENABLE"),
    .CLKC1_FPHASE(4),
    .CLKC2_CPHASE(19),
    .CLKC2_DIV(20),
    .CLKC2_DIV2_ENABLE("DISABLE"),
    .CLKC2_ENABLE("ENABLE"),
    .CLKC2_FPHASE(0),
    .CLKC3_CPHASE(3),
    .CLKC3_DIV(4),
    .CLKC3_DIV2_ENABLE("DISABLE"),
    .CLKC3_ENABLE("ENABLE"),
    .CLKC3_FPHASE(0),
    .CLKC4_CPHASE(1),
    .CLKC4_DIV(1),
    .CLKC4_DIV2_ENABLE("DISABLE"),
    .CLKC4_ENABLE("DISABLE"),
    .CLKC4_FPHASE(0),
    .DERIVE_PLL_CLOCKS("DISABLE"),
    .DPHASE_SOURCE("DISABLE"),
    .DYNCFG("DISABLE"),
    .FBCLK_DIV(2),
    .FEEDBK_MODE("NORMAL"),
    .FEEDBK_PATH("CLKC0_EXT"),
    .FIN("50.000"),
    .FREQ_LOCK_ACCURACY(2),
    .GEN_BASIC_CLOCK("DISABLE"),
    .GMC_GAIN(4),
    .GMC_TEST(14),
    .ICP_CURRENT(13),
    .IF_ESCLKSTSW("DISABLE"),
    .INTFB_WAKE("DISABLE"),
    .KVCO(4),
    .LPF_CAPACITOR(1),
    .LPF_RESISTOR(4),
    .NORESET("DISABLE"),
    .ODIV_MUXC0("DIV"),
    .ODIV_MUXC1("DIV"),
    .ODIV_MUXC2("DIV"),
    .ODIV_MUXC3("DIV"),
    .ODIV_MUXC4("DIV"),
    .PLLC2RST_ENA("DISABLE"),
    .PLLC34RST_ENA("DISABLE"),
    .PLLMRST_ENA("DISABLE"),
    .PLLRST_ENA("ENABLE"),
    .PLL_LOCK_MODE(0),
    .PREDIV_MUXC0("VCO"),
    .PREDIV_MUXC1("VCO"),
    .PREDIV_MUXC2("VCO"),
    .PREDIV_MUXC3("VCO"),
    .PREDIV_MUXC4("VCO"),
    .REFCLK_DIV(1),
    .REFCLK_SEL("INTERNAL"),
    .STDBY_ENABLE("DISABLE"),
    .STDBY_VCO_ENA("DISABLE"),
    .SYNC_ENABLE("DISABLE"),
    .VCO_NORESET("DISABLE"))
    pll_inst (
    .daddr(6'b000000),
    .dclk(1'b0),
    .dcs(1'b0),
    .di(8'b00000000),
    .dwe(1'b0),
    .fbclk(clk0_out),
    .load_reg(1'b0),
    .psclk(1'b0),
    .psclksel(3'b000),
    .psdown(1'b0),
    .psstep(1'b0),
    .refclk(refclk),
    .reset(reset),
    .stdby(1'b0),
    .clkc({open_n47,clk3_out,clk2_out,clk1_out,clk0_buf}),
    .extlock(extlock));  // sys_pll.v(78)

endmodule 

