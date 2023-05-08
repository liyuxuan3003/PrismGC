module BDMAC(input wire clk,rst_n,
             input wire HWRITE,HREADY,HSEL,
             input wire Bref,Sref,
             input wire[1:0] HTRANS,
             input wire[31:0] HWRDATA,HADDR,
             output reg[31:0] HRDDATA,
             output reg[31:0] BRstAddr,SRstAddr,
             output reg[1:0] SPri,
             output reg isCyl,BisPlaying,Bstop,SisPlaying);

    reg[31:0] HADDR_Reg;
    reg WriteEnb;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            HADDR_Reg  <= 32'b0;
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
            HADDR_Reg  <= HADDR;
            WriteEnb   <= HTRANS[1]&HSEL&HREADY&HWRITE;

            if(WriteEnb)begin
                case(HADDR_Reg[3:0])
                    4'h0:begin
                        BRstAddr <= HWRDATA;
                    end
                    4'h4:begin
                        {isCyl,BisPlaying,Bstop} <= HWRDATA[2:0];
                    end
                    4'h8:begin
                        SRstAddr <= HWRDATA;
                    end
                    4'hc:begin
                        {SPri,SisPlaying} <= HWRDATA[2:0];
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
        case(HADDR_Reg[3:0])
            4'h0:begin
                HRDDATA <= BRstAddr;
            end
            4'h4:begin
                HRDDATA <= {29'b0,isCyl,BisPlaying,Bstop};
            end
            4'h8:begin
                HRDDATA <= SRstAddr;
            end
            4'hc:begin
                HRDDATA <= {29'b0,SPri,SisPlaying};
            end
            default:begin
                HRDDATA <= 32'b0;
            end
        endcase
    end

endmodule