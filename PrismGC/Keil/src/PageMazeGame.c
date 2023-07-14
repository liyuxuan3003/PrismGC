#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "GetKey.h"
#include "GPULite.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"
#include "PageEnd.h"
#include "Sleep.h"

static const LevelMap *map;
static uint8_t levelId;

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
    uint32_t mpI=0;
    *mpLen=0;
    MapCoord unitVec=_MapCoord(0,0);
    switch (direction)
    {
        case KEY_R: unitVec=_MapCoord(0,+1); break;
        case KEY_L: unitVec=_MapCoord(0,-1); break;
        case KEY_U: unitVec=_MapCoord(-1,0); break;
        case KEY_D: unitVec=_MapCoord(+1,0); break;
    }

    MapCoord coordResult=coord;
    MapCoord coordStep=coord;
    while(1)
    {
        coordStep=MapCoordPlus(coordStep,unitVec);
        uint8_t flag=0;
        if(CoordVailed(coordStep))
        {
            uint8_t blk=map->map[coordStep.i][coordStep.j];
            if(blk!=B_BAR)
            {
                coordResult=coordStep;
                moveProcess[mpI]=coordResult;
                mpI++;
            }

            switch(blk)
            {
                case B_ICE: break;
                case B_END: flag=1; break;
                case BUDIR: unitVec=_MapCoord(-1,0); break;
                case BDDIR: unitVec=_MapCoord(+1,0); break;
                case BLDIR: unitVec=_MapCoord(0,-1); break;
                case BRDIR: unitVec=_MapCoord(0,+1); break;
                case B_BAR: flag=1; break;
            }
        }
        else
        {
            flag=1;
        }

        if(flag==1)
        {
            *mpLen=mpI;
            return coordResult;
        }
    }
} 

static void MapBackground()
{
    LCDRectangle(COLOR_BAR,
        X_CORNER-BLOCK_SIZE,
        Y_CORNER-BLOCK_SIZE,
        X_CORNER+(MAP_W*2-1)*BLOCK_SIZE,
        Y_CORNER+(MAP_H*2-1)*BLOCK_SIZE);
    return;
}

static void MapFix()
{
    LCDRectangle(BG_COLOR,
        H_DISP/4-8,
        0,
        H_DISP/4+8,
        V_DISP);
    return;
}

void ConfigMazeGame(uint8_t _levelId)
{
    levelId=_levelId;
    switch(_levelId)
    {
        case 1 : map=&level1; break;
        case 2 : map=&level2; break;
        default: map=&level1; break;
    }
    return;
}

static uint8_t AppleNumber(const uint8_t *getApple)
{
    uint8_t applenumber=0;
    for(uint32_t m=0;m<APPLE_MAX;m++)
    {
        if(getApple[m])
            applenumber++;
    }
    return applenumber;
}

uint8_t PageMazeGame()
{
    uint32_t nowTime;
    MapCoord coord=map->coord;
    MapCoord moveProcess[MP_L];
    uint32_t mpLen;
    uint32_t isAnimate=0;
    uint32_t mpCirculate=0;
    uint8_t isPageChange=0;
    uint8_t gameStep=0;
    uint8_t colorChange=1;
    uint8_t pageChange=0;

    uint8_t getApple[APPLE_MAX]={0};

    while(1)
    {
        nowTime = TIMER -> TIME;

        uint8_t key=GetKey();

        if(key == KEY_E)
            return PAGE_MAIN;

        PingPong();
        LCDBackground(BG_COLOR);
        MapBackground();
        for(int8_t i=0;i<MAP_W;i++)
        {
            for(int8_t j=0;j<MAP_H;j++)
            {
                uint32_t x=CalX(_MapCoord(i,j));
                uint32_t y=CalY(_MapCoord(i,j));
                switch (map->map[i][j])
                {
                    case B_ICE: BlockICE(x,y); break;
                    case B_BAR: BlockBAR(x,y); break;
                    case B_END: BlockEND(x,y); break;
                    case B_TRP: BlockTRP(x,y); break;
                    case BUDIR: BlockDIR(x,y,1); break;
                    case BDDIR: BlockDIR(x,y,2); break;
                    case BLDIR: BlockDIR(x,y,3); break;
                    case BRDIR: BlockDIR(x,y,4); break;
                }

                for(uint32_t m=0;m<APPLE_MAX;m++)
                    if(MapCoordEqual(map->coordApple[m],_MapCoord(i,j)) && !getApple[m])
                        Apple (x,y,2);
            }
        }
        MapFix();

        // LCDPrintf(0x000000,0xFFFFFF,50,450,1,"i: %d",coord.i);
        // LCDPrintf(0x000000,0xFFFFFF,50,500,1,"j: %d",coord.j);

        if(!isAnimate)
        {
            MainCharactor(CalX(coord),CalY(coord),2);
            if(map->map[coord.i][coord.j]==B_END)
                pageChange=1;


            if(IsDirection(key))
            {
                // 情况1：正常移动了若干格 首末坐标不等 距离不等于零
                // 情况3：向折射方格移动 回到原位 首末坐标相等 距离不等于零
                // 情况2：向墙壁移动 首末坐标相等 距离等于零
                MapCoord coordNext=CoordNext(coord,key,moveProcess,&mpLen);
                if(mpLen!=0)
                {
                    coord=coordNext;
                    gameStep++;

                    isAnimate=1;
                    mpCirculate=0;
                }
            }
        }
        else
        {
            MainCharactor(CalX(moveProcess[mpCirculate]),CalY(moveProcess[mpCirculate]),2);
            
            for(uint32_t m=0;m<APPLE_MAX;m++)
                if(MapCoordEqual(moveProcess[mpCirculate],map->coordApple[m]) && !getApple[m])
                    getApple[m]=1;

            mpCirculate++;

            if(mpCirculate == mpLen)
                isAnimate=0;
        }
        LCDPrintf(0xFFFFFF,BG_COLOR,50,200,3,"Apples: %d",AppleNumber(getApple));
        LCDPrintf(0xFFFFFF,BG_COLOR,50,100,3,"Step: %d",gameStep);

        LCDPrintf(0x000000,0xFFFFFF,50,400,1,"frame: %d",TIMER->TIME-nowTime);

        if(pageChange)
        {
            // LCDPrintf(0x000000,0xFFFFFF,H_DISP/2,V_DISP/2,4,"END");
            // mdelay(1000);
            ConfigEnd(levelId,AppleNumber(getApple),gameStep);
            return PAGE_END;
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
}
