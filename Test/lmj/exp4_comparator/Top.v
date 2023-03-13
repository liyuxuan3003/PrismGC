module TOP(ina,inb,seg,sel);
    input [3:0] ina;
    input [3:0] inb;
    output [7:0] seg;
    output [3:0] sel;

    wire LT;
    wire GT;
    wire EQ;
    wire [3:0] data_disp;

    comparator comparator(
        .ina(ina),
        .inb(inb),
        .LT(LT),
        .GT(GT),
        .EQ(EQ)
    );
    Mux Mux(
        .ina(ina),
        .inb(inb),
        .sel(LT),
        .data_out(data_disp)
    );
    DIG_decoder DIG_decoder(
        .ctrl({EQ,GT}),
        .sel(sel)
    );
    seg_decoder seg_decoder(
        .data_disp(data_disp),
        .seg(seg)
    );
endmodule