/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module SizeDecoder
(
    input[1:0]  addr,
    input[1:0]  size,
    output[3:0] sizeDecode
);

wire[3:0] addr_size = {addr,size};

assign sizeDecode = 
    //32位访问 1种情况
    (addr_size == 4'b00_10) ? 4'b1111 : 
    //16位访问 2种情况
    (addr_size == 4'b00_01) ? 4'b0011 : 
    (addr_size == 4'b10_01) ? 4'b1100 :
    //08位访问 4种情况
    (addr_size == 4'b00_00) ? 4'b0001 : 
    (addr_size == 4'b01_00) ? 4'b0010 :
    (addr_size == 4'b10_00) ? 4'b0100 :
    (addr_size == 4'b11_00) ? 4'b1000 : 4'b0000;

endmodule