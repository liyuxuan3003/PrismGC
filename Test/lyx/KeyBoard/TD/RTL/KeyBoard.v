module KeyBoard 
(
	input clk,
    input[7:0] SWI,
    output[7:0] LED,
    input[3:0] COL,
    output reg [3:0] ROW
);

reg[15:0] key;
reg[1:0] keyScanCnt;


always @(posedge clk) 
begin
    keyScanCnt <= keyScanCnt + 1;
    case (keyScanCnt)
        2'b00 : begin key[3:0]  <= COL; ROW <= 4'b1101; end
        2'b01 : begin key[7:4]  <= COL; ROW <= 4'b1011; end
        2'b10 : begin key[11:8] <= COL; ROW <= 4'b0111; end
        2'b11 : begin key[15:12]<= COL; ROW <= 4'b1110; end  
    endcase    
end

assign LED = (SWI[0]==0) ? key[7:0] : key[15:8];
    
endmodule