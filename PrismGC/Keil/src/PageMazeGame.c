#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "KeyBoard.h"
#include "GPULite.h"

#include "Block.h"
#include "BlockMap.h"

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
        
        uint32_t xInit=(H_DISP/2)-(MAP_W-1)*BLOCK_SIZE;
        uint32_t yInit=(V_DISP/2)-(MAP_H-1)*BLOCK_SIZE;
        for(uint32_t i=0;i<MAP_W;i++)
        {
            for(uint32_t j=0;j<MAP_H;j++)
            {
                uint32_t x=xInit+2*i*BLOCK_SIZE;
                uint32_t y=yInit+2*i*BLOCK_SIZE;
                switch (level1[x][y])
                {
                    case B_ICE: BlockICE(x,y); break;
                    case B_BAR: BlockBAR(x,y); break;
                }
            }
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
}