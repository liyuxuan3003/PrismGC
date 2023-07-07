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

    while(1)
    {
        nowTime = TIMER -> TIME;

        if(KEYBOARD -> KEY == 0xF)
            return PAGE_MAIN;

        PingPong();
        LCDBackground(0x888888);

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
        //LCDPixels的len需满足5<=len<=16
        uint32_t colors[24]=
        {
            0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,
            0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,
            0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000,0xFF0000,0x000000
        };
        for(int i=4;i<16;i++)
            LCDPixels(colors,200-i/2,400+i,i+1);
        MainCharactor (600,90);
        MainCharactor (650,90);
        MainCharactor (700,90);
        while(TIMER -> TIME < nowTime + FRAME);
    }
}