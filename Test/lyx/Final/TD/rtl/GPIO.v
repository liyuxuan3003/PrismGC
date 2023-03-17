module GPIO 
(
    input clk,
    input RSTn,
    input [3:0]   write_byte,
    input [3:0]   group_id,
    input [31:0]  o_ena,
    input [31:0]  o_dat,  
    output[31:0]  i_dat,  
    inout [31:0]  io_pin0,
    inout [31:0]  io_pin1,
    inout [31:0]  io_pin2,
    inout [31:0]  io_pin3
);
 
reg [31:0] o_dat_reg [3:0];
reg [31:0] i_dat_reg;

always@(posedge clk or negedge RSTn) 
begin
    if(~RSTn) i_dat_reg <= 32'h0000_0000;
    else 
    begin
        case (group_id)
            4'h0 : i_dat_reg <= io_pin0;
            4'h1 : i_dat_reg <= io_pin1;
            4'h2 : i_dat_reg <= io_pin2;
            4'h3 : i_dat_reg <= io_pin3;
            default: i_dat_reg <= 32'h0000_0000;
        endcase
    end
    
end
assign i_dat = i_dat_reg;

integer i;
integer group_id_int;
always@(posedge clk or negedge RSTn)
begin
    group_id_int=group_id;
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
            o_dat_reg[group_id_int][i] <= o_ena[i] ? o_dat[i] : 1'bz;
    end
end
assign io_pin0 = o_dat_reg[0];
assign io_pin1 = o_dat_reg[1];
assign io_pin2 = o_dat_reg[2];
assign io_pin3 = o_dat_reg[3];

endmodule