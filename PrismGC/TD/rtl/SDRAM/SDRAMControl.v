`include "SDRAMParams.v"

module SDRAMControl
(
    // HOST Side
    input                   REF_CLK,            //sdram control clock
    input                   OUT_CLK,            //sdram output clock
    input                   RESET_N,            //System Reset

    // FIFO Write Side 1
    input[`DSIZE-1:0]       WR_DATA,            //Data input
    input                   WR,                 //Write Request
    input[`ASIZE-1:0]       WR_MIN_ADDR,        //Write start address
    input[`ASIZE-1:0]       WR_MAX_ADDR,        //Write max address
    input[23:0]             WR_LENGTH,          //Write length
    input                   WR_LOAD,            //Write register load & fifo clear
    input                   WR_CLK,             //Write fifo clock
    output                  WR_EMPTY,
    output                  WR_FULL,
    output                  WR_AFULL,           //--
    output                  WR_REQ,
    output                  WR_DONE,

    // FIFO Read Side 1
    output[`DSIZE-1:0]      RD_DATA,            //Data output
    input                   RD,                 //Read Request
    input[`ASIZE-1:0]       RD_MIN_ADDR,        //Read start address
    input[`ASIZE-1:0]       RD_MAX_ADDR,        //Read max address
    input[10:0]             RD_LENGTH,          //Read length
    input                   RD_LOAD,            //Read register load & fifo clear
    input                   RD_CLK,             //Read fifo clock

    // SDRAM Side
    inout[`DSIZE-1:0]       DQ,                 //SDRAM data bus NOT USE

    //User interface
    output                  sysVaild,           //SDRAM Init done signal
    input                   sysReadVaild,       //SDRAM Read valid : output
    input[7:0]              sysWriteRefresh
);


//	Internal Registers/Wires
//	Controller
reg[`ASIZE-1:0]         mADDR;                  //Internal address
reg[8:0]                mLENGTH;                //Internal length
reg[`ASIZE-1:0]         rWR_ADDR;               //Register write address    
reg[`ASIZE-1:0]         rRD_ADDR;               //Register read address
reg                     WR_MASK;                //Write port active mask
reg                     RD_MASK;                //Read port active mask
reg                     mWR_DONE;               //Flag write done, 1 pulse SDR_CLK
reg                     mRD_DONE;               //Flag read done, 1 pulse SDR_CLK
reg                     mWR,Pre_WR;             //Internal WR edge capture
reg                     mRD,Pre_RD;             //Internal RD edge capture
reg[9:0]                ST;                     //Controller status
reg[1:0]                CMD;                    //Controller command
reg                     PM_STOP;                //Flag page mode stop
reg                     PM_DONE;                //Flag page mode done
reg                     Read;                   //Flag read active
reg                     Write;                  //Flag write active
wire[`DSIZE-1:0]        mDATAIN;                //Controller Data input
wire[`DSIZE-1:0]        mDATAIN1;               //Controller Data input 1
wire                    CMDACK;                 //Controller command acknowledgement

// DRAM Control
reg[`DSIZE/8-1:0]       DQM;                    //SDRAM data mask lines
reg[`ROWSIZE -1:0]      SA;                     //SDRAM address output
reg[1:0]                BA;                     //SDRAM bank address
reg                     CS_N;                   //SDRAM Chip Selects
reg                     CKE;                    //SDRAM clock enable
reg                     RAS_N;                  //SDRAM Row address Strobe
reg                     CAS_N;                  //SDRAM Column address Strobe
reg                     WE_N;                   //SDRAM write enable
wire[`DSIZE-1:0]        DQOUT;                  //SDRAM data out link
wire[`ROWSIZE-1:0]      ISA;                    //SDRAM address output
wire[1:0]               IBA;                    //SDRAM bank address
wire                    ICS_N;                  //SDRAM Chip Selects
wire                    ICKE;                   //SDRAM clock enable
wire                    IRAS_N;                 //SDRAM Row address Strobe
wire                    ICAS_N;                 //SDRAM Column address Strobe
wire                    IWE_N;                  //SDRAM write enable
// FIFO Control
reg                     OUT_VALID;              //Output data request to read side fifo
reg                     IN_REQ;                 //Input data request to write side fifo
wire[`FIFO_DEPTH-1:0]   write_side_fifo_rusedw1;
wire[`FIFO_DEPTH-1:0]   read_side_fifo_wusedw1;


// DRAM Internal Control
wire[`ASIZE-1:0]        saddr;
wire                    load_mode;
wire                    nop;
wire                    reada;
wire                    writea;
wire                    refresh;
wire                    precharge;
wire                    oe;
wire                    ref_ack;
wire                    ref_req;
wire                    init_req;
wire                    cm_ack;

control_interface uControl 
(
    .CLK(REF_CLK),
    .RESET_N(RESET_N),
    .CMD(CMD),
    .ADDR(mADDR),
    .REF_ACK(ref_ack),
    .CM_ACK(cm_ack),
    .NOP(nop),
    .READA(reada),
    .WRITEA(writea),
    .REFRESH(refresh),
    .PRECHARGE(precharge),
    .LOAD_MODE(load_mode),
    .SADDR(saddr),
    .REF_REQ(ref_req),
    .INIT_REQ(init_req),
    .CMD_ACK(CMDACK),
    .Sdram_Init_Done(sysVaild)
);

command uCommand
(
    .CLK(REF_CLK),
    .RESET_N(RESET_N),
    .SADDR(saddr),
    .NOP(nop),
    .READA(reada),
    .WRITEA(writea),
    .REFRESH(refresh),
    .LOAD_MODE(load_mode),
    .PRECHARGE(precharge),
    .REF_REQ(ref_req),
    .INIT_REQ(init_req),
    .REF_ACK(ref_ack),
    .CM_ACK(cm_ack),
    .OE(oe),
    .PM_STOP(PM_STOP),
    .PM_DONE(PM_DONE),
    .SA(ISA),
    .BA(IBA),
    .CS_N(ICS_N),
    .CKE(ICKE),
    .RAS_N(IRAS_N),
    .CAS_N(ICAS_N),
    .WE_N(IWE_N)
);

//EM638325 SDRAM_512Kx4x32bit
EG_PHY_SDRAM_2M_32 uSDRAM
(
    .clk(OUT_CLK),
    .ras_n(RAS_N),
    .cas_n(CAS_N),
    .we_n(WE_N),
    .addr(SA),
    .ba(BA),
    .dq(DQ),
    .cs_n(CS_N),
    .dm0(DQM[0]),
    .dm1(DQM[1]),
    .dm2(DQM[2]),
    .dm3(DQM[3]),
    .cke(CKE)
);
		
// wire    wfifo_afull_flag;

// EG_LOGIC_FIFO #(
//  	.DATA_WIDTH_W(32),
// 	.DATA_WIDTH_R(32),
// 	.DATA_DEPTH_W(1024),
// 	.DATA_DEPTH_R(1024),
// 	.ENDIAN("BIG"),
// 	.RESETMODE("ASYNC"),
// 	.E(0),
// 	.F(1024),
// 	.ASYNC_RESET_RELEASE("SYNC"),
// 	.AF(8)
// ) 
// uWriteFIFO
// (
// 	.rst(~RESET_N | WR_LOAD),
// 	.di(WR_DATA),
// 	.clkw(WR_CLK),
// 	.we(WR),
// 	.csw(3'b111),
// 	.do(mDATAIN1),
// 	.clkr(REF_CLK),
// 	.re(IN_REQ & WR_MASK),
// 	.csr(3'b111),
// 	.ore(1'b0),
// 	.empty_flag(WR_EMPTY),
// 	.aempty_flag(),
// 	.full_flag(WR_FULL),
// 	.afull_flag(wfifo_afull_flag)
// );

assign WR_REQ = IN_REQ & WR_MASK;
assign WR_DONE = mWR_DONE;

// assign WR_AFULL = wfifo_afull_flag;
				
assign	mDATAIN	= (WR_MASK) ? WR_DATA : {`DSIZE-1{1'b1}};

wire    rfifo_aempty_flag;  //rrusede < 256

EG_LOGIC_FIFO #(
 	.DATA_WIDTH_W(32),
	.DATA_WIDTH_R(32),
	.DATA_DEPTH_W(2048),
	.DATA_DEPTH_R(2048),
	.ENDIAN("BIG"),
	.RESETMODE("ASYNC"),
	.E(0),
	.F(2048),
	.ASYNC_RESET_RELEASE("SYNC"),
	.AE(1792)
)
uReadFIFO
(
	.rst(~RESET_N | RD_LOAD),
	.di(DQ),
	.clkw(REF_CLK),
	.we(OUT_VALID & RD_MASK),
	.csw(3'b111),
	.do(RD_DATA),
	.clkr(RD_CLK),
	.re(RD),
	.csr(3'b111),
	.ore(1'b0),
	.empty_flag(),
	.aempty_flag(rfifo_aempty_flag),
	.full_flag(),
	.afull_flag()
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
	DQM		<= {(`DSIZE/8){1'b0}};
end

assign	DQOUT = mDATAIN;
assign  DQ = oe ? DQOUT : `DSIZE'hzzzz;

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
            0: begin
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
reg	[`ASIZE-1:0]	WR_MIN_REG;
reg	[`ASIZE-1:0]	WR_MAX_REG;
always@(posedge REF_CLK or negedge RESET_N)
begin
	if(!RESET_N)
    begin	
        WR_MIN_REG <= WR_MIN_ADDR;
        WR_MAX_REG <= WR_MAX_ADDR;
        rWR_ADDR <= WR_MIN_ADDR;
    end
	else if(WR_LOAD)
    begin	
        WR_MIN_REG <= WR_MIN_ADDR;
        WR_MAX_REG <= WR_MAX_ADDR;
        rWR_ADDR <= WR_MIN_ADDR;
    end
	else if(mWR_DONE & WR_MASK)
    begin
        if(rWR_ADDR < WR_MAX_REG - WR_LENGTH)
            rWR_ADDR	<=	rWR_ADDR + WR_LENGTH;
        else
        begin	
            WR_MIN_REG <= WR_MIN_ADDR;
            WR_MAX_REG <= WR_MAX_ADDR;
            rWR_ADDR <= WR_MIN_ADDR;
        end
    end
	else
		rWR_ADDR <= rWR_ADDR;
end

//------------------------------------------------------------------------------------------------
//	Internal Address & Length Control for Read
reg	[`ASIZE-1:0]	RD_MIN_REG;
reg	[`ASIZE-1:0]	RD_MAX_REG;
always@(posedge REF_CLK or negedge RESET_N)
begin
	if(!RESET_N)
    begin	
        RD_MIN_REG <= RD_MIN_ADDR;
        RD_MAX_REG <= RD_MAX_ADDR;
        rRD_ADDR <= RD_MIN_ADDR;
    end
	else if(RD_LOAD)
    begin
        RD_MIN_REG <= RD_MIN_ADDR;
        RD_MAX_REG <= RD_MAX_ADDR;
        rRD_ADDR <= RD_MIN_ADDR;
    end
	else if(mRD_DONE & RD_MASK)
    begin
        if(rRD_ADDR < RD_MAX_REG - RD_LENGTH)
            rRD_ADDR	<=	rRD_ADDR + RD_LENGTH;
        else
        begin
            RD_MIN_REG <= RD_MIN_ADDR;
            RD_MAX_REG <= RD_MAX_ADDR;
            rRD_ADDR <= RD_MIN_ADDR;
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
			if((rfifo_aempty_flag == 1'b1) && (RD_LOAD==0) && (sysReadVaild == 1'b1))	//read fifo
			begin
				mADDR	<=	rRD_ADDR;
				mLENGTH	<=	RD_LENGTH;
				WR_MASK	<=	0;
				RD_MASK	<=	1;
				mWR		<=	0;
				mRD		<=	1;				
			end
            else if(WR_LENGTH && (WR_LOAD==0))
            begin
                mADDR	<=	rWR_ADDR;
				mLENGTH	<=	WR_LENGTH;
				WR_MASK	<=	1;
				RD_MASK	<=	0;
				mWR		<=	1;
				mRD		<=	0;
            end
			// else if( (wfifo_afull_flag == 1'b1 ) && (WR_LOAD==0))	//write fifo
			// begin
			// 	mADDR	<=	rWR_ADDR;
			// 	mLENGTH	<=	WR_LENGTH;
			// 	WR_MASK	<=	1;
			// 	RD_MASK	<=	0;
			// 	mWR		<=	1;
			// 	mRD		<=	0;
			// end

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

endmodule
