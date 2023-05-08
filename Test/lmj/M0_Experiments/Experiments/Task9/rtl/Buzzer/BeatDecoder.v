module BeatDecoder #(parameter isSim = 0) (input wire[3:0] beat,
                   input wire bpm,
                   output reg[27:0] BeatCntParameter);

    localparam BeatCntParameter_00 = isSim? 28'd100_000_0 : 28'd100_000_000; //2s
    localparam BeatCntParameter_02 = isSim?  28'd50_000_0 :  28'd50_000_000; //1s
    localparam BeatCntParameter_04 = isSim?  28'd25_000_0 :  28'd25_000_000; //0.5s
    localparam BeatCntParameter_08 = isSim?  28'd12_500_0 :  28'd12_500_000; //0.25s
    localparam BeatCntParameter_16 = isSim?   28'd6_250_0 :   28'd6_250_000; //0.125s
    localparam BeatCntParameter_32 = isSim?   28'd3_125_0 :   28'd3_125_000; //0.0625s
    localparam BeatCntParameter_64 = isSim?   28'd1_562_5 :   28'd1_562_500; //0.03125s

    always @(beat,bpm) begin
        case(beat)
            4'h0: BeatCntParameter = bpm? BeatCntParameter_00*2 : BeatCntParameter_00;
            4'h1: BeatCntParameter = bpm? BeatCntParameter_02*2 : BeatCntParameter_02;
            4'h2: BeatCntParameter = bpm? BeatCntParameter_04*2 : BeatCntParameter_04;
            4'h3: BeatCntParameter = bpm? BeatCntParameter_08*2 : BeatCntParameter_08;
            4'h4: BeatCntParameter = bpm? BeatCntParameter_16*2 : BeatCntParameter_16;
            4'h5: BeatCntParameter = bpm? BeatCntParameter_32*2 : BeatCntParameter_32;
            4'h6: BeatCntParameter = bpm? BeatCntParameter_64*2 : BeatCntParameter_64;
            default: BeatCntParameter = 28'b0;
        endcase
    end

endmodule