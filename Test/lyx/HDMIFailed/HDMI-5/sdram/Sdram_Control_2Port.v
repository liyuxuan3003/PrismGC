`include    "Sdram_Params.v"

module Sdram_Control_2Port
(
	//	HOST Side
	input                 REF_CLK,       //sdram control clock
	input                 OUT_CLK,       //sdram output clock
	input                 RESET_N,       //System Reset
	//	FIFO Write Side 1
	input   [`DSIZE-1:0]  WR_DATA,       //Data input
	input				  WR,		     //Write Request
	input	[`ASIZE-1:0]  WR_MIN_ADDR, 	 //Write start address
	input	[`ASIZE-1:0]  WR_MAX_ADDR,   //Write max address
	input	[8:0]		  WR_LENGTH,   	 //Write length
	input				  WR_LOAD,	     //Write register load & fifo clear
	input				  WR_CLK,	     //Write fifo clock
	//	FIFO Read Side 1
	output  [`DSIZE-1:0]  RD_DATA,       //Data output
	input				  RD,		     //Read Request
	input	[`ASIZE-1:0]  RD_MIN_ADDR, 	 //Read start address
	input	[`ASIZE-1:0]  RD_MAX_ADDR,   //Read max address
	input	[8:0]		  RD_LENGTH,   	 //Read length
	input				  RD_LOAD,	     //Read register load & fifo clear
	input				  RD_CLK,	     //Read fifo clock

	//User interface add by CrazyBingo
	output		Sdram_Init_Done,		//SDRAM Init done signal
	input		Sdram_Read_Valid,		//SDRAM Read valid : output
	input		Sdram_PingPong_EN		//SDRAM PING-PONG operation enable
);


//	Internal Registers/Wires
//	Controller
reg		[`ASIZE-1:0]			mADDR;					//Internal address
reg		[8:0]					mLENGTH;				//Internal length
reg		[`ASIZE-1:0]			rWR_ADDR;				//Register write address				
reg		[`ASIZE-1:0]			rRD_ADDR;				//Register read address
reg								WR_MASK;				//Write port active mask
reg								RD_MASK;				//Read port active mask
reg								mWR_DONE;				//Flag write done, 1 pulse SDR_CLK
reg								mRD_DONE;				//Flag read done, 1 pulse SDR_CLK
reg								mWR,Pre_WR;				//Internal WR edge capture
reg								mRD,Pre_RD;				//Internal RD edge capture
reg 	[9:0] 					ST;						//Controller status
reg		[1:0] 					CMD;					//Controller command
reg								Read;					//Flag read active
reg								Write;					//Flag write active
wire    [`DSIZE-1:0]           	mDATAIN;                //Controller Data input
wire    [`DSIZE-1:0]           	mDATAIN1;                //Controller Data input 1
wire                          	CMDACK;                 //Controller command acknowledgement

//	FIFO Control
reg								OUT_VALID;				//Output data request to read side fifo
reg								IN_REQ;					//Input	data request to write side fifo
		
always@(posedge REF_CLK or negedge RESET_N)
begin
	if(RESET_N==0)
		begin
		CMD			<=  0;
		ST			<=  0;
		Pre_RD		<=  0;
		Pre_WR		<=  0;
		Read		<=	0;
		Write		<=	0;
		OUT_VALID	<=	0;
		IN_REQ		<=	0;
		mWR_DONE	<=	0;
		mRD_DONE	<=	0;
		end
	else
		begin
		Pre_RD	<=	mRD;
		Pre_WR	<=	mWR;
		case(ST)
		0:	begin
			if({Pre_RD,mRD}==2'b01)
				begin
				Read	<=	1;
				Write	<=	0;
				CMD		<=	2'b01;
				ST		<=	1;
				end
			else if({Pre_WR,mWR}==2'b01)
				begin
				Read	<=	0;
				Write	<=	1;
				CMD		<=	2'b10;
				ST		<=	1;
				end
			end
		1:	begin
			if(CMDACK==1)
				begin
				CMD<=2'b00;
				ST<=2;
				end
			end
		default:	
			begin	
			if(ST!=SC_CL+SC_RCD+mLENGTH+1)
				ST<=ST+1'b1;
			else
				ST<=0;
			end
		endcase
	
		if(Read)	//read done
			begin
			if(ST==SC_CL+SC_RCD+1)
				OUT_VALID	<=	1;
			else if(ST==SC_CL+SC_RCD+mLENGTH+1)
				begin
				OUT_VALID	<=	0;
				Read		<=	0;
				mRD_DONE	<=	1;
				end
			end
		else
			mRD_DONE	<=	0;
		
		if(Write)	//write done
			begin
			if(ST==SC_CL-1)
				IN_REQ	<=	1;
			else if(ST==SC_CL+mLENGTH-1)
				IN_REQ	<=	0;
			else if(ST==SC_CL+SC_RCD+mLENGTH)
				begin
				Write	<=	0;
				mWR_DONE<=	1;
				end
			end
		else
			mWR_DONE<=	0;

	end
end

//------------------------------------------------------------------------------------------------
//	Internal Address & Length Control for Write
wire	[`ASIZE-1:0]	WR_MIN_ADDR1 = WR_MIN_ADDR;
wire	[`ASIZE-1:0]	WR_MAX_ADDR1 = WR_MAX_ADDR;
wire	[`ASIZE-1:0]	WR_MIN_ADDR2 = {~WR_MIN_ADDR[`ASIZE-1], WR_MIN_ADDR[`ASIZE-2:0]};	//Ping-Pong1 operation
wire	[`ASIZE-1:0]	WR_MAX_ADDR2 = {~WR_MAX_ADDR[`ASIZE-1], WR_MAX_ADDR[`ASIZE-2:0]};	//Ping-Pong2 operation
wire	PINGPONG1_WRADDR1 = (rWR_ADDR >=  WR_MIN_ADDR1 && rWR_ADDR <= WR_MAX_ADDR1 - WR_LENGTH) ? 1'b1 : 1'b0;
wire	PINGPONG1_WRADDR2 = (rWR_ADDR >=  WR_MIN_ADDR2 && rWR_ADDR <= WR_MAX_ADDR2 - WR_LENGTH) ? 1'b1 : 1'b0;
always@(posedge REF_CLK or negedge RESET_N)
begin
	if(!RESET_N)
		rWR_ADDR <= WR_MIN_ADDR1;
	else if(WR_LOAD)
		rWR_ADDR <= WR_MIN_ADDR1;
	else if(mWR_DONE & WR_MASK)						//While 1 page write has done
		begin
		//Bank 0-1 for Ping-Pong1
		if(PINGPONG1_WRADDR1 == 1'b1)
			begin
			if(rWR_ADDR < WR_MAX_ADDR1 - WR_LENGTH)
				rWR_ADDR	<=	rWR_ADDR + WR_LENGTH;
			else
				begin
				if(Sdram_PingPong_EN)				//SDRAM PING-PONG operation enable
					rWR_ADDR	<=	WR_MIN_ADDR2;	//Go to Ping-Pong2
				else
					rWR_ADDR	<=	WR_MIN_ADDR1;	//Remain Ping-Pong1
				end
			end
		//Bank 2-3 for Ping-Pong2
		if(PINGPONG1_WRADDR2 == 1'b1)
			begin
			if(rWR_ADDR < WR_MAX_ADDR2 - WR_LENGTH)
				rWR_ADDR	<=	rWR_ADDR + WR_LENGTH;
			else
				begin
				if(Sdram_PingPong_EN)				//SDRAM PING-PONG operation enable
					rWR_ADDR	<=	WR_MIN_ADDR1;	//Go to Ping-Pong1	
				else
					rWR_ADDR	<=	WR_MIN_ADDR2;	//Remain Ping-Pong2
				end	
			end
		end
	else
		rWR_ADDR <= rWR_ADDR;
end


//------------------------------------------------------------------------------------------------
//	Internal Address & Length Control for Read; If enable Ping-Pong operation, Read should switch the address
wire	[`ASIZE-1:0]	RD_MIN_ADDR1 = RD_MIN_ADDR;
wire	[`ASIZE-1:0]	RD_MAX_ADDR1 = RD_MAX_ADDR;
wire	[`ASIZE-1:0]	RD_MIN_ADDR2 = {~RD_MIN_ADDR[`ASIZE-1], RD_MIN_ADDR[`ASIZE-2:0]};	//Ping-Pong1 operation
wire	[`ASIZE-1:0]	RD_MAX_ADDR2 = {~RD_MAX_ADDR[`ASIZE-1], RD_MAX_ADDR[`ASIZE-2:0]};	//Ping-Pong2 operation
wire	PINGPONG1_RDADDR1 = (rRD_ADDR >=  RD_MIN_ADDR1 && rRD_ADDR <= RD_MAX_ADDR1 - RD_LENGTH) ? 1'b1 : 1'b0;
wire	PINGPONG1_RDADDR2 = (rRD_ADDR >=  RD_MIN_ADDR2 && rRD_ADDR <= RD_MAX_ADDR2 - RD_LENGTH) ? 1'b1 : 1'b0;
always@(posedge REF_CLK or negedge RESET_N)
begin
	if(!RESET_N)
		begin	
		if(Sdram_PingPong_EN)							//SDRAM PING-PONG operation enable			
			rRD_ADDR <= RD_MIN_ADDR2;
		else
			rRD_ADDR <= RD_MIN_ADDR1;
		end
	else if(RD_LOAD)
		begin
		if(Sdram_PingPong_EN)							//SDRAM PING-PONG operation enable			
			rRD_ADDR <= RD_MIN_ADDR2;
		else
			rRD_ADDR <= RD_MIN_ADDR1;
		end
	else if(mRD_DONE & RD_MASK)							//While 1 page read has done
		begin
		//Bank 0-1 for Ping-Pong1
		if(PINGPONG1_RDADDR1 == 1'b1)
			begin
			if(rRD_ADDR < RD_MAX_ADDR1 - RD_LENGTH)
				rRD_ADDR	<=	rRD_ADDR + RD_LENGTH;
			else
				begin
				if(Sdram_PingPong_EN)					//SDRAM PING-PONG operation enable	
					begin
					if(PINGPONG1_WRADDR1 == 1'b1)
						rRD_ADDR	<=	RD_MIN_ADDR2;	//Go to Ping-Pong2
					else if(PINGPONG1_WRADDR2 == 1'b1)
						rRD_ADDR	<=	RD_MIN_ADDR1;	//Remain Ping-Pong1
					end
				else
					rRD_ADDR	<=	RD_MIN_ADDR1;		//Steady Ping-Pong1
				end
			end
		//Bank 2-3 for Ping-Pong2
		if(PINGPONG1_RDADDR2 == 1'b1)		
			begin
			if(rRD_ADDR < RD_MAX_ADDR2 - RD_LENGTH)
				rRD_ADDR	<=	rRD_ADDR + RD_LENGTH;
			else
				begin
				if(Sdram_PingPong_EN)					//SDRAM PING-PONG operation enable	
					begin
					if(PINGPONG1_WRADDR1 == 1'b1)
						rRD_ADDR	<=	RD_MIN_ADDR2;	//Remain Ping-Pong2
					else if(PINGPONG1_WRADDR2 == 1'b1)
						rRD_ADDR	<=	RD_MIN_ADDR1;	//Go to Ping-Pong1
					end
				else
					rRD_ADDR	<=	RD_MIN_ADDR2;		//Steady Ping-Pong2
				end
			end
		end
	else
		rRD_ADDR <= rRD_ADDR;
end


//---------------------------------------------------------------------------------------------------
//	Auto Read/Write Control
always@(posedge REF_CLK or negedge RESET_N)
begin
	if(!RESET_N)
		begin
		mWR		<=	0;
		mRD		<=	0;
		mADDR	<=	0;
		mLENGTH	<=	0;
		WR_MASK	<= 	0;
		RD_MASK	<= 	0;
		end
	else
		begin
		if((mWR==0) && (mRD==0) && (ST==0) && (WR_MASK==0) && (RD_MASK==0))	//free
			begin	
			//	Write Side 1 is most important
//			if( (write_side_fifo_rusedw1 >= WR_LENGTH) && (WR_LOAD==0))	//write fifo
			if( (wfifo_afull_flag == 1'b1) && (WR_LOAD==0))	//write fifo
				begin
				mADDR	<=	rWR_ADDR;
				mLENGTH	<=	WR_LENGTH;
				WR_MASK	<=	1;
				RD_MASK	<=	0;
				mWR		<=	1;
				mRD		<=	0;
				end
//			else if((read_side_fifo_wusedw1 < RD_LENGTH) && (RD_LOAD==0) && (Sdram_Read_Valid == 1'b1))	//read fifo
			else if((rfifo_aempty_flag == 1'b1) && (RD_LOAD==0) && (Sdram_Read_Valid == 1'b1))	//read fifo
				begin
				mADDR	<=	rRD_ADDR;
				mLENGTH	<=	RD_LENGTH;
				WR_MASK	<=	0;
				RD_MASK	<=	1;
				mWR		<=	0;
				mRD		<=	1;				
				end
			end
		if(mWR_DONE)	//write sdram done
			begin
			WR_MASK	<=	0;
			mWR		<=	0;
			end
		if(mRD_DONE)	//read sdram done
			begin
			RD_MASK	<=	0;
			mRD		<=	0;
			end
	end
end

wire    wfifo_afull_flag;
EG_LOGIC_FIFO #(
 	.DATA_WIDTH_W(32),
	.DATA_WIDTH_R(32),
	.DATA_DEPTH_W(1024),
	.DATA_DEPTH_R(1024),
	.ENDIAN("BIG"),
	.RESETMODE("ASYNC"),
	.E(0),
	.F(1024),
	.ASYNC_RESET_RELEASE("SYNC"),
	.AF(256))
u_write_fifo(
	.rst            (~RESET_N | WR_LOAD),
    .clkw           (WR_CLK), 
	.di             (WR_DATA), 
    .we             (WR), 
	.csw(3'b111),
    
    .clkr           (REF_CLK), 
	.do             (mDATAIN1),
    .re             (IN_REQ & WR_MASK), 
	.csr(3'b111),
	.ore(1'b0),

    .empty_flag     (), 
	.aempty_flag    (),
    .full_flag      (),
	.afull_flag     (wfifo_afull_flag) 
);
				
assign	mDATAIN	= (WR_MASK) ? mDATAIN1 : {`DSIZE-1{1'b1}};

wire    rfifo_aempty_flag;  //rrusede < 256
EG_LOGIC_FIFO #(
 	.DATA_WIDTH_W(32),
	.DATA_WIDTH_R(32),
	.DATA_DEPTH_W(512),
	.DATA_DEPTH_R(512),
	.ENDIAN("BIG"),
	.RESETMODE("ASYNC"),
	.E(0),
	.F(512),
	.ASYNC_RESET_RELEASE("SYNC"),
	.AE(256))
u_read_fifo(
	.rst            (~RESET_N | RD_LOAD),
    .clkw           (REF_CLK), 
	.di             (DQ), 
    .we             (OUT_VALID & RD_MASK), 
	.csw(3'b111),

    .clkr           (RD_CLK), 
	.do             (RD_DATA),
    .re             (RD), 
	.csr(3'b111),
	.ore(1'b0),
    
	.empty_flag     (), 
	.full_flag      (),
    .aempty_flag    (rfifo_aempty_flag),
	.afull_flag()
);

reg								PM_STOP;				//Flag page mode stop
reg								PM_DONE;				//Flag page mode done

//	SDRAM Side
wire   [`DSIZE-1:0]         	DQ;                     //SDRAM data bus
wire							SDR_CLK;				//SDRAM clock
//	DRAM Control
reg  	[`DSIZE/8-1:0]          DQM;                    //SDRAM data mask lines
reg     [`ROWSIZE -1:0]         SA;                     //SDRAM address output
reg     [1:0]                   BA;                     //SDRAM bank address
reg     		                CS_N;                   //SDRAM Chip Selects
reg                             CKE;                    //SDRAM clock enable
reg                             RAS_N;                  //SDRAM Row address Strobe
reg                             CAS_N;                  //SDRAM Column address Strobe
reg                             WE_N;                   //SDRAM write enable
wire    [`DSIZE-1:0]            DQOUT;					//SDRAM data out link

//wire	active	=	Read | Write;
assign	DQOUT = mDATAIN;
assign  DQ = oe ? DQOUT : `DSIZE'hzzzz;
assign SDR_CLK = OUT_CLK;		//sdram output clock

//	DRAM Internal Control
wire    [`ASIZE-1:0]            saddr;
wire                            load_mode;
wire                            nop;
wire                            reada;
wire                            writea;
wire                            refresh;
wire                            precharge;
wire                            oe;
wire							ref_ack;
wire							ref_req;
wire							init_req;
wire							cm_ack;

//wire  	[`DSIZE/8-1:0]          IDQM;                   //SDRAM data mask lines
wire    [`ROWSIZE -1:0]         ISA;                    //SDRAM address output
wire    [1:0]                   IBA;                    //SDRAM bank address
wire    	                    ICS_N;                  //SDRAM Chip Selects
wire                            ICKE;                   //SDRAM clock enable
wire                            IRAS_N;                 //SDRAM Row address Strobe
wire                            ICAS_N;                 //SDRAM Column address Strobe
wire                            IWE_N;                  //SDRAM write enable
control_interface control1 (
	.CLK			(REF_CLK),
	.RESET_N		(RESET_N),
	.CMD			(CMD),
	.ADDR			(mADDR),
	.REF_ACK		(ref_ack),
	.CM_ACK			(cm_ack),
	.NOP			(nop),
	.READA			(reada),
	.WRITEA			(writea),
	.REFRESH		(refresh),
	.PRECHARGE		(precharge),
	.LOAD_MODE		(load_mode),
	.SADDR			(saddr),
	.REF_REQ		(ref_req),
	.INIT_REQ		(init_req),
	.CMD_ACK		(CMDACK),
	.Sdram_Init_Done(Sdram_Init_Done)
);

command command1(
	.CLK			(REF_CLK),
	.RESET_N		(RESET_N),
	.SADDR			(saddr),
	.NOP			(nop),
	.READA			(reada),
	.WRITEA			(writea),
	.REFRESH		(refresh),
	.LOAD_MODE		(load_mode),
	.PRECHARGE		(precharge),
	.REF_REQ		(ref_req),
	.INIT_REQ		(init_req),
	.REF_ACK		(ref_ack),
	.CM_ACK			(cm_ack),
	.OE				(oe),
	.PM_STOP		(PM_STOP),
	.PM_DONE		(PM_DONE),
	.SA				(ISA),
	.BA				(IBA),
	.CS_N			(ICS_N),
	.CKE			(ICKE),
	.RAS_N			(IRAS_N),
	.CAS_N			(ICAS_N),
	.WE_N			(IWE_N)
);

always @(posedge REF_CLK)
begin
	SA      <= (ST==SC_CL+mLENGTH)			?	`ROWSIZE'h200	:	ISA;
    BA      <= IBA;
    CS_N    <= ICS_N;
    CKE     <= ICKE;
    RAS_N   <= (ST==SC_CL+mLENGTH)			?	1'b0	:	IRAS_N;
    CAS_N   <= (ST==SC_CL+mLENGTH)			?	1'b1	:	ICAS_N;
    WE_N    <= (ST==SC_CL+mLENGTH)			?	1'b0	:	IWE_N;
	PM_STOP	<= (ST==SC_CL+mLENGTH)			?	1'b1	:	1'b0;
	PM_DONE	<= (ST==SC_CL+SC_RCD+mLENGTH+2)	?	1'b1	:	1'b0;
	DQM		<= {(`DSIZE/8){1'b0}};	//( active && (ST>=SC_CL) )	?	(((ST==SC_CL+mLENGTH) && Write) ? {(`DSIZE/8){1'b1}} : {(`DSIZE/8){1'b0}}) : {(`DSIZE/8){1'b1}};
//	mDATAOUT<= DQ;
end
//-----------------------------------------
//EM638325 SDRAM_512Kx4x32bit
EG_PHY_SDRAM_2M_32 uSDRAM_512Kx4x32bit
(
	.clk                (SDR_CLK),    //sdram clock
	.cke                (CKE),    //sdram clock enable
	.cs_n               (CS_N),   //sdram chip select
	.ras_n              (RAS_N),  //sdram row address strobe
	.cas_n              (CAS_N),  //sdram column address strobe
	.we_n               (WE_N),   //sdram write enable
	.addr               (SA),     //sdram address[10:0] 
	.ba                 (BA),     //sdram bank address
	.dq                 (DQ),     //sdram data[31:0] 

	.dm0                (DQM[0]), //sdram data enable
	.dm1                (DQM[1]), //sdram data enable
	.dm2                (DQM[2]), //sdram data enable
	.dm3                (DQM[3])  //sdram data enable
);	

endmodule
