#include "Buzzer.h"

#include "BitOperate.h"
#include "HardwareConfig.h"

void BuzzerConfig(uint8_t outputBuz,uint8_t outputAudio)
{
    (outputBuz) ? BIT_SET(BUZZER->OUTPUT,BUZ) : BIT_CLR(BUZZER->OUTPUT,BUZ);
    (outputAudio) ? BIT_SET(BUZZER->OUTPUT,AUD) : BIT_CLR(BUZZER->OUTPUT,AUD);
    return;
}

void BuzzerOutput(uint8_t note,uint32_t time)
{
    BUZZER->NOTE=note;
    BUZZER->TIME=time;
    return;
}