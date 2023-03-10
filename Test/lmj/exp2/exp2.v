
module mux4(data_in,sel,data_out,LED);
	
    input [3:0] data_in;
    input [1:0] sel;
    output reg data_out;
    output [6:0] LED;
    assign LED=6'b0;
    always@(*)
        case(sel)
            2'b11 : data_out = data_in[3];
            2'b10 : data_out = data_in[2];
            2'b01 : data_out = data_in[1];
            2'b00 : data_out = data_in[0];
        endcase
endmodule

