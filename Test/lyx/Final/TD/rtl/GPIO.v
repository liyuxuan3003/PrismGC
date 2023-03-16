module GPIO 
(
    input clk,
    input RSTn,
    input outEn,
    input [7:0]  oData,  
    output[7:0]  iData,  
    inout[7:0]   ioPin
);

reg [7:0] ioPin_reg;

always@(posedge clk or negedge RSTn) 
begin
    if(~RSTn) ioPin_reg <= 8'd0;
    else ioPin_reg <= ioPin;
end

assign iData = ioPin_reg;
assign ioPin = outEn ? oData : 8'bzzzzzzzz;

endmodule