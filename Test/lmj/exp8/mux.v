module Mux(sel,ina,inb,inc,ind,data_out);
    input [1:0] sel;
    input [3:0] ina,inb,inc,ind;
    output reg [3:0] data_out;
    always@(*)
        case(sel) 
            2'b00 : data_out = ina;
            2'b01 : data_out = inb;
            2'b10 : data_out = inc;
            2'b11 : data_out = ind;
            default : data_out = 0;
        endcase
endmodule