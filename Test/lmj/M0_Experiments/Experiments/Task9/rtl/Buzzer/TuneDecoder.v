module TuneDecoder(input wire[7:0] tune,
                   output reg[19:0] TunePWMParameter);

    localparam TunePWMParameter_do = 20'h2EA9B;//do 261.6hz
    localparam TunePWMParameter_ri = 20'h29902;//ri 293.7hz
    localparam TunePWMParameter_mi = 20'h25093;//mi 329.6hz
    localparam TunePWMParameter_fa = 20'h22F50;//fa 349.2hz
    localparam TunePWMParameter_so = 20'h1F23F;//so 392hz
    localparam TunePWMParameter_la = 20'h1BBE4;//la 440hz
    localparam TunePWMParameter_xi = 20'h18B73;//xi 493.9hz
    localparam TunePWMParameter_Do = 20'h1753B;//中音do 523.3hz
    localparam TunePWMParameter_Ri = 20'h14C8F;//中音ri 587.3hz
    localparam TunePWMParameter_Mi = 20'h1283E;//中音mi 659.3hz
    localparam TunePWMParameter_Fa = 20'h11B44;//中音fa 698.5hz
    localparam TunePWMParameter_So = 20'hF920; //中音so 784hz
    localparam TunePWMParameter_La = 20'hDDF2; //中音la 880hz
    localparam TunePWMParameter_Xi = 20'hC5BA; //中音xi 987.8hz
    localparam TunePWMParameter_DO = 20'hBAA2; //高音do 1046.5hz
    localparam TunePWMParameter_RI = 20'hA644; //高音ri 1174.7hz
    localparam TunePWMParameter_MI = 20'h9422; //高音mi 1318.5hz
    localparam TunePWMParameter_FA = 20'h8BD2; //高音fa 1396.9hz
    localparam TunePWMParameter_SO = 20'h7C90; //高音so 1568hz
    localparam TunePWMParameter_LA = 20'h6EF9; //高音la 1760hz
    localparam TunePWMParameter_XI = 20'h62DE; //高音xi 1975.5hz
    localparam TunePWMParameter_ST = 20'h0; //休止符

    always @(tune) begin
        case (tune)
            8'h11: TunePWMParameter = TunePWMParameter_do;
            8'h12: TunePWMParameter = TunePWMParameter_ri;
            8'h13: TunePWMParameter = TunePWMParameter_mi;
            8'h14: TunePWMParameter = TunePWMParameter_fa;
            8'h15: TunePWMParameter = TunePWMParameter_so;
            8'h16: TunePWMParameter = TunePWMParameter_la;
            8'h17: TunePWMParameter = TunePWMParameter_xi;
            8'h21: TunePWMParameter = TunePWMParameter_Do;
            8'h22: TunePWMParameter = TunePWMParameter_Ri;
            8'h23: TunePWMParameter = TunePWMParameter_Mi;
            8'h24: TunePWMParameter = TunePWMParameter_Fa;
            8'h25: TunePWMParameter = TunePWMParameter_So;
            8'h26: TunePWMParameter = TunePWMParameter_La;
            8'h27: TunePWMParameter = TunePWMParameter_Xi;       
            8'h31: TunePWMParameter = TunePWMParameter_DO;
            8'h32: TunePWMParameter = TunePWMParameter_RI;
            8'h33: TunePWMParameter = TunePWMParameter_MI;
            8'h34: TunePWMParameter = TunePWMParameter_FA;
            8'h35: TunePWMParameter = TunePWMParameter_SO;
            8'h36: TunePWMParameter = TunePWMParameter_LA;
            8'h37: TunePWMParameter = TunePWMParameter_XI;
            8'h40: TunePWMParameter = TunePWMParameter_ST;
            default:TunePWMParameter = 20'd0; 
        endcase 
    end

endmodule