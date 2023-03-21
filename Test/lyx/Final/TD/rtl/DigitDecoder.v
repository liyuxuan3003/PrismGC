module DigitDecoder
(
    input[3:0]      digit,
    input           digit_enable,
    input           dot,
    output reg[7:0] seg
);
    
reg[6:0] seg_main;

always @(digit,dot) 
begin
    if(digit_enable==1'b0)
        seg_main=7'b0000000;
    else
    begin
        case (digit)
            4'h0 : seg_main=7'b0111111;
            4'h1 : seg_main=7'b0000110;
            4'h2 : seg_main=7'b1011011;
            4'h3 : seg_main=7'b1001111;
            4'h4 : seg_main=7'b1100110;
            4'h5 : seg_main=7'b1101101;
            4'h6 : seg_main=7'b1111101;
            4'h7 : seg_main=7'b0000111;
            4'h8 : seg_main=7'b1111111;
            4'h9 : seg_main=7'b1101111;
            4'hA : seg_main=7'b1110111;
            4'hB : seg_main=7'b1111100;
            4'hC : seg_main=7'b0111001;
            4'hD : seg_main=7'b1011110;
            4'hE : seg_main=7'b1111001;
            4'hF : seg_main=7'b1110001;
            default: ;
        endcase
    end
    seg={dot,seg_main};
end
endmodule