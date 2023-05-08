module tune_decoder(
    input        [7 :0]  tune,
    output  reg  [19:0]  tune_pwm_parameter
);

localparam tune_pwm_parameter_do = 20'h2EA9B;//do 261.6hz
localparam tune_pwm_parameter_ri = 20'h29902;//ri 293.7hz
localparam tune_pwm_parameter_mi = 20'h25093;//mi 329.6hz
localparam tune_pwm_parameter_fa = 20'h22F50;//fa 349.2hz
localparam tune_pwm_parameter_so = 20'h1F23F;//so 392hz
localparam tune_pwm_parameter_la = 20'h1BBE4;//la 440hz
localparam tune_pwm_parameter_xi = 20'h18B73;//xi 493.9hz
localparam tune_pwm_parameter_Do = 20'h1753B;//???��??do 523.3hz
localparam tune_pwm_parameter_Ri = 20'h14C8F;//???��??ri 587.3hz
localparam tune_pwm_parameter_Mi = 20'h1283E;//???��??mi 659.3hz
localparam tune_pwm_parameter_Fa = 20'h11B44;//???��??fa 698.5hz
localparam tune_pwm_parameter_So = 20'hF920; //???��??so 784hz
localparam tune_pwm_parameter_La = 20'hDDF2; //???��??la 880hz
localparam tune_pwm_parameter_Xi = 20'hC5BA; //???��??xi 987.8hz
localparam tune_pwm_parameter_DO = 20'hBAA2; //��??��??do 1046.5hz
localparam tune_pwm_parameter_RI = 20'hA644; //��??��??ri 1174.7hz
localparam tune_pwm_parameter_MI = 20'h9422; //��??��??mi 1318.5hz
localparam tune_pwm_parameter_FA = 20'h8BD2; //��??��??fa 1396.9hz
localparam tune_pwm_parameter_SO = 20'h7C90; //��??��??so 1568hz
localparam tune_pwm_parameter_LA = 20'h6EF9; //��??��??la 1760hz
localparam tune_pwm_parameter_XI = 20'h62DE; //��??��??xi 1975.5hz

always @(tune) begin
    case (tune)
        8'h11: tune_pwm_parameter = tune_pwm_parameter_do;
        8'h12: tune_pwm_parameter = tune_pwm_parameter_ri;
        8'h13: tune_pwm_parameter = tune_pwm_parameter_mi;
        8'h14: tune_pwm_parameter = tune_pwm_parameter_fa;
        8'h15: tune_pwm_parameter = tune_pwm_parameter_so;
        8'h16: tune_pwm_parameter = tune_pwm_parameter_la;
        8'h17: tune_pwm_parameter = tune_pwm_parameter_xi;
        8'h21: tune_pwm_parameter = tune_pwm_parameter_Do;
        8'h22: tune_pwm_parameter = tune_pwm_parameter_Ri;
        8'h23: tune_pwm_parameter = tune_pwm_parameter_Mi;
        8'h24: tune_pwm_parameter = tune_pwm_parameter_Fa;
        8'h25: tune_pwm_parameter = tune_pwm_parameter_So;
        8'h26: tune_pwm_parameter = tune_pwm_parameter_La;
        8'h27: tune_pwm_parameter = tune_pwm_parameter_Xi;       
        8'h31: tune_pwm_parameter = tune_pwm_parameter_DO;
        8'h32: tune_pwm_parameter = tune_pwm_parameter_RI;
        8'h33: tune_pwm_parameter = tune_pwm_parameter_MI;
        8'h34: tune_pwm_parameter = tune_pwm_parameter_FA;
        8'h35: tune_pwm_parameter = tune_pwm_parameter_SO;
        8'h36: tune_pwm_parameter = tune_pwm_parameter_LA;
        8'h37: tune_pwm_parameter = tune_pwm_parameter_XI;
        default:tune_pwm_parameter = 20'd0; 
    endcase 
end

endmodule
