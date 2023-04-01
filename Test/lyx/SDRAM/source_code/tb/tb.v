`timescale  1 ns / 1 ps

`define PERIOD 80

`define SIMULATION
`define DEBUG


module tb;




wire  ROM_DI;
wire  ROM_CLK;
wire  ROM_DO;


reg            SYS_CLK;


reg	Clk;
reg	Rst;
reg	CS_L;
reg	WE_L;
reg	OE_L;
////addr:23bit, data:8bit, addr[1:0] for DM[1:0]
reg	[22:0]	LA;
wire	[7:0]	LD;
reg			LOCAL_BUSY;

wire  			SDRAM_CLK;
wire 			SDRAM_RASn;
wire  			SDRAM_WEn;
wire  [1:0]		SDRAM_BA; 
wire  [10:0]	SDRAM_ADDR;
wire  			ROM_nCS;
wire  [31:0]	SDRAM_DQ ;
wire  			SDRAM_CASn;
wire  [3:0]		SDRAM_DQM; 
wire   			SDRAM_CKE;



  
  

top   DUT( 

	.SYS_CLK(SYS_CLK),
	
`ifdef SIMULATION
	.SDRAM_CLK(SDRAM_CLK),
	.SDR_CKE(SDRAM_CKE),
	.SDR_RAS(SDRAM_RASn),
	.SDR_CAS(SDRAM_CASn),
	.SDR_WE(SDRAM_WEn),
	.SDR_BA (SDRAM_BA),
	.SDR_ADDR( SDRAM_ADDR),
	.SDR_DM( SDRAM_DQM),
	.SDR_DQ	( SDRAM_DQ),
`endif	

	.LED()
		
	) ; 

      
     
IS42s32200 SDR1
    (
		.Clk ( SDRAM_CLK),
		.Cke ( SDRAM_CKE),
		.Cs_n ( 1'b0),
		.Ras_n ( SDRAM_RASn),
		.Cas_n ( SDRAM_CASn),
		.We_n ( SDRAM_WEn),
		.Ba ( SDRAM_BA),
		.Dqm ( SDRAM_DQM),
		.Addr ( SDRAM_ADDR),
		.Dq ( SDRAM_DQ)
    );   
      
// W25X40BV :  flash
   // port map
   // ( .CLK ( ROM_CLK),
     // .DIO  ( ROM_DI), 
     // .DO  ( ROM_DO),
     // .CSn ( ROM_nCS), 
     // .WPn ( wp), 
     // .HOLDn ( hold)
   // ); 
   
always begin
    SYS_CLK = 1'b0;
    #(`PERIOD/2) SYS_CLK = 1'b1;
    #(`PERIOD/2);
end   

initial
begin
	Rst =1'b1;
	# 1000000
	Rst =1'b0;
end
  
initial
begin
	CS_L=1'b1;
	WE_L=1'b1;
	OE_L=1'b1;
	//input	RW;	//0-wr;1-rd
	//input	[22:0]	LDA;	////addr:23bit; data:8bit; addr[1:0] for DM[1:0]
	LA=23'd0;
	force LD=8'd0;
	//# 20000000
	
	////write
	# 3000000
	CS_L=1'b0;
	WE_L=1'b0;
	OE_L=1'b1;
	LA=23'd1;
	force LD=8'haa;
	# 100
	CS_L=1'b1;
	WE_L=1'b1;
	OE_L=1'b1;
	LA=23'd0;
	force LD=8'h00;
	release LD;
	
	////read
	# 500
	CS_L=1'b0;
	WE_L=1'b1;
	OE_L=1'b0;
	LA=23'd1;
	//force LD=8'h00;
	# 200
	CS_L=1'b1;
	WE_L=1'b1;
	OE_L=1'b1;
	LA=23'd1;
	//force LD=8'h00;
	
end

 //glbl glbl();
  
endmodule 

