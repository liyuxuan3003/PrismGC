module GPIO 
(
    input clk,
    input RSTn,
    input [3:0]   write_byte,

    input [31:0]  o_ena0,
    input [31:0]  o_dat0,  
    output[31:0]  i_dat0,
    inout [31:0]  io_pin0,

    input [31:0]  o_ena1,
    input [31:0]  o_dat1,  
    output[31:0]  i_dat1,
    inout [31:0]  io_pin1,

    input [31:0]  o_ena2,
    input [31:0]  o_dat2,  
    output[31:0]  i_dat2,
    inout [31:0]  io_pin2,

    input [31:0]  o_ena3,
    input [31:0]  o_dat3,  
    output[31:0]  i_dat3,   
    inout [31:0]  io_pin3
);
 
reg [31:0] o_dat_reg [3:0];
reg [31:0] i_dat_reg [3:0];

always@(posedge clk or negedge RSTn) 
begin
    if(~RSTn)
    begin
        i_dat_reg[0] <= 32'h0000_0000;
        i_dat_reg[1] <= 32'h0000_0000;
        i_dat_reg[2] <= 32'h0000_0000;
        i_dat_reg[3] <= 32'h0000_0000;
    end 
    else 
    begin
        i_dat_reg[0] <= io_pin0;
        i_dat_reg[1] <= io_pin1;
        i_dat_reg[2] <= io_pin2;
        i_dat_reg[3] <= io_pin3;
    end
end

assign i_dat0 = i_dat_reg[0];
assign i_dat1 = i_dat_reg[1];
assign i_dat2 = i_dat_reg[2];
assign i_dat3 = i_dat_reg[3];

integer i;
always@(posedge clk or negedge RSTn)
begin
    if(~RSTn) 
    begin
        o_dat_reg[0] <= 32'bzzzzzzzz_zzzzzzzz_zzzzzzzz_zzzzzzzz;
        o_dat_reg[1] <= 32'bzzzzzzzz_zzzzzzzz_zzzzzzzz_zzzzzzzz;
        o_dat_reg[2] <= 32'bzzzzzzzz_zzzzzzzz_zzzzzzzz_zzzzzzzz;
        o_dat_reg[3] <= 32'bzzzzzzzz_zzzzzzzz_zzzzzzzz_zzzzzzzz;
    end
    else
    begin
        for(i=0;i<32;i=i+1)
        begin
            o_dat_reg[0][i] <= o_ena0[i] ? o_dat0[i] : 1'bz;
            o_dat_reg[1][i] <= o_ena1[i] ? o_dat1[i] : 1'bz;
            o_dat_reg[2][i] <= o_ena2[i] ? o_dat2[i] : 1'bz;
            o_dat_reg[3][i] <= o_ena3[i] ? o_dat3[i] : 1'bz;
        end
    end
end
assign io_pin0 = o_dat_reg[0];
assign io_pin1 = o_dat_reg[1];
assign io_pin2 = o_dat_reg[2];
assign io_pin3 = o_dat_reg[3];

endmodule