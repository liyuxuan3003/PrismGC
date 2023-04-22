module IIC_module(
						input clk,
						input rst_n,
						output SCL,
						inout SDA,
						input [1:0] iCall,
						input [7:0] idata,
						input [7:0] iAddr,
						output [7:0] odata,
						output oDone
					);
	parameter FCLK = 10'd125, FHALF = 10'd62, FQUARTER = 10'd31; //(1/400E+3)/(1/50E+6)
	parameter THIGH = 10'd30, TLOW = 10'd65, TR = 10'd15, TF = 10'd15;
	parameter THD_STA = 10'd30, TSU_STA = 10'd30, TSU_STO = 10'd30;
	parameter WRFUNC1 = 5'd7;
	parameter WRFUNC2 = 5'd9, RDFUNC = 5'd19;
	reg isOut;
	reg [9:0]  count_T;
	reg [4:0] i,Go;
	reg rSCL;
	reg rSDA;
	reg [7:0] data;
	reg Done;
	reg ACK;
	
always @ ( posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			{rSCL,rSDA,Done,ACK,isOut} <= 5'b11011;
			count_T <= 10'd0;
			data <= 8'd0;
			{i,Go} <= 10'd0;
		end
	else if(iCall[1])
			case(i)
				0:
					begin
						isOut = 1'b1;
						rSCL <= 1'b1;
						if(count_T == 0)
							begin
								rSDA <= 1'b1;
							end
						else if(count_T == (TR + THIGH)) rSDA <= 1'b0;
						 
						if(count_T == (FCLK)-1)
							begin
								i <= i + 1'b1;
								count_T <= 10'd0;
							end
						else
							begin
								count_T <= count_T + 1'b1;
							end
					end
				1://write device address
					begin
						data <= {4'b1010, 3'b000, 1'b0};
						i <= 5'd7;
						Go <= i + 1'b1;
					end
				2:
					begin
						data <= iAddr;
						i <= 5'd7;
						Go <= i + 1'b1;
					end
				3:
					begin
						data <= idata;
						i <= 5'd7;
						Go <= i + 1'b1;
					end
				4:
					begin
						isOut = 1'b1;
						
						if(count_T==0) rSCL <= 1'b1;
							else	if(count_T == FQUARTER) rSCL <= 1'b1;
						if(count_T == 0)	rSDA <= 1'b0;
						else	if(count_T == FQUARTER + TR + TSU_STO) rSDA <= 1'b1;
						if(count_T == FQUARTER+FCLK-1)
							begin
								count_T <= 1'b0;
								i <= i + 1'b1;
							end
						else
							count_T <= count_T + 1'b1;
					end
				5:
					begin
						Done <= 1'b1;
						i <= i + 1'b1;
					end
				6:
					begin
						Done <= 1'b0;
						i <= 5'd0;
					end
				7,8,9,10,11,12,13,14:
					begin
						isOut = 1'b1;
						rSDA <=data[14-i];
						if(count_T == 0 ) rSCL <= 1'b0;
						else if(count_T == TF + TLOW ) rSCL <= 1'b1;
						
						if(count_T == FCLK -1 )
							begin
								i <= i+1'b1;
								count_T <= 1'b0;
							end
						else count_T <= count_T + 1'b1; 	
					end
				15:
					begin
						isOut = 1'b0;
						if(count_T == 0 ) rSCL <= 1'b0;
						else if(count_T == FHALF) rSCL <= 1'b1;
						if(count_T == FHALF) ACK <= SDA;
						if(count_T == FCLK -1 )
							begin
								i <= i+1'b1;
								count_T <= 10'b0;
							end
						else count_T <= count_T + 1'b1; 
					end
				16:
					begin
						if(ACK != 0)
							i <= 5'd0;
						else
							i <= Go;
					end
			endcase
		else if (iCall[0])
				case(i)
					0:
						begin
							isOut = 1'b1;
							rSCL <= 1'b1;
							if(count_T == 0)
								begin
									rSDA <= 1'b1;
								end
							else if(count_T == (TR + THIGH)) rSDA <= 1'b0;
							
							if(count_T == (FCLK)-1)
								begin
									i <= i + 1'b1;
									count_T <= 10'd0;
								end
							else
								begin
									count_T <= count_T + 1'b1;
								end
						end
					1:
						begin		
							data <= {4'b1010, 3'b000, 1'b0};
							i <= 5'd9;
							Go <= i + 1'b1; 
						end
					2:
						begin
							data <= iAddr;
							i <= 5'd9;
							Go <= i + 1'b1;
						end
					3://start again
						begin
							isOut = 1'b1;
							if(count_T == 0)
								begin
									rSCL <= 1'b0;
								end
							else if(count_T == FQUARTER) rSCL <= 1'b1;
							else if(count_T == FQUARTER+TR+THD_STA+TSU_STA+TF) rSCL <= 1'b0;
							
							if(count_T == 0) rSDA <= 1'b0;
							else if(count_T==FQUARTER) rSDA <= 1'b1;
							else if(count_T == FQUARTER + TR + THIGH ) rSDA <= 1'b0;
							
							if(count_T == FQUARTER+FCLK+FQUARTER-1)
								begin
									i <= i + 1'b1;
									count_T <= 10'd0;
								end
							else count_T <= count_T + 1'b1;
						end
					4:
						begin
							data <= {4'b1010, 3'b000, 1'b1}; i <= 5'd9; Go <= i + 1'b1; 
						end
					5:
						begin
							data <= 8'd0;
							i <= RDFUNC;
							Go <= i + 1'b1;
						end
					6:
						begin
					     isOut = 1'b1;
					 
                    if( count_T == 0 ) rSCL <= 1'b0;
					     else if( count_T == FQUARTER ) rSCL <= 1'b1; 
		                  
						  if( count_T == 0 ) rSDA <= 1'b0;
						  else if( count_T == (FQUARTER + TR + TSU_STO) ) rSDA <= 1'b1;					 	  
						  
						  if( count_T == (FCLK + FQUARTER) -1 ) begin count_T <= 10'd0; i <= i + 1'b1; end
						  else count_T <= count_T + 1'b1; 
					 end
					 
					 7:
					 begin Done <= 1'b1; i <= i + 1'b1; end
					 
					 8: 
					 begin Done <= 1'b0; i <= 5'd0; end
					9,10,11,12,13,14,15,16:
					begin
						isOut = 1'b1;
						rSDA <=data[16-i];
						if(count_T == 0 ) rSCL <= 1'b0;
						else if(count_T == TF + TLOW ) rSCL <= 1'b1;
						
						if(count_T == FCLK -1 )
							begin
								i <= i+1'b1;
								count_T <= 1'b0;
							end
						else count_T <= count_T + 1'b1; 	
					end
					17:
						begin
							isOut = 1'b0;
							if(count_T == 0 ) rSCL <= 1'b0;
							else if(count_T == FHALF) rSCL <= 1'b1;
							if(count_T == FHALF) ACK <= SDA;
							if(count_T == FCLK -1 )
								begin
									i <= i+1'b1;
									count_T <= 1'b0;
								end
							else count_T <= count_T + 1'b1; 
						end
					18:
						begin
							if(ACK != 0)
								i <= 5'd0;
							else
								i <= Go;
						end
					19,20,21,22,23,24,25,26:
						begin
							isOut = 1'b0;
							if(count_T == FHALF) data[26-i] <= SDA;
							if(count_T == 0) rSCL <= 1'b0;
								else if(count_T == FHALF) rSCL <= 1'b1;
							if(count_T == FCLK -1 )
							begin
								i <= i+1'b1;
								count_T <= 1'b0;
							end
						else count_T <= count_T + 1'b1; 	
						end
					27:
						begin
							isOut = 1'b1;
							if(count_T == 0) rSCL <= 1'b0;
								else if(count_T == FHALF) rSCL <= 1'b1;
							if(count_T == FCLK -1 )
							begin
								i <= Go;
								count_T <= 1'b0;
							end
						else count_T <= count_T + 1'b1; 
						end
		endcase

assign SDA=isOut?rSDA:1'bz;
assign SCL = rSCL;
assign oDone= Done;
assign odata = data;


endmodule
