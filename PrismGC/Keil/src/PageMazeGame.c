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
        case 0x05: return PMG_R; break;
        case 0x07: return PMG_L; break;
        case 0x0A: return PMG_U; break;
        case 0x02: return PMG_D; break;
        default: return 0; break;
    }
}

static uint32_t CalX(uint32_t i,uint32_t j)
{
    return X_CORNER+2*j*BLOCK_SIZE;
}

static uint32_t CalY(uint32_t i,uint32_t j)
{
    return Y_CORNER+2*i*BLOCK_SIZE;
}

uint8_t PageMazeGame()
{
    uint32_t nowTime;

    uint32_t chmI=level1.istart;
    uint32_t chmJ=level1.jstart;
    while(1)
    {
        nowTime = TIMER -> TIME;

        if(KEYBOARD -> KEY == 0xF)
            return PAGE_MAIN;


        PingPong();
        LCDBackground(BG_COLOR);

        for(uint32_t i=0;i<MAP_W;i++)
        {
            for(uint32_t j=0;j<MAP_H;j++)
            {
                uint32_t x=CalX(i,j);
                uint32_t y=CalY(i,j);
                switch (level1.map[i][j])
                {
                    case B_ICE: BlockICE(x,y); break;
                    case B_BAR: BlockBAR(x,y); break;
                    case B_END: BlockEND(x,y); break;
                    case B_TRP: BlockTRP(x,y); break;
                }
            }
        }

        uint32_t chmX=CalX(chmI,chmJ);
        uint32_t chmY=CalY(chmI,chmJ);
        MainCharactor (chmX,chmY,2);

        uint32_t chmNextI=chmI;
        uint32_t chmNextJ=chmJ;
        uint8_t isMove=1;
        switch(CharPlace())
        {
            case PMG_L: chmNextJ--; break;
            case PMG_R: chmNextJ++; break;
            case PMG_U: chmNextI--; break;
            case PMG_D: chmNextI++; break;
            case 0: isMove=0; break;
        }
        
        if(isMove)
        {
            switch (level1.map[chmNextI][chmNextJ])
            {
                case B_ICE:
                {
                    chmI=chmNextI;
                    chmJ=chmNextJ;
                    break;
                }
                case B_BAR: break;
                default:    break;
            }
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
}
