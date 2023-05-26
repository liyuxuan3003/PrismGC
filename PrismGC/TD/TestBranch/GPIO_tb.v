`timescale 10ns/1ns
module GPIO_TB();
    reg                         clk;
    reg                         rstn;
    reg [7:0]                   addrIn;
    reg [7:0]                   addrOut;
    reg [3:0]                   sizeDecode;
    reg [31:0]                  dataIn;
    wire [31:0]                 dataOut;
    wire [31:0]                 ioPin;

    GPIO #(.PORT_NUM(1)) uGPIO 
    (
        .clk(clk),
        .rstn(rstn),
        .addrIn(addrIn),
        .addrOut(addrOut),
        .sizeDecode(sizeDecode),
        .dataIn(dataIn),
        .dataOut(dataOut),
        .ioPin(ioPin)
    );

    assign ioPin=32'hFFFFFFFF;

    initial
    begin 
        clk=0;
        rstn=1;
        addrIn=0;
        addrOut=0;
        sizeDecode=0;
        dataIn=0;
    end

    always #10 clk = ~clk;

    integer i;
    initial 
    begin
        #10;
        addrOut = 2;
        addrIn = 0;
        dataIn = 32'h00550055;
        sizeDecode = 4'b1111;
        #20;
        addrOut = 1;
        addrIn = 2;
        dataIn = 32'h00550055;
        sizeDecode = 4'b1111;
        #20;
        addrOut = 0;
        addrIn = 1;
        dataIn = 32'hFFFFFFFF;
        sizeDecode = 4'b1111;
        #20;
        addrOut = 0;
        addrIn = 0;
        dataIn = 32'hFFFFFFFF;
        sizeDecode = 4'b0000;
        #40;
        $stop;
    end
endmodule