module priority_encoder(Data,GS,Code,LED);
    input [3:0] Data;
    output reg [1:0] Code;
    output GS;    
    output [4:0] LED;
    //EG4S20 IO默认弱上拉，因此需要输出低电平熄灭LED7-3
    assign LED = 5'b0;
    assign GS = Data ? 1'b1 : 1'b0;
    always@(Data)
        casex(Data)
            4'b1xxx : Code = 2'b11;
            4'b01xx : Code = 2'b10;
            4'b001x : Code = 2'b01;
            4'b0001 : Code = 2'b00;
            default : Code = 2'b00;
        endcase            
endmodule
