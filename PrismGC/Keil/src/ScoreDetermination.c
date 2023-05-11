#include "ScoreDetermination.h"
#include "Buzzer.h"

uint16_t ScoreDetermination(uint16_t x1, uint16_t l, uint8_t Score)
{
    Score=Score;
    if(x1==16*l)
    {
        Score=Score+5;
        BUZZER -> NOTE ++;
        BUZZER -> TIME = 200;
    }
    return Score;
}