#include "Buzzer.h"

#include "BitOperate.h"
#include "HardwareConfig.h"

void BuzzerConfig()
{
    uint8_t outputBuz=SWI_6(P);
    uint8_t outputAud=SWI_7(P);
    (outputBuz) ? BIT_SET(BUZZER->OUTPUT,BUZ) : BIT_CLR(BUZZER->OUTPUT,BUZ);
    (outputAud) ? BIT_SET(BUZZER->OUTPUT,AUD) : BIT_CLR(BUZZER->OUTPUT,AUD);
    (outputBuz) ? LED_6(H) : LED_6(L);
    (outputAud) ? LED_7(H) : LED_7(L);
    return;
}

void BuzzerOutput(uint8_t note,uint32_t time)
{
    BUZZER->NOTE=note;
    BUZZER->TIME=time;
    return;
}