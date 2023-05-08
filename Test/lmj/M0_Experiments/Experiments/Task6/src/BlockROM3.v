module BlockROM3#(
    parameter ADDR_WIDTH=16,
    parameter DATA_WIDTH=12
    )(
        input clk,
        input en,
        input [ADDR_WIDTH-1:0] addr_i,
        output reg [DATA_WIDTH-1:0] data_o
    );
(*ramstyle="block"*)reg[DATA_WIDTH-1:0]mem[(2**ADDR_WIDTH-1):0] ;
initial begin
    $readmemh("E:/M0/Experiments/Task6/src/3.txt", mem);
    end       
always @(posedge clk)begin
    if (en) begin
    data_o<=mem[addr_i];
end
end
endmodule