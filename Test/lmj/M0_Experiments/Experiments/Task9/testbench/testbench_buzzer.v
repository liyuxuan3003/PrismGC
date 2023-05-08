`timescale 1ps/1ps
module testbench_buzzer();

    reg clk,rst_n,BBDMA_HREADY;
    reg BDMAC_HSEL,BDMAC_HREADY;
    reg[31:0] BDMAC_HADDR,BDMAC_HWDATA;
    reg[1:0] BDMAC_HTRANS;
    reg BDMAC_HWRITE;
    reg[31:0] BBDMA_HRDATA;
    wire PWM;
    wire[31:0] BBDMA_HADDR,SBDMA_HADDR;

    reg[31:0] SBDMA_HRDATA;
    reg SBDMA_HREADY;

    Buzzer #(.isSim(1)) Buzzer(
        .clk(clk),
        .rst_n(rst_n),

        .BDMAC_HSEL(BDMAC_HSEL),
        .BDMAC_HREADY(BDMAC_HREADY),
        .BDMAC_HADDR(BDMAC_HADDR),
        .BDMAC_HTRANS(BDMAC_HTRANS),
        .BDMAC_HWRITE(BDMAC_HWRITE),
        .BDMAC_HWDATA(BDMAC_HWDATA),

        .SBDMA_HRDATA(SBDMA_HRDATA),
        .SBDMA_HREADY(SBDMA_HREADY),
        .SBDMA_HADDR(SBDMA_HADDR),

        .BBDMA_HRDATA(BBDMA_HRDATA),
        .BBDMA_HREADY(BBDMA_HREADY),
        .BBDMA_HADDR(BBDMA_HADDR),

        .PWM(PWM)
    );

    always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

    initial begin
        rst_n = 0;

        BDMAC_HSEL = 0;
        BDMAC_HREADY = 0;
        BDMAC_HADDR = 0;
        BDMAC_HTRANS = 0;
        BDMAC_HWRITE = 0;
        BDMAC_HWDATA = 0;

        BBDMA_HREADY = 0;
        SBDMA_HREADY = 0;
        #10;
        rst_n = 1;

        BDMAC_HSEL = 1;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_0000;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0;

        BBDMA_HREADY = 1;
        SBDMA_HREADY = 1;

        #10;

        BDMAC_HSEL = 1;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_0004;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0000;

        #10;

        BDMAC_HSEL = 0;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_0004;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0002;

        #1400000;

        BDMAC_HSEL = 1;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_0004;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0002;

        #10;

        BDMAC_HSEL = 0;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_0004;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0003;

        #1400000;

        BDMAC_HSEL = 1;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_0004;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0002;

        #10;

        BDMAC_HSEL = 0;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_0004;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0002;

        #10000000;

        BDMAC_HSEL = 1;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_0008;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0000;

        #10;

        BDMAC_HSEL = 1;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_000c;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0000;

        #10;

        BDMAC_HSEL = 0;
        BDMAC_HREADY = 1;
        BDMAC_HADDR = 32'h4000_000c;
        BDMAC_HTRANS = 2'b10;
        BDMAC_HWRITE = 1;
        BDMAC_HWDATA = 32'h0000_0001;


    end

    always @(BBDMA_HADDR) begin
        case(BBDMA_HADDR)
            32'h0000_0000: BBDMA_HRDATA = 32'h0000_0163;
            32'h0000_0002: BBDMA_HRDATA = 32'h0000_0213;
            32'h0000_0004: BBDMA_HRDATA = 32'h0000_0233;
            32'h0000_0006: BBDMA_HRDATA = 32'h0000_0313;
            32'h0000_0008: BBDMA_HRDATA = 32'h0000_0000;
            default:BBDMA_HRDATA = 32'h0000_0213;
        endcase
    end

    always @(SBDMA_HADDR) begin
        case(SBDMA_HADDR)
            32'h0000_0000: SBDMA_HRDATA = 32'h0000_0162;
            default:SBDMA_HRDATA = 32'h0000_0000;
        endcase
    end

endmodule