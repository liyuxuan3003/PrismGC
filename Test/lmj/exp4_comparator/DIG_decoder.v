module DIG_decoder(ctrl,sel);
    input [1:0] ctrl;
    output reg [3:0] sel;
    always@(ctrl) 
        case(ctrl)
            2'b00 : sel = 4'b1100;
            2'b01 : sel = 4'b0011;
            2'b10 : sel = 4'b0000;
            default : sel = 4'b1111;
        endcase
endmodule