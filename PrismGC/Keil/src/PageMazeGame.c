#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "KeyBoard.h"
#include "GPULite.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"

static uint8_t GetMoveDirection()
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

static MapCoord CoordNext(MapCoord coord,uint8_t direction,*moveProcess)
{
    uint32_t moveI=0;
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
                case B_ICE: coordResult=coordStep;moveProcess[moveI]=coordResult.i; moveI++; break;
                case B_BAR: flag=1; break;
                default: flag=1; break;
            }
        }
        else
        {
            flag=1;
        }

        if(flag==1)
            return coordResult;
        uint32_t chmX=CalX(coordResult);
        uint32_t chmY=CalY(coordResult);
        MainCharactor(chmX,chmY,2);
    }
} 

static MoveProcess(uint8_t direction,uint32_t moveProcess)
{
    switch (direction)
    {
        case PMG_R||PMG_L:
        {
            for()
        }
        case PMG_U||PMG_D:
    }
}

uint8_t PageMazeGame()
{
    uint32_t nowTime;
    MapCoord coord=level1.coord;

    while(1)
    {
        uint32_t moveProcess[32]={0};
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

        uint32_t chmX=CalX(coord);
        uint32_t chmY=CalY(coord);
        MainCharactor(chmX,chmY,2);

        LCDPrintf(0x000000,0xFFFFFF,50,100,1,"i: %d",coord.i);
        LCDPrintf(0x000000,0xFFFFFF,50,150,1,"j: %d",coord.j);

        uint8_t direction=GetMoveDirection();
        if(direction)
            coord=CoordNext(coord,direction);

        while(TIMER -> TIME < nowTime + FRAME);
    }
}
