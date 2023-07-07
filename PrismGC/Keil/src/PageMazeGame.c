#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "KeyBoard.h"
#include "GPULite.h"

#include "Block.h"

uint8_t PageMazeGame()
{
    uint32_t nowTime;

    while(1)
    {
        nowTime = TIMER -> TIME;

        if(KEYBOARD -> KEY == 0xF)
            return PAGE_MAIN;

        PingPong();
        LCDBackground(0x888888);
        
        BlockICE(300,300);

        BlockICE(400,300);

        BlockICE(500,300);

        BlockBAR(300,400);

        BlockBAR(400,400);

        BlockBAR(500,400);

        while(TIMER -> TIME < nowTime + FRAME);
    }
}