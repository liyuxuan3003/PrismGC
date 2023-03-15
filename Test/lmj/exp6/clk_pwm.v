module clk_pwm (
  input clk_i,
  input rst_n,//清零信号
  output clk_o // 1 Hz
);

reg  [24:0] cnt;                                  //计数器
wire [24:0] cnt_nxt = (cnt == 25'd25000000) ? 25'd0 : cnt + 1'b1;      //模为25000000

always @ (posedge clk_i or negedge rst_n) begin   //当晶振出现上升沿或者清零信号下降沿（后面注释先不管这个）时
  if (~rst_n) cnt <= 25'b0;                       //清零信号为0时，将cnt设置为0
  else cnt <= cnt_nxt;		                      //否则设置为递增
end

reg clk;

always @ (posedge clk_i or negedge rst_n) begin
  if (~rst_n) clk <= 1'b0;
  else if (cnt == 25'd25000000) clk <= ~clk;      //当计数器完成进位时，时钟信号取反
end

assign clk_o = clk;

endmodule