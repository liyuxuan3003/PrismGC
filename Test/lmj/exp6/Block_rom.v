module block_rom # (
  parameter ADDR_WIDTH = 5,
  parameter DATA_WIDTH = 4
)(
  input clk_i,
  input  [ADDR_WIDTH - 1:0] addr,
  output reg [DATA_WIDTH - 1:0] data_o
);

(* romstyle = "block" *) reg [DATA_WIDTH-1:0] mem[2**ADDR_WIDTH - 1:0];

initial begin
  $readmemb("F:/FPGA/PrismGC/Test/lmj/exp6/data.hex", mem);
end

always @ (posedge clk_i) begin
  data_o <= mem[addr];
end

endmodule