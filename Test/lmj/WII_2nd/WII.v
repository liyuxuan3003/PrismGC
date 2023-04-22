module iic_drive(
input clk,
input reset_n,
// 与控制器通信信号
input   [31:0]      slv_reg0,
input   [31:0]      slv_reg1,
input   [31:0]      slv_reg2,
input   [31:0]      slv_reg3,
input   [31:0]      slv_reg4,
output  reg [ 7:0]  iic_rddb,
output              iic_busy,

// 外部信号
output              iic_scl,
input               iic_sda_in,
output              sda_dir,
output              sda_r
);

//  SCL 分频系数
// 产生IIC时钟  25M/20K = 1250
parameter  SCL_SUM = 13'd1250;

// 仿真时
//parameter  SCL_SUM = 13'd64;

//***************************************************************************************
// iic读写状态机

reg  [12:0]     scl_cnt;
always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
        scl_cnt <= 13'd0;
    else if(scl_cnt < (SCL_SUM - 1))
        scl_cnt <= scl_cnt + 1;
    else
        scl_cnt <= 13'd0;
end 


// 不同的时钟阶段
assign  iic_scl = (scl_cnt <= (SCL_SUM >> 1));                       // 初始为高电平
wire    scl_hs = (scl_cnt == 13'd1);                                // scl high start
wire    scl_hc = (scl_cnt == ((SCL_SUM >> 1)-(SCL_SUM >> 2)));      // scl high center
wire    scl_ls = (scl_cnt == (SCL_SUM >> 1));                       // scl low start
wire    scl_lc = (scl_cnt == ((SCL_SUM >> 1)+(SCL_SUM >> 2)));      // scl low center



//IIC状态机控制信号                
reg     iicwr_req;                                          // IIC写请求信号，高电平有效
reg     iicrd_req;                                          // IIC读请求信号，高电平有效 
reg     [2:0]   bcnt;
wire    [7:0]   slave_addr_w = slv_reg0[7:0];               // slave地址,写数据
wire    [7:0]   slave_addr_r = slv_reg0[7:0]+1;             // slave地址,读数据
wire    [7:0]   reg_addr = slv_reg1[7:0];                   // reg地址
wire    [7:0]   iic_wrdb = slv_reg2[7:0];                   // 待发送的数据 
wire            iic_wr_en = slv_reg3[0];                    // 写使能
wire            iic_rd_en = slv_reg4[0];                    // 读使能

//****************************************************************************
// 读写使能上升沿信号
reg     iic_wr_en_r0,iic_wr_en_r1;
reg     iic_rd_en_r0,iic_rd_en_r1;
always @  (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
    begin
        iic_wr_en_r0 <= 1'b0;
        iic_wr_en_r1 <= 1'b0;
    end 
    else
    begin
        iic_wr_en_r0 <= iic_wr_en;
        iic_wr_en_r1 <= iic_wr_en_r0;
    end 
end 
wire    iic_wr_en_pos = (~iic_wr_en_r1 && iic_wr_en_r0);    // 写使能上升沿

always @  (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
    begin
        iic_rd_en_r0 <= 1'b0;
        iic_rd_en_r1 <= 1'b0;
    end 
    else
    begin
        iic_rd_en_r0 <= iic_rd_en;
        iic_rd_en_r1 <= iic_rd_en_r0;
    end 
end 
wire    iic_rd_en_pos = (~iic_rd_en_r1 && iic_rd_en_r0);    // 读使能上升沿
//****************************************************************************
// IIC状态 
parameter       IDLE        = 4'd0, 
                START0      = 4'd1,
                WRSADDR0    = 4'd2,
                ACK0        = 4'd3,
                WRRADDR     = 4'd4,
                ACK1        = 4'd5,
                WRDATA      = 4'd6,
                ACK2        = 4'd7,
                STOP        = 4'd8,
                START1      = 4'd9,
                WRSADDR1    = 4'd10,
                ACK3        = 4'd11,
                RDDATA      = 4'd12,
                NOACK       = 4'd13;

// 状态跳转
reg [3:0]   c_state;
reg [3:0]   n_state;

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
        c_state <= IDLE;
    else
        c_state <= n_state;
end 

// 组合逻辑触发
always @ (*)
begin
    case(c_state)
        IDLE:       // 初始化
        begin
            if(((iicwr_req == 1'b1)||(iicrd_req == 1'b1))&&(scl_hc == 1'b1))
                n_state = START0;
            else
                n_state = IDLE;
        end 

        START0:     // 起始
        begin
            if(scl_lc == 1'b1)
                n_state = WRSADDR0;
            else
                n_state = START0;
        end 

        WRSADDR0:   // 写slave地址
        begin
            if((scl_lc == 1'b1)&&(bcnt == 3'd0))
                n_state = ACK0;
            else
                n_state = WRSADDR0;
        end 

        ACK0:       // 接收应答
        begin
            if(scl_lc == 1'b1)
                n_state = WRRADDR;
            else
                n_state = ACK0;
        end 

        WRRADDR:    // 写寄存器地址
        begin
            if((scl_lc == 1'b1)&&(bcnt == 3'd0))
                n_state = ACK1;
            else
                n_state = WRRADDR;
        end 

        ACK1:       // 接收应答
        begin
            if(scl_lc == 1'b1)
            begin
                if(iicwr_req == 1'b1)
                    n_state = WRDATA;
                else if(iicrd_req == 1'b1)
                    n_state = START1;
                else
                    n_state = IDLE;
            end 
            else
                n_state = ACK1;
        end 

        //**************
        // 写数据
        WRDATA:
        begin
            if((scl_lc == 1'b1)&&(bcnt == 3'd0))
                n_state = ACK2;
            else
                n_state = WRDATA;
        end 

        ACK2:   // 接收应答
        begin
            if(scl_lc == 1'b1)
                n_state = STOP;
            else
                n_state = ACK2;
        end 

        //**************
        // 读数据过程
        START1:
        begin
            if(scl_lc == 1'b1)
                n_state = WRSADDR1;
            else
                n_state = START1;
        end 

        WRSADDR1:
        begin
            if((scl_lc == 1'b1)&&(bcnt == 3'd0))
                n_state = ACK3;
            else
                n_state = WRSADDR1;
        end 

        ACK3:   // 接收应答    
        begin
            if(scl_lc == 1'b1)
                n_state = RDDATA;
            else
                n_state = ACK3;
        end 

        RDDATA:
        begin
            if((scl_lc == 1'b1)&&(bcnt == 3'd0))
                n_state = NOACK;
            else
                n_state = RDDATA;
        end

        NOACK:  
        begin
            if(scl_lc == 1'b1)
                n_state = STOP;
            else
                n_state = NOACK;
        end 
        //**************

        STOP:
        begin   
            if(scl_lc == 1'b1)
                n_state = IDLE;
            else
                n_state = STOP;
        end 

        default:  n_state = IDLE;  
    endcase 
end 


// 计数器控制
always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
        bcnt <= 3'd0;
    else
    begin
        case (n_state)
            WRSADDR0,WRRADDR,WRDATA,WRSADDR1,RDDATA:
            begin
                if(scl_lc == 1'b1)
                    bcnt <= bcnt + 1;    
            end 
            default: bcnt <= 3'd0;
        endcase 
    end 
end 


reg     sda_dir;        // 控制数据方向,高电平为数据输出
reg     sda_r;          // 输出数据


// 控制数据输出
always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
    begin
        sda_dir <= 1'b1;
        sda_r <= 1'b1;
    end 
    else
    begin
        case (n_state)
            IDLE,NOACK:
            begin
                sda_dir <= 1'b1;
                sda_r <= 1'b1;
            end 

            START0:
            begin
                sda_dir <= 1'b1;
                sda_r <= 1'b0;          // 进入开始状态后,数据拉低
            end 

            START1:
            begin
                sda_dir <= 1'b1;
                if(scl_lc == 1'b1)
                    sda_r <= 1'b1;
                else if(scl_hc == 1'b1)
                    sda_r <= 1'b0;
            end 


            WRSADDR0:
            begin
                sda_dir <= 1'b1;
                if(scl_lc == 1'b1)
                    sda_r <= slave_addr_w[7-bcnt];
            end 

            WRSADDR1:
            begin
                sda_dir <= 1'b1;
                if(scl_lc == 1'b1)
                    sda_r <= slave_addr_r[7-bcnt];
            end 


            ACK0,ACK1,ACK2,ACK3:  sda_dir <= 1'b0;      // 接收总线数据

            WRRADDR:
            begin
                sda_dir <= 1'b1;
                if(scl_lc == 1'b1)
                    sda_r <= reg_addr[7-bcnt];
            end 

            WRDATA:
            begin
                sda_dir <= 1'b1;
                if(scl_lc == 1'b1)
                    sda_r <= iic_wrdb[7-bcnt];
            end 

            RDDATA:
            begin
                sda_dir <= 1'b0;
                if(scl_lc == 1'b1)
                    iic_rddb[7-bcnt] <= iic_sda_in;
            end 

            STOP:
            begin
                sda_dir <= 1'b1;
                if(scl_lc == 1'b1)
                    sda_r <= 1'b0;
                else if(scl_hc == 1'b1)
                    sda_r <= 1'b1;
            end 

        endcase 
    end 
end 
//assign iic_sda = sda_dir ? sda_r : 1’bz;
wire iic_ack = (c_state == STOP) && scl_hc; //IIC操作响应，高电平有效
// 确定读写过程标志
always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
        iicwr_req <= 1'b0;
    else
    begin
        if(iic_wr_en_pos == 1'b1)
            iicwr_req <= 1'b1;
        else if(iic_ack == 1'b1)            // IIC过程结束
            iicwr_req <= 1'b0;    
    end 
end 

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
        iicrd_req <= 1'b0;
    else
    begin
        if(iic_rd_en_pos == 1'b1)
            iicrd_req <= 1'b1;
        else if(iic_ack == 1'b1)            // IIC过程结束
            iicrd_req <= 1'b0;    
    end 
end 

// 当有请求时一直忙,完成过程后忙结束
assign  iic_busy = (iicwr_req || iicrd_req);
endmodule