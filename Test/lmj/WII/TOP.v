module IIC(
  input clk_i,
  input rst_n,//清零信号
  output clk_o // 1 Hz
);
reg state_next;
reg tr_start,ack1,ack2,ack3;
reg sda_en;// 决定双向的输入输出  1 为输出 0 为高阻态 为输入
reg[3:0] cnt_count;
reg sclk,reg_sdat; 
reg[7:0] iic_data;
reg[7:0] iic_cmd_data;// 写入的
reg[3:0] byte_num; // 写入的 第几个字节	
always @(posedge clk_200k or negedge rst_n)
	begin
		if (~rst_n)
			begin
				tr_start <= 1;
				sda_en <= 1;
				ack1 <= 1;
				ack2 <= 1;
				ack3 <= 1;
				sclk <= 1;
				reg_sdat <= 1;
				cnt_count <= 0;
				byte_num <= 0;
				state_next <= 0;
			end
		else
			begin
				cnt_count <= cnt_count + 4'b1;
				case(state_next)
				
				0://空闲状态
					begin
						case (cnt_count)
						11:
							begin
								cnt_count <= 0;
								state_next <= 1;
							end
						default:
							begin
								sclk <= 1;
								reg_sdat <= 1;
							end
						endcase
					end
				1:// 开始传输
					begin
						tr_start <= 1;
						
						case (cnt_count)
						0,1,2:
							begin
								reg_sdat <= 1;
								sclk <= 1;
							end
						
						3,4,5,6,7,8:
							begin
								sclk <= 1;
								reg_sdat <= 0;// 拉低电位 开始传输
							end
						
						9,10:
							begin
								sclk <= 0;
								reg_sdat <= 0;
							end
						default://11
							begin
								sclk <= 0;
								reg_sdat <= 0;
								state_next <= 2;
								cnt_count <= 0; 
							end
						endcase
					end
				  
				2://写入地址
					begin 
						reg_sdat <= address[7-byte_num];
						
						case (cnt_count)
						0,1,2:
							begin
								sclk <= 0;
							end
						
						3,4,5,6,7,8:
							begin
								sclk <= 1;
							end
						
						9,10:
							begin
								sclk <= 0;
							end
						default://11
							begin
								sclk <= 0;
								cnt_count <= 0;
								
								if (byte_num == 7)//写完所有地址位
									begin
										byte_num <= 0;
										state_next <= 3;//进入应答状态
									end
								else
									begin
										byte_num <= byte_num + 1'b1;
									end
							end
						endcase
					end
					
					3://第一个应答信号
						begin
							case (cnt_count)
							0,1,2:
								begin
									reg_sdat <= 1;
									sclk <= 0;
									sda_en <= 0;//高阻态
								end
						
							3,4,5,6,7,8:
								begin
									reg_sdat <= 0;
									sclk <= 1;
									sda_en <= 0;
								end
						
							9,10:
								begin
									sclk <= 0;
									reg_sdat <= 0;
									sda_en <= 0;
									ack1 <= iic_sda;//读取应答信号
								end
							default://11
								begin
									sclk <= 0;
									reg_sdat <= 0;
									sda_en <= 1;//重新变为输出
									state_next <= 4;//下一个状态
									ack1 <= iic_sda;
									cnt_count <= 0;
								end
							endcase
						end
					 
					 4://           第二个数据  读或写
						begin 
						reg_sdat <= iic_cmd_data[7-byte_num];
						
						case (cnt_count)
						0,1,2:
							begin
								sclk <= 0;
							end
						
						3,4,5,6,7,8:
							begin
								sclk <= 1;
							end
						
						9,10:
							begin
								sclk <= 0;
							end
						default://11
							begin
								sclk <= 0;
								cnt_count <= 0;
								
								if (byte_num == 7)//写完所有地址位
									begin
										byte_num <= 0;
										state_next <= 5;//进入应答状态
									end
								else
									begin
										byte_num <= byte_num + 1'b1;
									end
							end
						endcase
					end
						
					5: // 第二个应答信号
						begin
							case (cnt_count)
							0,1,2:
								begin
									reg_sdat <= 0;
									sclk <= 0;
									sda_en <= 0;//高阻态
								end
						
							3,4,5,6,7,8:
								begin
									reg_sdat <= 0;
									sclk <= 1;
									sda_en <= 0;
								end
						
							9,10:
								begin
									sclk <= 0;
									reg_sdat <= 0;
									sda_en <= 0;
									ack2 <= iic_sda;//读取应答信号
								end
							default://11
								begin
									sclk <= 0;
									reg_sdat <= 0;
									sda_en <= 1;//重新变为输出
									state_next <= 6;//下一个状态
									ack2 <= iic_sda;
									cnt_count <= 0;
								end
							endcase
						end
					
					6: //				第三个数据
						begin 
						reg_sdat <= iic_data[7-byte_num];
						
						case (cnt_count)
						0,1,2:
							begin
								sclk <= 0;
							end
						
						3,4,5,6,7,8:
							begin
								sclk <= 1;
							end
						
						9,10:
							begin
								sclk <= 0;
							end
						default://11
							begin
								sclk <= 0;
								cnt_count <= 0;
								
								if (byte_num == 7)//写完所有地址位
									begin
										byte_num <= 0;
										state_next <= 7;//进入应答状态
									end
								else
									begin
										byte_num <= byte_num + 1'b1;
									end
							end
						endcase
					end
					
					7://第三个应答信号
						begin
							tr_start <= 0;
							
							case (cnt_count)
							0,1,2:
								begin
									sclk <= 0;
									sda_en <= 0;//高阻态
								end
						
							3,4,5,6,7,8:
								begin
									sclk <= 1;
									sda_en <= 0;
								end
						
							9,10:
								begin
									sclk <= 0;
									sda_en <= 0;
									ack3 <= iic_sda;//读取应答信号
								end
							default://11
								begin
									sclk <= 0;
									reg_sdat <= 0;
									sda_en <= 1;//重新变为输出
									state_next <= 8;//下一个状态
									ack3 <= iic_sda;
									cnt_count <= 0;
								end
							endcase
						end
					
					8:  //停止
						begin
							case (cnt_count)
						0,1,2:
							begin
								reg_sdat <= 0;
								sclk <= 0;
							end
						
						3,4,5:
							begin
								sclk <= 1;
								reg_sdat <= 0;
							end
						
						6,7,8:
							begin
								sclk <= 1;
								reg_sdat <= 1;//拉高电位结束传输
							end
						9,10:
							begin
								sclk <= 1;
								reg_sdat <= 1;
							end
						default://11
							begin
								sclk <= 1;
								reg_sdat <= 1;
								state_next <= 0;
								cnt_count <= 0;
							end
						endcase
						end
					default: state_next <= 0;
				endcase
		end
	end
				
assign iic_sda = sda_en ? reg_sdat:1'bz;
assign iic_sck = sclk;
endmodule
