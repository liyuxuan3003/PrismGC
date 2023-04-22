module Mux16_1 #(parameter WIDTH = 1)
(
    input [16-1:0] sel,
    input [16*WIDTH-1:0] sigIn,
    output[WIDTH-1:0]   sigOut,
    input[WIDTH-1:0]    sigOutDefault
);

assign sigOut = 
    (sel == 16'b0000_0000_0000_0001) ? sigIn[ 1*WIDTH-1: 0*WIDTH] :
    (sel == 16'b0000_0000_0000_0010) ? sigIn[ 2*WIDTH-1: 1*WIDTH] :
    (sel == 16'b0000_0000_0000_0100) ? sigIn[ 3*WIDTH-1: 2*WIDTH] :
    (sel == 16'b0000_0000_0000_1000) ? sigIn[ 4*WIDTH-1: 3*WIDTH] :
    (sel == 16'b0000_0000_0001_0000) ? sigIn[ 5*WIDTH-1: 4*WIDTH] :
    (sel == 16'b0000_0000_0010_0000) ? sigIn[ 6*WIDTH-1: 5*WIDTH] :
    (sel == 16'b0000_0000_0100_0000) ? sigIn[ 7*WIDTH-1: 6*WIDTH] :
    (sel == 16'b0000_0000_1000_0000) ? sigIn[ 8*WIDTH-1: 7*WIDTH] :
    (sel == 16'b0000_0001_0000_0000) ? sigIn[ 9*WIDTH-1: 8*WIDTH] :
    (sel == 16'b0000_0010_0000_0000) ? sigIn[10*WIDTH-1: 9*WIDTH] :
    (sel == 16'b0000_0100_0000_0000) ? sigIn[11*WIDTH-1:10*WIDTH] :
    (sel == 16'b0000_1000_0000_0000) ? sigIn[12*WIDTH-1:11*WIDTH] :
    (sel == 16'b0001_0000_0000_0000) ? sigIn[13*WIDTH-1:12*WIDTH] :
    (sel == 16'b0010_0000_0000_0000) ? sigIn[14*WIDTH-1:13*WIDTH] :
    (sel == 16'b0100_0000_0000_0000) ? sigIn[15*WIDTH-1:14*WIDTH] :
    (sel == 16'b1000_0000_0000_0000) ? sigIn[16*WIDTH-1:15*WIDTH] : sigOutDefault;
    
endmodule

module Mux8_1
(
    input [7:0] sel,
    input [7:0] sigIn,
    output reg sigOut,
    input  sigOutDefault
);

always @(*) 
begin
    case (sel)
        8'b0000_0001 : sigOut<=sigIn[0];
        8'b0000_0010 : sigOut<=sigIn[1];
        8'b0000_0100 : sigOut<=sigIn[2];
        8'b0000_1000 : sigOut<=sigIn[3];
        8'b0001_0000 : sigOut<=sigIn[4];
        8'b0010_0000 : sigOut<=sigIn[5];
        8'b0100_0000 : sigOut<=sigIn[6];
        8'b1000_0000 : sigOut<=sigIn[7]; 
        default: sigOut<=sigOutDefault;
    endcase
end  
endmodule