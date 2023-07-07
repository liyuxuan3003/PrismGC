#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "KeyBoard.h"
#include "GPULite.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"

uint8_t PageMazeGame()
{
    uint32_t nowTime;
    uint32_t xCorner=(H_DISP/2)-(MAP_W-1)*BLOCK_SIZE+120;
    uint32_t yCorner=(V_DISP/2)-(MAP_H-1)*BLOCK_SIZE;
    uint32_t xCharacterMove=xCorner+2*level1.jstart*BLOCK_SIZE;
    uint32_t yCharacterMove=yCorner+2*level1.istart*BLOCK_SIZE;
    while(1)
    {
        nowTime = TIMER -> TIME;

        if(KEYBOARD -> KEY == 0xF)
            return PAGE_MAIN;

        PingPong();
        LCDBackground(0x888888);

        for(uint32_t i=0;i<MAP_W;i++)
        {
            for(uint32_t j=0;j<MAP_H;j++)
            {

                uint32_t x=xCorner+2*j*BLOCK_SIZE;
                uint32_t y=yCorner+2*i*BLOCK_SIZE;
                switch (level1.map[i][j])
                {
                    case B_ICE: BlockICE(x,y); break;
                    case B_BAR: BlockBAR(x,y); break;
                    case B_END: BlockEND(x,y); break;
                    case B_TRP: BlockTRP(x,y); break;
                }
                
            }
        };
        MainCharactor (xCharacterMove,yCharacterMove);
            switch (KEYBOARD -> KEY)
            {
                case 0x09:xCharacterMove+=48; break;
                case 0x05:xCharacterMove-=48; break;
                case 0x0A:yCharacterMove-=48; break;
                case 0x06:yCharacterMove+=48; break;
            }
        if(xCharacterMove<xCorner+2*level1.jstart*BLOCK_SIZE)
            xCharacterMove+=48;
        else if(xCharacterMove>xCorner+2*11*BLOCK_SIZE)
            xCharacterMove-=48;
        else if(yCharacterMove<yCorner+2*level1.istart*BLOCK_SIZE)
            yCharacterMove+=48;
        while(TIMER -> TIME < nowTime + FRAME);
    }
}
