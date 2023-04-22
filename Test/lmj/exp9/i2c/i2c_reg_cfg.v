//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           i2c_dri
// Last modified Date:  2020/05/28 20:28:08
// Last Version:        V1.0
// Descriptions:       IIC驱动
//                      
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2020/05/28 20:28:08
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module i2c_reg_cfg (
    input                clk      ,     // i2c_reg_cfg驱动时钟
    input                rst_n    ,     // 复位信号
    input                i2c_done ,     // I2C一次操作完成反馈信号
	output  reg          i2c_rh_wl,     // I2C读写控制
    output  reg          i2c_exec ,     // I2C触发执行信号
    output  reg          cfg_done ,     // 音频芯片配置完成
    output  reg  [15:0]  i2c_data       // 寄存器数据（8位地址+8位数据）
);

//parameter define
// word length音频字长参数设置,可选位数:16,18,20,24,32
parameter  WL           = 6'd16;        

localparam REG_NUM      = 6'd29;        // 总共需要配置的寄存器个数
localparam PHONE_VOLUME = 6'd30;        // 耳机输出音量大小参数（0~33）
localparam SPEAK_VOLUME = 6'd30;        // 喇叭输出音量大小参数（0~33）

//reg define
reg    [2:0]  wl            ;           // word length音频字长参数定义
reg    [7:0]  start_init_cnt;           // 初始化延时计数器
reg    [5:0]  init_reg_cnt  ;           // 寄存器配置个数计数器
reg    [23:0] cnt_delay     ;

//*****************************************************
//**                    main code
//*****************************************************

//音频字长（位数）参数设置,可选位数:16,18,20,24,32
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        wl <= 3'b00;
    else begin
        case(WL)
            6'd16:  wl <= 3'b011; 
            6'd18:  wl <= 3'b010; 				
            6'd20:  wl <= 3'b001; 
            6'd24:  wl <= 3'b000; 
            6'd32:  wl <= 3'b100; 
            default: wl <= 3'b000;
        endcase
    end
end

//上电或复位后延时一段时间
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        start_init_cnt <= 8'd0;
    else if(start_init_cnt < 8'hff)
        start_init_cnt <= start_init_cnt + 1'b1;
end

//触发I2C操作
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        i2c_exec <= 1'b0;
	 else if(cfg_done == 1 && i2c_rh_wl ==0)
        i2c_exec <= 1'b1; 
	 else if(init_reg_cnt == 2 && cnt_delay ==800_000 )  //延时拉高i2c_exec信号
        i2c_exec <= 1'b1;		
    else if(init_reg_cnt == 5'd0 & start_init_cnt == 8'hfe)
        i2c_exec <= 1'b1;
    else if(i2c_done && init_reg_cnt < REG_NUM  &&  init_reg_cnt != 2)
        i2c_exec <= 1'b1;
    else
        i2c_exec <= 1'b0;
end

//配置寄存器计数
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        init_reg_cnt <= 5'd0;
	 else if(cfg_done == 1 && i2c_rh_wl ==0)
        init_reg_cnt <= 5'd0;	 
    else if(i2c_exec)
        init_reg_cnt <= init_reg_cnt + 1'b1;
end

//寄存器配置完成信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cfg_done <= 1'b0;
    else if(i2c_done & (init_reg_cnt == REG_NUM) )
        cfg_done <= 1'b1;
	 else
        cfg_done <= 1'b0;	 
end

//控制读写控制位
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        i2c_rh_wl <= 1'b0;
    else if(cfg_done )
        i2c_rh_wl <= 1'b1;
	 else
        i2c_rh_wl <= i2c_rh_wl;	 
end

//延时计数器计数
always @(posedge clk or negedge rst_n) begin
    if(!rst_n )
        cnt_delay <= 1'b0;
    else if(cfg_done )
        cnt_delay <= 1'b0;		  
    else if(init_reg_cnt == 2)
        cnt_delay <= cnt_delay + 1;
	 else
        cnt_delay <= cnt_delay;	 
end

//配置I2C器件内寄存器地址及其数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        i2c_data <= 16'b0;
    else begin
        case(init_reg_cnt)
            // R0,Bit[7] 1:软复位 ES8388 0:正常
            6'd0 : i2c_data <= {8'd0 ,8'h80};  	
            6'd1 : i2c_data <= {8'd0 ,8'h00};  //结束复位后进行延时
            
            6'd2 : i2c_data <= {8'd1 ,8'h58};            
            6'd3 : i2c_data <= {8'd1 ,8'h50};
            // R2,器件电源管理配置
            6'd4 : i2c_data <= {8'd2 ,8'hf3};
            6'd5 : i2c_data <= {8'd2 ,8'h00};	
		
			// R3,ADC电源管理，Bit[3] 1:麦克风偏置电源关闭
            6'd6: i2c_data <=  {8'd3 ,8'h09};
            // R0,使能参考 500K驱动使能            
            6'd7 : i2c_data <= {8'd0 ,8'h06};

            // R4,DAC电源管理和输出通道配置
            6'd8 : i2c_data <= {8'd4 ,8'h3c};
            // R8,Bit[7] 0:Slave模式, Bit[6] 0:MCLK不分频
            6'd9 : i2c_data <= {8'd8,8'h00};
            // R9,ADC L/R Mic增益配置为+21dB
            6'd10 : i2c_data <= {8'd9,8'h77};
            // R10,ADC 输入通道选择L/R	INPUT1
            6'd11: i2c_data <= {8'd10,8'h00};
            // R12,ADC 数据选择为left data = left ADC, right data = left ADC 
                       //左右通道正常极性,音频数据位宽=wl,数据格式=I2S
            6'd12: i2c_data <= {8'd12,2'b01,1'b0,wl,2'b0};				
            // R13,single speed mode, MCLK/采样率=256
            6'd13: i2c_data <= {8'd13,8'h0c};
            // R16,ADC数字音量控制将信号衰减 L	设置为最小
            6'd14 : i2c_data <= {8'd16 ,8'h00};
            // R17,ADC数字音量控制将信号衰减 R	设置为最小
            6'd15: i2c_data <=  {8'd17 ,8'h00};			
            // R18,ALC设置 Bit[7:6]: ALC打开,max PGA gain:11.5dB, min PGA gain:+6dB
            6'd16: i2c_data <=  {8'd18 ,2'b11,3'b011,3'b011};
            // R23,DAC 音频数据=wl, 数据格式=I2S    
            6'd17 : i2c_data <= {8'd23,2'b0,wl,3'b0};		
            // R24,DAC	配置 MCLK/采样率=256
            6'd18: i2c_data <= {8'd24,8'h0c};
            // R26,DAC数字音量控制将信号衰减 L	设置为最小       
            6'd19: i2c_data <= {8'd26,8'h0a};
            // R27,DAC数字音量控制将信号衰减 R	设置为最小
            6'd20: i2c_data <= {8'd27,8'h0a         };
            // R29,3D环绕设置        
            6'd21: i2c_data <= {8'd29,8'h1c          };
            // R39,L混频器        
            6'd22: i2c_data <= {8'd39,8'hf8          };	
            // R42,R混频器              
            6'd23 : i2c_data <= {8'd42,8'hf8};
            // R43,Bit[7] 1:DACLRC和ADCLRC共用              
            6'd24 : i2c_data <= {8'd43,8'h80};				
            // R46 R47设置耳机音量
            6'd25: i2c_data <= {8'd46,2'b0,PHONE_VOLUME};		
            6'd26: i2c_data <= {8'd47,2'b0,PHONE_VOLUME};
            // R48 R49设置喇叭音量					
            6'd27: i2c_data <= {8'd48,2'b0,SPEAK_VOLUME};				
            6'd28: i2c_data <= {8'd49,2'b0,SPEAK_VOLUME};		
            default : ;
        endcase
    end
end

endmodule 
