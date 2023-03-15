module generator (
  input clk_i,
  input rst_n,
  input [1:0] sw, 
  output [3:0] mode
);

reg [3:0] mode_reg;
reg [3:0] nxt_mode;

always @ (*) begin//次态生成逻辑
  if (sw == 2'b00) begin
    if (mode_reg == 4'b0 || mode_reg == 4'b1000) nxt_mode = 4'b0001;
    else nxt_mode = mode_reg << 1;
  end
  else if (sw == 2'b01) begin
    if (mode_reg == 4'b0 || mode_reg == 4'b0001) nxt_mode = 4'b1000;
    else nxt_mode = mode_reg >> 1;
  end
  else begin
    nxt_mode[3] = ~mode_reg[0]; 
    nxt_mode[2:0] = mode_reg >> 1;
  end
end

always @ (posedge clk_i or negedge rst_n) begin//次态迁移至现态
  if (~rst_n) mode_reg <= 4'b0;
  else mode_reg <= nxt_mode;
end

assign mode = mode_reg;//输出模块

endmodule
