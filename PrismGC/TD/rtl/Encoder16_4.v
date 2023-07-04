/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module Encoder16_4
(
    input [15:0] signal,
    output[3:0]  code,
    output       enable
);

assign {enable,code} = 
    (signal == 16'b0000_0000_0000_0001) ? 5'h10 :
    (signal == 16'b0000_0000_0000_0010) ? 5'h11 :
    (signal == 16'b0000_0000_0000_0100) ? 5'h12 :
    (signal == 16'b0000_0000_0000_1000) ? 5'h13 :
    (signal == 16'b0000_0000_0001_0000) ? 5'h14 :
    (signal == 16'b0000_0000_0010_0000) ? 5'h15 :
    (signal == 16'b0000_0000_0100_0000) ? 5'h16 :
    (signal == 16'b0000_0000_1000_0000) ? 5'h17 :
    (signal == 16'b0000_0001_0000_0000) ? 5'h18 :
    (signal == 16'b0000_0010_0000_0000) ? 5'h19 :
    (signal == 16'b0000_0100_0000_0000) ? 5'h1A :
    (signal == 16'b0000_1000_0000_0000) ? 5'h1B :
    (signal == 16'b0001_0000_0000_0000) ? 5'h1C :
    (signal == 16'b0010_0000_0000_0000) ? 5'h1D :
    (signal == 16'b0100_0000_0000_0000) ? 5'h1E :
    (signal == 16'b1000_0000_0000_0000) ? 5'h1F : 5'h00;
    
endmodule