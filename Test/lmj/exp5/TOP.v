module WaterLight(
  input clk_i,
  input rst_n,
  input [1:0] sw,
  output [3:0] led
);

wire clk;

clk_pwm pwm (
   .clk_i       (clk_i),
   .rst_n       (rst_n),
   .clk_o       (clk)
);

generator gene (
   .clk_i       (clk),
   .rst_n      (rst_n),
   .sw        (sw),
   .mode      (led)
);

endmodule