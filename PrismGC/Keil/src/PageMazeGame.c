#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "KeyBoard.h"
#include "GPULite.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"

#include "Nunchuck.h"

static uint8_t GetMoveDirection()
{
    // switch(KEYBOARD->KEY)
    // {
    //     case 0x05: return PMG_R; break;
    //     case 0x07: return PMG_L; break;
    //     case 0x0A: return PMG_U; break;
    //     case 0x02: return PMG_D; break;
    //     default: return 0; break;
    // }
    switch(NunchuckKey())
    {
        case 'R': return PMG_R; break;
        case 'L': return PMG_L; break;
        case 'U': return PMG_U; break;
        case 'D': return PMG_D; break;
        default: return 0; break;
    }
}

static int32_t CalX(MapCoord coord)
{
    return X_CORNER+2*coord.j*BLOCK_SIZE;
}

static int32_t CalY(MapCoord coord)
{
    return Y_CORNER+2*coord.i*BLOCK_SIZE;
}

static uint8_t CoordVailed(MapCoord coord)
{
    return (coord.i>=0 && coord.i<MAP_H && coord.j>=0 && coord.j<MAP_W);
}

static MapCoord CoordNext(MapCoord coord,uint8_t direction,MapCoord *moveProcess,uint32_t *mpLen)
{
    uint32_t mPI=0;
    *mpLen=0;
    MapCoord unitVec=_MapCoord(0,0);
    switch (direction)
    {
        case PMG_R: unitVec=_MapCoord(0,+1); break;
        case PMG_L: unitVec=_MapCoord(0,-1); break;
        case PMG_U: unitVec=_MapCoord(-1,0); break;
        case PMG_D: unitVec=_MapCoord(+1,0); break;
    }

    MapCoord coordResult=coord;
    MapCoord coordStep=coord;
    while(1)
    {
        coordStep=MapCoordPlus(coordStep,unitVec);
        uint8_t flag=0;
        if(CoordVailed(coordStep))
        {
            switch (level1.map[coordStep.i][coordStep.j])
            {
                case B_ICE: 
                {
                    coordResult=coordStep;
                    moveProcess[mPI].i=coordResult.i;
                    moveProcess[mPI].j=coordResult.j;
                    *mpLen=mPI;
                    mPI++;
                    break;
                }
                case B_BAR: flag=1; mPI=0; break;
                default: flag=1;mPI=0; break;
            }
        }
        else
        {
            flag=1;
        }

        if(flag==1)
            return coordResult;
    }
} 

static LevelMap *map;

void ConfigMazeGame(uint8_t levelId)
{
    switch(levelId)
    {
        case 1 : map=&level1; break;
        default: map=&level1; break;
    }
    return;
}

uint8_t PageMazeGame()
{
    uint32_t nowTime;
    MapCoord coord=level1.coord;
    MapCoord moveProcess[MP_L];
    uint32_t mpLen;
    uint32_t isAnimate=0;
    uint32_t mpCirculate=0;

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
                uint32_t x=CalX(_MapCoord(i,j));
                uint32_t y=CalY(_MapCoord(i,j));
                switch (level1.map[i][j])
                {
                    case B_ICE: BlockICE(x,y); break;
                    case B_BAR: BlockBAR(x,y); break;
                    case B_END: BlockEND(x,y); break;
                    case B_TRP: BlockTRP(x,y); break;
                }
            }
        }

        LCDPrintf(0x000000,0xFFFFFF,50,100,1,"i: %d",coord.i);
        LCDPrintf(0x000000,0xFFFFFF,50,150,1,"j: %d",coord.j);
        uint8_t direction=GetMoveDirection();
        if(direction)
        {
            coord=CoordNext(coord,direction,moveProcess,&mpLen);
            isAnimate=1;
        }

        if(isAnimate==0)
        {
            uint32_t chmX=CalX(coord);
            uint32_t chmY=CalY(coord);
            MainCharactor(chmX,chmY,2);
            mpCirculate=0;
        }
        else if(isAnimate==1)
        {
            if(mpCirculate <= mpLen)
            {
                uint32_t chmX=X_CORNER+2*moveProcess[mpCirculate].j*BLOCK_SIZE;
                uint32_t chmY=Y_CORNER+2*moveProcess[mpCirculate].i*BLOCK_SIZE;
                MainCharactor(chmX,chmY,2);
                mpCirculate++;
            }
            else 
            {
                isAnimate=0;
            }
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
}
