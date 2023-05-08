module APB_BDMAC(input wire clk,rst_n,
             input wire PWRITE,PSEL,
             input wire Bref,Sref,
             input wire PENABLE,
             input wire[7:0] tune,
             input wire[31:0] PWRDATA,PADDR,
             output reg[31:0] PRDDATA,
             output reg[31:0] BRstAddr,SRstAddr,
             output reg[1:0] SPri,
             output reg isCyl,BisPlaying,Bstop,SisPlaying);

    reg[31:0] PADDR_Reg;
    reg WriteEnb;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            PADDR_Reg  <= 32'b0;
            WriteEnb   <=     0;

            BRstAddr   <= 32'b0;
            SRstAddr   <= 32'b0;
            SPri       <=  2'b0;
            isCyl      <=     0;
            BisPlaying <=     0;
            Bstop      <=     0;
            SisPlaying <=     0;
        end
        else begin
            PADDR_Reg  <= PADDR;
            WriteEnb   <= PSEL&PWRITE;

            if(WriteEnb&PENABLE)begin
                case(PADDR_Reg[3:0])
                    4'h0:begin
                        BRstAddr <= PWRDATA;
                    end
                    4'h4:begin
                        {isCyl,BisPlaying,Bstop} <= PWRDATA[2:0];
                    end
                    4'h8:begin
                        SRstAddr <= PWRDATA;
                    end
                    4'hc:begin
                        {SPri,SisPlaying} <= PWRDATA[2:0];
                    end
                endcase
            end

            if(Bref)begin
                BisPlaying <= isCyl;
            end

            if(Sref)begin
                SisPlaying <= 1'b0;
            end
        end
    end

    always @(*) begin
        case(PADDR_Reg[7:0])
            8'h00:begin
                PRDDATA <= BRstAddr;
            end
            8'h04:begin
                PRDDATA <= {29'b0,isCyl,BisPlaying,Bstop};
            end
            8'h08:begin
                PRDDATA <= SRstAddr;
            end
            8'h0c:begin
                PRDDATA <= {29'b0,SPri,SisPlaying};
            end
            8'h10:begin
                PRDDATA <= {24'b0,tune};
            end
            default:begin
                PRDDATA <= 32'b0;
            end
        endcase
    end

endmodule