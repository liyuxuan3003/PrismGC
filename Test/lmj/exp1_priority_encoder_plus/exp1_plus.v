module priority_encoder(Data,Code,GS,LED);
    input [7:0] Data;           //输入八位数字（0-7）
    output reg [2:0] Code;      //输出三位编码（000-111）
	output GS;                  //状态灯
output [3:0] LED;
    //EG4S20 IO默认弱上拉，因此需要输出低电平熄灭LED6-3
    assign LED = 4'b0;          //赋值四位低电平
    assign GS = Data ? 1'b1 : 1'b0;//状态显示
    always@(Data) begin         //循环判别
        if(Data[7]) Code = 3'b111;
		else if(Data[6]) Code = 3'b110;        
        else if(Data[5]) Code = 3'b101;
        else if(Data[4]) Code = 3'b100;
        else if(Data[3]) Code = 3'b011;
        else if(Data[2]) Code = 3'b010;
        else if(Data[1]) Code = 3'b001;
        else if(Data[0]) Code = 3'b000;
        else Code = 3'b000;
    end      
endmodule
