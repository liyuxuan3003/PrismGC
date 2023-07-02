module BlockROM1 # (
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 1
)(
    input                         clk,
    input  [ADDR_WIDTH-1 : 0]     addr,
    output reg [DATA_WIDTH-1 : 0] data
);

(* ramstyle = "AUTO" *) reg [DATA_WIDTH-1 : 0] mem[(2**ADDR_WIDTH-1) : 0];

initial begin
    $readmemh("E:/M0/Experiments/Task9/rtl/LCD/sign.txt", mem);
end

always @ (posedge clk) begin
    data <= mem[addr];
end

endmodule