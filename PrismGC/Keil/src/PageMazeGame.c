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
    uint32_t pixels[8]={RED,RED,RED,GREEN,GREEN,GREEN,BLUE,BLUE};

    while(1)
    {
        nowTime = TIMER -> TIME;

        if(KEYBOARD -> KEY == 0xF)
            return PAGE_MAIN;

        PingPong();
        LCDBackground(0x888888);

        for(int i=0;i<30;i++)
            LCDPixels(pixels,30,30+i,8);

        uint32_t xInit=(H_DISP/2)-(MAP_W-1)*BLOCK_SIZE+120;
        uint32_t yInit=(V_DISP/2)-(MAP_H-1)*BLOCK_SIZE;
        for(uint32_t i=0;i<MAP_W;i++)
        {
            for(uint32_t j=0;j<MAP_H;j++)
            {
                uint32_t x=xInit+2*j*BLOCK_SIZE;
                uint32_t y=yInit+2*i*BLOCK_SIZE;
                switch (level1.map[i][j])
                {
                    case B_ICE: BlockICE(x,y); break;
                    case B_BAR: BlockBAR(x,y); break;
                    case B_END: BlockEnd(x,y); break;
                    case B_TRAP: BlockTrap(x,y); break;
                }
                if(i==level1.istart&&j==level1.jstart)
                {
                    BlockOrigin(x,y);
                }
                
            }
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
}