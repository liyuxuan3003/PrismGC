module BuzzerCtr(input wire clk,rst_n,
                 input wire isPlaying,BeatFinish,BReady,stop,
                 input wire[15:0] Buf,
                 output reg AddrCntRstn,AddrCntEn,
                 output reg BeatCntRstn,BeatCntEn,
                 output reg TunePWMRstn,
                 output wire TunePWMEn,
                 output reg BDMAstart,BDMARstn,BDMAAddrSel,fetch,
                 output reg ref);

    parameter S0       = 3'b000;
    parameter ReadNMov = 3'b001;
    parameter PLAY     = 3'b010;
    parameter STOP     = 3'b011;
    parameter STAY     = 3'b100;
    parameter MOVE     = 3'b101;

    reg[2:0] curr_state,next_state;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            curr_state <= S0;
        end
        else begin
            curr_state <= next_state;
        end
    end

    always @(*) begin
        case(curr_state)
            S0:begin
                if(isPlaying)begin
                    next_state = ReadNMov;

                    AddrCntRstn = 0;
                    AddrCntEn   = 0;
                    BeatCntRstn = 0;
                    BeatCntEn   = 0;
                    TunePWMRstn = 0;
                    BDMAstart   = 1;
                    BDMARstn    = 1;
                    BDMAAddrSel = 0;
                    fetch       = 0;
                    ref         = 0;
                end
                else begin
                    next_state = S0;

                    AddrCntRstn = 0;
                    AddrCntEn   = 0;
                    BeatCntRstn = 0;
                    BeatCntEn   = 0;
                    TunePWMRstn = 0;
                    BDMAstart   = 0;
                    BDMARstn    = 0;
                    BDMAAddrSel = 0;
                    fetch       = 0;
                    ref         = 0;
                end
            end
            ReadNMov:begin
                if(isPlaying)begin
                    if(BReady)begin
                        next_state = PLAY;

                        AddrCntRstn = 1;
                        AddrCntEn   = 0;
                        BeatCntRstn = 0;
                        BeatCntEn   = 0;
                        TunePWMRstn = 0;
                        BDMAstart   = 0;
                        BDMARstn    = 1;
                        BDMAAddrSel = 1;
                        fetch       = 1;
                        ref         = 0;
                    end
                    else begin
                        next_state = ReadNMov;

                        AddrCntRstn = 1;
                        AddrCntEn   = 0;
                        BeatCntRstn = 0;
                        BeatCntEn   = 0;
                        TunePWMRstn = 0;
                        BDMAstart   = 0;
                        BDMARstn    = 1;
                        BDMAAddrSel = 0;
                        fetch       = 0;
                        ref         = 0;
                    end
                end
                else begin
                    next_state = S0;

                    AddrCntRstn = 0;
                    AddrCntEn   = 0;
                    BeatCntRstn = 0;
                    BeatCntEn   = 0;
                    TunePWMRstn = 0;
                    BDMAstart   = 0;
                    BDMARstn    = 0;
                    BDMAAddrSel = 0;
                    fetch       = 0;
                    ref         = 0;
                end
            end
            PLAY:begin
                if(isPlaying)begin
                    if(!stop)begin
                        if(BeatFinish)begin
                            next_state = STAY;

                            AddrCntRstn = 1;
                            AddrCntEn   = 0;
                            BeatCntRstn = 0;
                            BeatCntEn   = 0;
                            TunePWMRstn = 0;
                            BDMAstart   = 0;
                            BDMARstn    = 1;
                            BDMAAddrSel = 1;
                            fetch       = 0;
                            ref         = 0;
                        end
                        else begin
                            next_state = PLAY;
                            
                            AddrCntRstn = 1;
                            AddrCntEn   = 0;
                            BeatCntRstn = 1;
                            BeatCntEn   = 1;
                            TunePWMRstn = 1;
                            BDMAstart   = 0;
                            BDMARstn    = 1;
                            BDMAAddrSel = 1;
                            fetch       = 0;
                            ref         = 0;
                        end
                    end
                    else begin
                        next_state = STOP;

                        AddrCntRstn = 1;
                        AddrCntEn   = 0;
                        BeatCntRstn = 1;
                        BeatCntEn   = 0;
                        TunePWMRstn = 1;
                        BDMAstart   = 0;
                        BDMARstn    = 1;
                        BDMAAddrSel = 1;
                        fetch       = 0;
                        ref         = 0;
                    end
                end
                else begin
                    next_state = S0;

                    AddrCntRstn = 0;
                    AddrCntEn   = 0;
                    BeatCntRstn = 0;
                    BeatCntEn   = 0;
                    TunePWMRstn = 0;
                    BDMAstart   = 0;
                    BDMARstn    = 0;
                    BDMAAddrSel = 0;
                    fetch       = 0;
                    ref         = 0;
                end
            end
            STOP:begin
                if(isPlaying)begin
                    if(stop)begin
                        next_state = STOP;

                        AddrCntRstn = 1;
                        AddrCntEn   = 0;
                        BeatCntRstn = 1;
                        BeatCntEn   = 0;
                        TunePWMRstn = 1;
                        BDMAstart   = 0;
                        BDMARstn    = 1;
                        BDMAAddrSel = 1;
                        fetch       = 0;
                        ref         = 0;
                    end
                    else begin
                        next_state = PLAY;

                        AddrCntRstn = 1;
                        AddrCntEn   = 0;
                        BeatCntRstn = 1;
                        BeatCntEn   = 0;
                        TunePWMRstn = 1;
                        BDMAstart   = 0;
                        BDMARstn    = 1;
                        BDMAAddrSel = 1;
                        fetch       = 0;
                        ref         = 0;
                    end
                end
                else begin
                    next_state = S0;

                    AddrCntRstn = 0;
                    AddrCntEn   = 0;
                    BeatCntRstn = 0;
                    BeatCntEn   = 0;
                    TunePWMRstn = 0;
                    BDMAstart   = 0;
                    BDMARstn    = 0;
                    BDMAAddrSel = 0;
                    fetch       = 0;
                    ref         = 0;
                end
            end
            STAY:begin
                if(isPlaying)begin
                    if(BReady)begin
                        if(|Buf)begin
                            next_state = MOVE;

                            AddrCntRstn = 1;
                            AddrCntEn   = 1;
                            BeatCntRstn = 0;
                            BeatCntEn   = 0;
                            TunePWMRstn = 0;
                            BDMAstart   = 0;
                            BDMARstn    = 1;
                            BDMAAddrSel = 1;
                            fetch       = 0;
                            ref         = 0;
                        end
                        else begin
                            next_state = S0;

                            AddrCntRstn = 0;
                            AddrCntEn   = 0;
                            BeatCntRstn = 0;
                            BeatCntEn   = 0;
                            TunePWMRstn = 0;
                            BDMAstart   = 0;
                            BDMARstn    = 0;
                            BDMAAddrSel = 1;
                            fetch       = 0;
                            ref         = 1;
                        end
                    end
                    else begin
                        next_state = STAY;
                        
                        AddrCntRstn = 1;
                        AddrCntEn   = 0;
                        BeatCntRstn = 0;
                        BeatCntEn   = 0;
                        TunePWMRstn = 0;
                        BDMAstart   = 0;
                        BDMARstn    = 1;
                        BDMAAddrSel = 1;
                        fetch       = 0;
                        ref         = 0;
                    end
                end
                else begin
                    next_state = S0;

                    AddrCntRstn = 0;
                    AddrCntEn   = 0;
                    BeatCntRstn = 0;
                    BeatCntEn   = 0;
                    TunePWMRstn = 0;
                    BDMAstart   = 0;
                    BDMARstn    = 0;
                    BDMAAddrSel = 0;
                    fetch       = 0;
                    ref         = 0;
                end
            end
            MOVE:begin
                if(isPlaying)begin
                    next_state = PLAY;

                    AddrCntRstn = 1;
                    AddrCntEn   = 0;
                    BeatCntRstn = 0;
                    BeatCntEn   = 0;
                    TunePWMRstn = 0;
                    BDMAstart   = 0;
                    BDMARstn    = 1;
                    BDMAAddrSel = 1;
                    fetch       = 1;
                    ref         = 0;
                end
                else begin
                    next_state = S0;

                    AddrCntRstn = 0;
                    AddrCntEn   = 0;
                    BeatCntRstn = 0;
                    BeatCntEn   = 0;
                    TunePWMRstn = 0;
                    BDMAstart   = 0;
                    BDMARstn    = 1;
                    BDMAAddrSel = 0;
                    fetch       = 0;
                    ref         = 0;
                end
            end
            default:begin
                next_state = S0;

                AddrCntRstn = 0;
                AddrCntEn   = 0;
                BeatCntRstn = 0;
                BeatCntEn   = 0;
                TunePWMRstn = 0;
                BDMAstart   = 0;
                BDMARstn    = 0;
                BDMAAddrSel = 0;
                fetch       = 0;
                ref         = 0;
            end
        endcase
    end

    assign TunePWMEn = BeatCntEn;

endmodule