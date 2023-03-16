module counter(
  input clk_i,
  input rst_n,
  input [4:0] start_addr,
  input [4:0] end_addr,
  output [4:0] addr_o
);

reg [4:0] cnt;
wire [4:0] cnt_nxt = (cnt == end_addr) ? start_addr : cnt + 1'b1;

always @ (posedge clk_i or negedge rst_n) begin
  if (~rst_n) cnt <= start_addr;
  else cnt <= cnt_nxt;
end

assign addr_o = cnt;

endmodule