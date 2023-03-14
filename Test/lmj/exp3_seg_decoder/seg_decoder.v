module seg_decoder(data_disp,seg);
    input [3:0] data_disp;
    output reg [7:0] seg;
    always@(data_disp)
        case(data_disp)
            4'h0 : seg = 8'h3f;
            4'h1 : seg = 8'h06;
            4'h2 : seg = 8'h5b;
            4'h3 : seg = 8'h4f;
            4'h4 : seg = 8'h66;
            4'h5 : seg = 8'h6d;
            4'h6 : seg = 8'h7d;
            4'h7 : seg = 8'h07;
            4'h8 : seg = 8'h7f;
            4'h9 : seg = 8'h6f;
            4'ha : seg = 8'h77;
            4'hb : seg = 8'h7c;
            4'hc : seg = 8'h39;
            4'hd : seg = 8'h5e;
            4'he : seg = 8'h79;
            4'hf : seg = 8'h71;
        endcase
endmodule