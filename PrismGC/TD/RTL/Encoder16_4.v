module Encoder16_4
(
    input [15:0]    sig,
    output[3:0]     code
);

assign code=
    (sig == 16'b0000_0000_0000_0001) ? 4'b0000 :
    (sig == 16'b0000_0000_0000_0010) ? 4'b0001 :
    (sig == 16'b0000_0000_0000_0100) ? 4'b0010 :
    (sig == 16'b0000_0000_0000_1000) ? 4'b0011 :
    (sig == 16'b0000_0000_0001_0000) ? 4'b0100 :
    (sig == 16'b0000_0000_0010_0000) ? 4'b0101 :
    (sig == 16'b0000_0000_0100_0000) ? 4'b0110 :
    (sig == 16'b0000_0000_1000_0000) ? 4'b0111 :
    (sig == 16'b0000_0001_0000_0000) ? 4'b1000 :
    (sig == 16'b0000_0010_0000_0000) ? 4'b1001 :
    (sig == 16'b0000_0100_0000_0000) ? 4'b1010 :
    (sig == 16'b0000_1000_0000_0000) ? 4'b1011 :
    (sig == 16'b0001_0000_0000_0000) ? 4'b1100 :
    (sig == 16'b0010_0000_0000_0000) ? 4'b1101 :
    (sig == 16'b0100_0000_0000_0000) ? 4'b1110 :
    (sig == 16'b1000_0000_0000_0000) ? 4'b1111 : 4'b1111;
    
endmodule