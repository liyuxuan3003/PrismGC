module BDMA(input wire clk,rst_n,start,fetch,
            input wire[31:0] Addr,
            input wire HREADY,
            input wire[31:0] HRDATA,
            output wire BReady,
            output reg[1:0] HTRANS,
            output reg[15:0] Buf,
            output reg[31:0] HADDR);

    parameter S0        = 2'b00;
    parameter AddrPhase = 2'b01;
    parameter DataPhase = 2'b10;
    parameter ready     = 2'b11;

    reg[1:0] curr_state,next_state;

    always @(posedge clk) begin
        if(!rst_n)begin
            curr_state <= S0;
            Buf <= 16'b0;
            HADDR <= 32'b0;
        end
        else begin
            curr_state <= next_state;
            HADDR <= Addr;
            if((next_state == ready)&(curr_state == DataPhase))begin
                case(HADDR[1])
                    1'b0: Buf <= HRDATA[15:0];
                    1'b1: Buf <= HRDATA[31:16];
                    default: Buf <= HRDATA[15:0];
                endcase
            end
        end
    end

    always @(*) begin
        case(curr_state)
            S0:begin
                if(start)begin
                    next_state = AddrPhase;
                    HTRANS = 2'b00;
                end
                else begin
                    next_state = S0;
                    HTRANS = 2'b00;
                end
            end
            AddrPhase:begin
                if(HREADY)begin
                    next_state = DataPhase;
                    HTRANS = 2'b10;
                end
                else begin
                    next_state = AddrPhase;
                    HTRANS = 2'b10;
                end
            end
            DataPhase:begin
                if(HREADY)begin
                    next_state = ready;
                    HTRANS = 2'b00;
                end
                else begin
                    next_state = DataPhase;
                    HTRANS = 2'b00;
                end
            end
            ready:begin
                if(fetch)begin
                    next_state = AddrPhase;
                    HTRANS = 2'b00;
                end
                else begin
                    next_state = ready;
                    HTRANS = 2'b00;
                end
            end
            default:begin
                next_state = S0;
                HTRANS = 2'b00;
            end
        endcase
    end

    assign BReady = (curr_state == ready);

endmodule