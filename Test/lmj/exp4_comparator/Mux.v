module Mux(ina,inb,sel,data_out);
    input [3:0] ina;
    input [3:0] inb;
    input sel;
    output [3:0] data_out;
    assign data_out = sel ? inb : ina;
endmodule  