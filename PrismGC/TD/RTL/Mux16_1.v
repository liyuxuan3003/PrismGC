module Mux16_1 #(parameter WIDTH = 1)
(
    input [3:0] sel,
    input [16*WIDTH-1:0] sigIn,
    output[WIDTH-1:0]   sigOut
);

assign sigOut = 
    (sel == 4'b0000) ? sigIn[ 1*WIDTH-1: 0*WIDTH] :
    (sel == 4'b0001) ? sigIn[ 2*WIDTH-1: 1*WIDTH] :
    (sel == 4'b0010) ? sigIn[ 3*WIDTH-1: 2*WIDTH] :
    (sel == 4'b0011) ? sigIn[ 4*WIDTH-1: 3*WIDTH] :
    (sel == 4'b0100) ? sigIn[ 5*WIDTH-1: 4*WIDTH] :
    (sel == 4'b0101) ? sigIn[ 6*WIDTH-1: 5*WIDTH] :
    (sel == 4'b0110) ? sigIn[ 7*WIDTH-1: 6*WIDTH] :
    (sel == 4'b0111) ? sigIn[ 8*WIDTH-1: 7*WIDTH] :
    (sel == 4'b1000) ? sigIn[ 9*WIDTH-1: 8*WIDTH] :
    (sel == 4'b1001) ? sigIn[10*WIDTH-1: 9*WIDTH] :
    (sel == 4'b1010) ? sigIn[11*WIDTH-1:10*WIDTH] :
    (sel == 4'b1011) ? sigIn[12*WIDTH-1:11*WIDTH] :
    (sel == 4'b1100) ? sigIn[13*WIDTH-1:12*WIDTH] :
    (sel == 4'b1101) ? sigIn[14*WIDTH-1:13*WIDTH] :
    (sel == 4'b1110) ? sigIn[15*WIDTH-1:14*WIDTH] :
    (sel == 4'b1111) ? sigIn[16*WIDTH-1:15*WIDTH] : 0;
    
endmodule