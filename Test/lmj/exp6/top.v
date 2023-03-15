module WaterLight(
  input clk_i,
  input rst_n,
  input [1:0] sw,
  output [3:0] led
);

wire clk;
wire [4:0] start_addr, end_addr, addr;

clk_pwm pwm (
   .clk_i       (clk_i)
  ,.rst_n       (rst_n)
  ,.clk_o       (clk)
);

decoder dec (
   .sw          (sw)
  ,.start_addr  (start_addr)
  ,.end_addr    (end_addr)
);

counter cnt (
   .clk_i       (clk)
  ,.rst_n       (rst_n)
  ,.start_addr  (start_addr)
  ,.end_addr    (end_addr)
  ,.addr_o      (addr)
);

block_rom # (
   .ADDR_WIDTH  (5)
  ,.DATA_WIDTH  (4)
) rom_inst (
   .clk_i       (clk_i)
  ,.addr        (addr)
  ,.data_o      (led)
);

endmodule