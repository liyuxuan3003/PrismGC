#include "BGM.h"
#include "Buzzer.h"

#include <stdint.h>

static const uint16_t bgmNote[33]={10,10,10,0,8,10,12,0,5,0,8,0,5,0,3,0,6,7,0,7,6,5,10,12,13,11,12,0,10,8,9,7,0};
static const uint16_t bgmTime[33]={50,100,50,50,50,100,100,100,100,100,100,50,50,100,100,50,100,50,50,50,100,100,100,100,100,50,50,50,100,50,50,100,50};
static uint8_t bgmStep=0;

void BGMPageMain()
{
    BUZZER -> NOTE =bgmNote[bgmStep];
    BUZZER -> TIME =bgmTime[bgmStep]; 
    bgmStep++;
    if(bgmStep==21)
        bgmStep=0;
    return;
}