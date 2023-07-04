/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module DigitDecoder
(
    input[3:0]      digit,
    input           digitEnable,
    input           dot,
    output reg[7:0] seg
);
    
reg[6:0] segMain;

always @(digit,dot) 
begin
    if(digitEnable==1'b0)
        segMain <= 7'b0000000;
    else
    begin
        case (digit)
            4'h0 : segMain <= 7'b0111111;
            4'h1 : segMain <= 7'b0000110;
            4'h2 : segMain <= 7'b1011011;
            4'h3 : segMain <= 7'b1001111;
            4'h4 : segMain <= 7'b1100110;
            4'h5 : segMain <= 7'b1101101;
            4'h6 : segMain <= 7'b1111101;
            4'h7 : segMain <= 7'b0000111;
            4'h8 : segMain <= 7'b1111111;
            4'h9 : segMain <= 7'b1101111;
            4'hA : segMain <= 7'b1110111;
            4'hB : segMain <= 7'b1111100;
            4'hC : segMain <= 7'b0111001;
            4'hD : segMain <= 7'b1011110;
            4'hE : segMain <= 7'b1111001;
            4'hF : segMain <= 7'b1110001;
        endcase
    end
    seg <= {dot,segMain};
end
endmodule