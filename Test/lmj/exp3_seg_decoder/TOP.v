module TOP(data_disp,ctrl,seg,sel,LED);
    input [3:0] data_disp;
    input [1:0] ctrl;
    output [7:0] seg;
    output [3:0] sel;
    output [7:0]LED;
    assign LED=8'b0;
    DIG_decoder DIG_decoder(
        .ctrl(ctrl),
        .sel(sel)
    );
    seg_decoder seg_decoder(
        .data_disp(data_disp),
        .seg(seg)
    );
endmodule