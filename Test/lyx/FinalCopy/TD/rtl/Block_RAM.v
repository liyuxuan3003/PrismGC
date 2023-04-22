module Block_RAM #(parameter ADDR_WIDTH = 12)   
(
    input clka,
    input [ADDR_WIDTH-1:0] addra,
    input [ADDR_WIDTH-1:0] addrb,
    input [31:0] dina,
    input [3:0] wea, 
    output reg [31:0] doutb
);

(* ram_style="block" *)reg [31:0] mem [(2**ADDR_WIDTH-1):0];

always@(posedge clka) 
begin
    if(wea[0]) mem[addra][7:0]   <= dina[7:0];
    if(wea[1]) mem[addra][15:8]  <= dina[15:8];
    if(wea[2]) mem[addra][23:16] <= dina[23:16];
    if(wea[3]) mem[addra][31:24] <= dina[31:24];
    doutb <= mem[addrb];
end

endmodule