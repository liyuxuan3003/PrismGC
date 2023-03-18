 module Stopwatch(clk_100,sw,sec_0_01,sec_0_1,sec_1,sec_10,min);
    input clk_100;
	input [1:0] sw;    
    output reg min;
    output reg[3:0] sec_0_01,sec_0_1,sec_1,sec_10;     
 always@(posedge clk_100)//每1/100秒处理计时和设置
	begin
      if (sw[1]==0) //复位
          begin   
                    sec_0_01<=0;
                    sec_0_1<=0;
                    sec_1<=0;                    
					sec_10<=0;  
                     min<=0;               
           end                       
         else if (sw[1]==1)           
           if (sw[0] == 0)         
               sec_0_01 <= sec_0_01;           
             else if (sw[0] == 1)               
			  begin                 
 				sec_0_01 <= sec_0_01 + 1;  
              if (sec_0_01==10)
         		 	begin
            		sec_0_01<=0;
              		sec_0_1<=sec_0_1+1;              
              		 if (sec_0_1 == 9)              
                 		 begin                
                  		   sec_0_1 <= 0;                  
                   		   sec_1 <= sec_1 + 1;                    
                   			 if (sec_1 == 9)              
                     		  begin                
                     		    sec_1 <= 0;                  
                       		    sec_10 <= sec_10 + 1;                            
                     			 if (sec_10 == 5)              
                     			  begin                
                        			 sec_10 <= 0;                  
                        			  min <= min + 1;                         
                         			if (min == 1)                          
                         			   min <= 0;                          										end                          			   
								end 
							end 
						end                                           
 					end                      
 	   end      					
endmodule          