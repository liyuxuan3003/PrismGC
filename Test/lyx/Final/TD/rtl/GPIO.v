module GPIO 
(
    input clk,
    input RSTn,
    input [31:0]  outEn,
    input [31:0]  oData,  
    output[31:0]  iData,  
    inout [31:0]  ioPin
);

reg [31:0] iPin_reg;
reg [31:0] oPin_reg;

always@(posedge clk or negedge RSTn) 
begin
    if(~RSTn) iPin_reg <= 32'h0000_0000;
    else iPin_reg <= ioPin;
end
assign iData = iPin_reg;

always@(posedge clk or negedge RSTn)
begin
    if(~RSTn) oPin_reg <= 32'bzzzzzzzz_zzzzzzzz_zzzzzzzz_zzzzzzzz;
    else
    begin
        integer i;
        for(i=0;i<32;i=i+1)
            oPin_reg[i] <= outEn[i] ? oData[i] : 1'bz; 
    end
end
assign ioPin = oPin_reg;

endmodule