module Digit 
(
    input       clk,
    output reg[7:0] seg_pin,
    output reg[3:0] segcs_pin,
    inout[3:0] DIG0,
    inout[3:0] DIG1,
    inout[3:0] DIG2,
    inout[3:0] DIG3,
    inout[3:0] DIG_DOT,
    inout[3:0] DIG_ENA,
    inout[3:0] DIG_CRT
);

reg[1:0] now_dig;

wire dig0_seg;
wire dig1_seg;
wire dig2_seg;
wire dig3_seg;

DigitDecoder dd0(.digit(DIG0), .digit_enable(DIG_ENA[0]), .dot(DIG_DOT[0]), .seg(dig0_seg));
DigitDecoder dd1(.digit(DIG1), .digit_enable(DIG_ENA[0]), .dot(DIG_DOT[1]), .seg(dig1_seg));
DigitDecoder dd2(.digit(DIG2), .digit_enable(DIG_ENA[0]), .dot(DIG_DOT[2]), .seg(dig2_seg));
DigitDecoder dd3(.digit(DIG3), .digit_enable(DIG_ENA[0]), .dot(DIG_DOT[3]), .seg(dig3_seg));

always @(posedge clk) 
begin
    case (DIG_CRT)
        4'b0000: begin seg_pin=dig0_seg; segcs_pin=4'b1110; end
        4'b0001: begin seg_pin=dig1_seg; segcs_pin=4'b1101; end
        4'b0010: begin seg_pin=dig2_seg; segcs_pin=4'b1011; end
        4'b0011: begin seg_pin=dig3_seg; segcs_pin=4'b0111; end
        4'b1111:
        begin
            now_dig=now_dig+1;
            case (now_dig)
                2'b00 : begin seg_pin=dig0_seg; segcs_pin=4'b1110; end
                2'b01 : begin seg_pin=dig1_seg; segcs_pin=4'b1101; end
                2'b10 : begin seg_pin=dig2_seg; segcs_pin=4'b1011; end
                2'b11 : begin seg_pin=dig3_seg; segcs_pin=4'b0111; end
            endcase
        end
        4'b1100: begin seg_pin=7'bzzzzzzzz; segcs_pin=4'bzzzz; end 
        default: begin seg_pin=7'bzzzzzzzz; segcs_pin=4'bzzzz; end 
    endcase
end
    
endmodule