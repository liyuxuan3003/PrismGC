module GPIO 
(
    input clk,
    input RSTn,
    input outEn,
    input [31:0]  oData,  
    output[31:0]  iData,  
    inout [31:0]  ioPin
);

reg [31:0] ioPin_reg;

always@(posedge clk or negedge RSTn) 
begin
    if(~RSTn) ioPin_reg <= 31'd0;
    else ioPin_reg <= ioPin;
end

assign iData = ioPin_reg;
assign ioPin = outEn ? oData : 32'bzzzzzzzz_zzzzzzzz_zzzzzzzz_zzzzzzzz;

endmodule