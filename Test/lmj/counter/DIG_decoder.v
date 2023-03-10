module DIG_decoder(ctrl,sel);
    input [1:0] ctrl;
    output reg [3:0] sel; 
    always @ (ctrl)
        case (ctrl)
            2'b00 : sel = 4'b1110;
            2'b01 : sel = 4'b1101;
            2'b10 : sel = 4'b1011;
            2'b11 : sel = 4'b0111;
        endcase
endmodule