module driver_segcs(code,segcs);
    input[1:0]      code;
    output reg[3:0] segcs;

    always @(code) 
    begin
        case (code)
            2'b00 : segcs=4'b1110;
            2'b01 : segcs=4'b1101;
            2'b10 : segcs=4'b1011;
            2'b11 : segcs=4'b0111; 
            default: ;
        endcase
    end
endmodule