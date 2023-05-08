module AddrCnt(input wire clk,rst_n,en,
               input wire[31:0] rstAddr,
               output reg[31:0] Addr,
               output wire[31:0] NextAddr);

    always @(posedge clk) begin
        if(!rst_n)begin
            Addr <= rstAddr;
        end
        else if(en)begin
            Addr <= NextAddr;
        end
    end

    assign NextAddr = Addr+2'b10;

endmodule