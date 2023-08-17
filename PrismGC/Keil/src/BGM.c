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

static const uint16_t bgmNote[35]={10,10,10,0,8,10,12,0,5,0,8,0,5,0,3,0,6,7,0,7,6,5,10,12,13,11,12,0,10,8,9,7,0,0};
static const uint16_t bgmTime[35]={100,200,100,100,100,200,200,200,200,200,200,100,100,200,200,100,200,100,100,100,200,200,200,200,200,100,100,100,200,100,100,200,100,100};
static uint8_t bgmStep=0;
static const uint16_t bgmWinNote[66]={10,10,11,12,12,11,10,9,8,8,9,10,10,9,9,9,10,10,11,12,12,11,10,9,8,8,9,10,9,8,8,8,9,9,10,8,9,10,11,10,8,9,10,11,10,9,8,9,5,10,10,10,11,12,12,11,10,9,8,8,9,10,9,8,8,8};
static const uint16_t bgmWinTime[66]={250,250,250,250,250,250,250,250,250,250,250,250,250,150,250,250,250,250,250,250,250,250,250,250,250,250,250,250,250,150,250,250,250,250,250,250,250,150,150,250,250,250,150,150,250,250,250,250,250,250,250,250,250,250,250,250,250,250,250,250,250,250,250,150,250,250};
static uint8_t bgmWinStep=0;
static const uint16_t bgmFailNote[42]={10,9,10,9,10,7,9,8,6,0,1,3,6,7,0,3,5,7,8,0,3,10,9,10,9,10,7,9,8,6,0,1,3,6,7,0,3,8,7,6,0,0};
static const uint16_t bgmFailTime[42]={75,75,75,75,75,75,75,75,150,75,75,75,75,150,75,75,75,75,150,75,75,75,75,75,75,75,75,75,75,150,75,75,75,75,150,75,75,75,75,150,75,75};
static uint8_t bgmFailStep=0;

void BGMPageMain()
{
    if(bgmNote[bgmStep]!=0)
    {    
        BUZZER -> NOTE =bgmNote[bgmStep];
        if(BUZZER -> NOTE == 0)
            return;
        BUZZER -> TIME =bgmTime[bgmStep]; 
    }
    bgmStep++;
    if(bgmStep==35)
        bgmStep=0;
    return;
}

void BGMPageWin()
{
    if(bgmWinNote[bgmWinStep]!=0)
    {    
        BUZZER -> NOTE =bgmWinNote[bgmWinStep];
        if(BUZZER -> NOTE == 0)
            return;
        BUZZER -> TIME =bgmWinTime[bgmWinStep]*1.2; 
    }
    bgmWinStep++;
    if(bgmWinStep==66)
        bgmWinStep=0;
    return;
}

void BGMPageFail()
{
    if(bgmFailNote[bgmFailStep]!=0)
    {    
        BUZZER -> NOTE =bgmFailNote[bgmFailStep];
        if(BUZZER -> NOTE == 0)
            return;
        BUZZER -> TIME =bgmFailTime[bgmFailStep]*3; 
    }
    bgmFailStep++;
    if(bgmFailStep==42)
        bgmFailStep=0;
    return;
}

void ConfigBgmNote(uint8_t isWin,uint16_t *time)
{
    if(isWin)
        *time=bgmWinTime[bgmWinStep]*1.2;
    else
        *time=bgmFailTime[bgmFailStep]*3;
}