module AHBLiteDecoder #(parameter DEVICES_EXP=4)
(
    input[31:0] HADDR,
    output[2**DEVICES_EXP-1:0] HSEL_A,
    output[DEVICES_EXP-1:0] HSEL_ENCODE
);

assign HSEL_A[0]  = (HADDR[31:16] == 16'h0000) ? 1'b1 : 1'b0;
assign HSEL_A[1]  = (HADDR[31:16] == 16'h2000) ? 1'b1 : 1'b0;
assign HSEL_A[2]  = (HADDR[31:16] == 16'h4000) ? 1'b1 : 1'b0;
assign HSEL_A[3]  = (HADDR[31:16] == 16'h6000) ? 1'b1 : 1'b0;
assign HSEL_A[4]  = (HADDR[31:16] == 16'h6001) ? 1'b1 : 1'b0;
assign HSEL_A[5]  = (HADDR[31:16] == 16'h6002) ? 1'b1 : 1'b0;
assign HSEL_A[6]  = (HADDR[31:16] == 16'h6003) ? 1'b1 : 1'b0;
assign HSEL_A[7]  = (HADDR[31:16] == 16'h6004) ? 1'b1 : 1'b0;
assign HSEL_A[8]  = (HADDR[31:16] == 16'h6005) ? 1'b1 : 1'b0;
assign HSEL_A[9]  = (HADDR[31:16] == 16'h6006) ? 1'b1 : 1'b0;
assign HSEL_A[10] = (HADDR[31:16] == 16'h6007) ? 1'b1 : 1'b0;
assign HSEL_A[2**DEVICES_EXP-1:11] = 0;

Encoder16_4 uEncoder16_4
(
    .sig(HSEL_A),
    .code(HSEL_ENCODE)
);

endmodule