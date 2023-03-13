module comparator(ina,inb,LT,GT,EQ);
    input [3:0] ina;
    input [3:0] inb;
    output LT;
    output GT;
    output EQ;
    assign LT = (ina < inb) ? 1'b1 : 1'b0;
    assign GT = (ina > inb) ? 1'b1 : 1'b0;
    assign EQ = (ina == inb) ? 1'b1 : 1'b0;
endmodule