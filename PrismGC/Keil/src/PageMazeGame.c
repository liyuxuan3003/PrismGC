#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "KeyBoard.h"
#include "GPULite.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"

static uint8_t CharPlace()
{
    switch (KEYBOARD->KEY)
    {
        case 0x09: return PMG_R; break;
        case 0x05: return PMG_L; break;
        case 0x0A: return PMG_U; break;
        case 0x06: return PMG_D; break;
        default: return 0; break;
    }
}


uint8_t PageMazeGame()
{
    uint32_t nowTime;
    uint32_t xCorner=(H_DISP/2)-(MAP_W-1)*BLOCK_SIZE+120;
    uint32_t yCorner=(V_DISP/2)-(MAP_H-1)*BLOCK_SIZE;
    uint32_t iCharacterMove=level1.istart;
    uint32_t jCharacterMove=level1.jstart;
    uint32_t xCharMove=iCharacterMove;
    uint32_t yCharMove=jCharacterMove;
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
                };
                
            }
        };
        switch (level1.map[iCharacterMove][jCharacterMove])
        {
            case B_ICE:
            {
                switch(CharPlace())
                {
                    case PMG_L: jCharacterMove--; break;
                    case PMG_R: jCharacterMove++; break;
                    case PMG_U: iCharacterMove--; break;
                    case PMG_D: iCharacterMove++; break;
                    case 0: break;
                }
            }
            case B_BAR: break;
        }
        xCharMove=xCorner+2*jCharacterMove*BLOCK_SIZE;
        yCharMove=yCorner+2*iCharacterMove*BLOCK_SIZE;
        MainCharactor (xCharMove,yCharMove);
        while(TIMER -> TIME < nowTime + FRAME);
    }
}
