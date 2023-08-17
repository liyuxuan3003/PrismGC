#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "GetKey.h"
#include "GPULite.h"
#include "Buzzer.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"
#include "PageEnd.h"
#include "Sleep.h"
#include "Console.h"
#include "HardwareConfig.h"

static const uint16_t bgmNote[33]={10,10,10,0,8,10,12,0,5,0,8,0,5,0,3,0,6,7,0,7,6,5,10,12,13,11,12,0,10,8,9,7,0};
static const uint16_t bgmTime[33]={50,100,50,50,50,100,100,100,100,100,100,50,50,100,100,50,100,50,50,50,100,100,100,100,100,50,50,50,100,50,50,100,50};
static uint8_t bgmStep=0;
static const uint16_t bgmWinNote[66]={10,10,11,12,12,11,10,9,8,8,9,10,10,9,9,9,10,10,11,12,12,11,10,9,8,8,9,10,9,8,8,8,9,9,10,8,9,10,11,10,8,9,10,11,10,9,8,9,5,10,10,10,11,12,12,11,10,9,8,8,9,10,9,8,8,8};
static const uint16_t bgmWinTime[66]={300,300,300,300,300,300,300,300,300,300,300,300,300,150,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,150,300,300,300,300,300,300,300,150,150,300,300,300,150,150,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,150,300,300};
static uint8_t bgmWinStep=0;
static const uint16_t bgmFailNote[78]={10,9,10,9,10,7,9,8,6,0,1,3,6,7,0,3,5,7,8,0,3,10,9,0,0,0,0,0,6,3,6,0,0,3,3,5,0,0,6,3,6,0,0,10,9,10,7,9,8,6,0,1,3,6,7,0,3,8,7,6,0,0,0,0,6,3,6,0,0,3,3,5,0,0,6,3,6,0};
static const uint16_t bgmFailTime[78]={75,75,75,75,75,75,75,75,150,75,75,75,75,150,75,75,75,75,150,75,75,75,75,150,25,25,25,25,75,75,75,75,150,75,75,75,75,150,75,75,75,75,150,75,75,75,75,75,75,150,75,75,75,75,150,75,75,75,75,25,25,25,25,25,75,75,75,75,150,75,75,75,75,150,75,75,75,75};
static uint8_t bgmFailStep=0;

void BGMPageMain()
{
    BUZZER -> NOTE =bgmNote[bgmStep];
    BUZZER -> TIME =bgmTime[bgmStep]; 
    bgmStep++;
    if(bgmStep==21)
        bgmStep=0;
    return;
}

void BGMPageWin()
{
    BUZZER -> NOTE =bgmWinNote[bgmWinStep];
    BUZZER -> TIME =bgmWinTime[bgmWinStep]*1.2; 
    bgmWinStep++;
    if(bgmWinStep==66)
        bgmWinStep=0;
    return;
}
void BGMPageFail()
{
    BUZZER -> NOTE =bgmFailNote[bgmFailStep];
    BUZZER -> TIME =bgmFailTime[bgmFailStep]; 
    bgmFailStep++;
    if(bgmFailStep==78)
        bgmFailStep=0;
    return;
}

void configBgmNote(uint8_t isWin,uint16_t *Time)
{
    if(isWin)
        *Time=bgmWinTime[bgmWinStep]*1.2;
    else
        *Time=bgmFailTime[bgmFailStep];
}