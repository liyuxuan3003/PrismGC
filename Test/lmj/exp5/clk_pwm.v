module clk_pwm (
  input clk_i,
  input rst_n,
  output clk_o 
);

reg  [24:0] cnt;
wire [24:0] cnt_nxt = (cnt == 25'd25000000) ? 25'd0 : cnt + 1'b1;

always @ (posedge clk_i or negedge rst_n) begin
  if (~rst_n) cnt <= 25'b0;
  else cnt <= cnt_nxt;
end

reg clk;

always @ (posedge clk_i or negedge rst_n) begin
  if (~rst_n) clk <= 1'b0;
  else if (cnt == 25'd25000000) clk <= ~clk;
end

assign clk_o = clk;

endmodule
