`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: anlgoic
// Author: 	xg 
// description: app write and read test pattern generator and check
//////////////////////////////////////////////////////////////////////////////////

`define DEBUG
`include "../source_code/include/global_def.v"

module app_wrrd 
	(   
		input   Clk,
        input   Rst,
		
		input			Sdr_init_done,
		input			Sdr_init_ref_vld,
		
        output						App_wr_en, 
        output  [`ADDR_WIDTH-1:0]	App_wr_addr,  
		output	[`DM_WIDTH-1:0]		App_wr_dm,
		output	[`DATA_WIDTH-1:0]	App_wr_din,
		
		output						App_rd_en,
		output	[`ADDR_WIDTH-1:0]	App_rd_addr,
		input						Sdr_rd_en,
		input	[`DATA_WIDTH-1:0]	Sdr_rd_dout,
		
		output	reg		Check_ok	//synthesis keep
	);

reg	[2:0]	judge_cnt;
reg			tx_vld;
reg	[13:0]	tx_cnt;
reg			wr_en;
reg	[`ADDR_WIDTH-1:0]	wr_addr,wr_addr_1d;
reg	[`DATA_WIDTH-1:0]	wr_din;
reg						rd_en;
reg	[`ADDR_WIDTH-1:0]	rd_addr,rd_addr_1d;
	
	
always @(posedge Clk)
begin
	if(Rst)
		judge_cnt <= 'd0;
	else if(Sdr_init_done)
		judge_cnt <= judge_cnt+1'b1;
end	
	
	
always @(posedge Clk)
begin
	if(Rst)
		tx_vld <= 'd0;
	else if(judge_cnt==3'b111 & (!Sdr_init_ref_vld))
		tx_vld <= 1'b1;
	else if(tx_cnt[13] | Sdr_init_ref_vld)
		tx_vld <= 1'b0;
end

always @(posedge Clk)
begin
	if(Rst)
		tx_cnt <= 'd0;
	else if(tx_vld)
		tx_cnt <= tx_cnt+1'b1;
	else
		tx_cnt <= 'd0;
end



always @(posedge Clk)
begin
	if(Rst)
		begin	
			wr_en <= 1'b0;
			wr_addr <= 'd0;
			wr_din <= 'd0;
			
			wr_addr_1d <= 'd0;
		end
	else 
		if(tx_cnt[12:11]==2'b01)
			begin
				wr_en <= 1'b1;
				wr_addr <= wr_addr+1'b1;
				wr_din <= wr_din+1'b1;
			end
		else
			begin
				wr_en <= 1'b0;
				wr_addr <= wr_addr;
				wr_din <= wr_din;
			end
		wr_addr_1d <= wr_addr;
end
assign		App_wr_en=wr_en;
assign  	App_wr_addr=wr_addr_1d;
assign		App_wr_dm=4'b0000;
assign		App_wr_din=wr_din;


always @(posedge Clk)
begin
	if(Rst)
		begin	
			rd_en <= 1'b0;
			rd_addr <= 'd0;
			rd_addr_1d <= 'd0;
		end
	else 
		if(tx_cnt[12:11]==2'b11)
			begin
				rd_en <= 1'b1;
				rd_addr <= rd_addr+1'b1;
			end
		else
			begin
				rd_en <= 1'b0;
				rd_addr <= rd_addr;
			end
		rd_addr_1d <= rd_addr;
end

assign App_rd_en=rd_en;
assign App_rd_addr=rd_addr_1d;


reg			Sdr_rd_en_1d;
reg	[15:0]	init_data,Sdr_rd_dout_1d;

always @(posedge Clk)
begin
	if(Rst)
		init_data <= 'd0;
	else if(Sdr_rd_en)
		init_data <= init_data+1'b1;
end

always @(posedge Clk)
begin
	Sdr_rd_dout_1d <= Sdr_rd_dout[15:0];
	Sdr_rd_en_1d <= Sdr_rd_en;
	
	if(Sdr_rd_en_1d)
		if(init_data!=Sdr_rd_dout_1d)
			Check_ok <= 1'b1;
		else
			Check_ok <= 1'b0;
	else
		Check_ok <= 1'b0;
end
	



endmodule 
