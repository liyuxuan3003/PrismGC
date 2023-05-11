#include "PageBlockGame.h"

#include "HardwareConfig.h"
#include "KeyBoard.h"
#include "Digit.h"
#include "Buzzer.h"
#include "GPULite.h"
#include "GlobalDef.h"
#include "Sleep.h"

uint8_t PageBlockGame()
{
    PORTA -> O_SWI_DAT = 0x01;

    uint16_t x1 = 400;
    uint16_t y1 = 0;
    uint16_t x2 = 416;
    uint16_t y2 = 16;

    uint16_t health=3;
    uint16_t poh=5;
    uint16_t score=0;
    while(1)
    {
        PingPong();
        LCDBackground(0x000000);
        health--;
        // LCDRectangle(0x000000,0,400,1024,416,16);
        // LCDRectangle(0xFFFFFF,16*poh,400,16*(poh+1),416,16);
        // LCDRectangle(0xFF0000,x1,y1,x2,y2,16);
        // y1=AutoY(y1);
        // y2 += V_SPEED;
        // x1=MoveX(x1);
        // x2 += H_SPEED;
        // if(y1==400)
        // {
        //     score=ScoreDetermination(x1,poh,score);
        //     health=HealthDetermination(x1,poh,health);
        //     poh=poh+5;
        // }
        // if(poh>63)
        // poh=1;
        // DIG[0].COD = score%10;
        // DIG[1].COD = score/10;
        // DIG[3].COD = health;
        // DIG[2].DOT = 1;
        if(health == 0)
            return PAGE_MAIN;
        mdelay(1000);
    }
}

uint16_t MoveX(uint16_t x1)
{
    uint16_t xNext=x1;
    if(x1 >= BLOCK_SIZE && KEYBOARD -> KEY == 0x06)
        xNext -= H_SPEED;
    else if(x1 <= H_DISP-BLOCK_SIZE && KEYBOARD -> KEY == 0x05)
        xNext += H_SPEED;
    return xNext;
};

uint16_t AutoY(uint16_t y1)
{
    uint16_t y1Next=y1;
    y1Next += V_SPEED;
     if(y1Next>=584)
    {
        y1Next=0;
    };
    return y1Next;
}

uint16_t HealthDetermination(uint16_t x1, uint16_t l, uint8_t Health)
{
    if(x1==16*l)
    {
        Health=Health;
    }
    else
    {
        Health=Health-1;
    }
    return Health;
}

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