#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "GetKey.h"
#include "GPULite.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"
#include "PageEnd.h"

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
            switch (level1.map[coordStep.i][coordStep.j])
            {
                case B_ICE: 
                {
                    coordResult=coordStep;
                    moveProcess[mpI]=coordResult;
                    mpI++;
                    *mpLen=mpI;
                    break;
                }
                case B_END: 
                {
                    coordResult=coordStep;
                    moveProcess[mpI]=coordResult;
                    mpI++;
                    *mpLen=mpI;
                    break;
                }
                case B_BAR: flag=1; mpI=0; break;
                default: flag=1; mpI=0; break;
            }
        }
        else
        {
            flag=1;
        }

        if(flag==1)
        {
            LCDPrintf(BLACK,WHITE,100,300,1,"coordRes: %d,%d",coordResult.i,coordResult.j);
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

static const LevelMap *map;
static uint8_t levelID;

void ConfigMazeGame(uint8_t _levelId)
{
    levelID=_levelId;
    switch(_levelId)
    {
        case 1 : map=&level1; break;
        default: map=&level1; break;
    }
    return;
}

static int32_t AppleNumber(uint8_t *getApple)
{
    int applenumber=0;
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
    MapCoord coord=level1.coord;
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
        
        if(!pageChange)
        {
            LCDBackground(BG_COLOR);
            MapBackground();
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

                    for(uint32_t m=0;m<APPLE_MAX;m++)
                        if(MapCoordEqual(level1.coordApple[m],_MapCoord(i,j)) && !getApple[m])
                            Apple(x,y,2);
                }
            }
            MapFix();

            LCDPrintf(0x000000,0xFFFFFF,50,100,1,"i: %d",coord.i);
            LCDPrintf(0x000000,0xFFFFFF,50,150,1,"j: %d",coord.j);

            if(!isAnimate)
            {
                MainCharactor(CalX(coord),CalY(coord),2);
                if(IsDirection(key))
                {
                    MapCoord coordNext=CoordNext(coord,key,moveProcess,&mpLen);
                    if(!MapCoordEqual(coordNext,coord))
                    {
                        coord=coordNext;
                        isAnimate=1;
                        mpCirculate=0;
                        gameStep++;
                    }
                }
                // if(isPageChange==1)
                // {
                //     MainCharactor(CalX(coord),CalY(coord),2);
                //     if(IsDirection(key))
                //     {
                //         coord=CoordNext(coord,key,moveProcess,&mpLen);
                //         isAnimate=1;
                //         mpCirculate=0;
                //         gameStep++;
                //     }
                //     if(isPageChange==1)
                //     {
                //         pageChange=1;
                //     }
                // }
            }
            else
            {
                MainCharactor(CalX(moveProcess[mpCirculate]),CalY(moveProcess[mpCirculate]),2);
                
                for(uint32_t m=0;m<APPLE_MAX;m++)
                    if(MapCoordEqual(moveProcess[mpCirculate],level1.coordApple[m]) && !getApple[m])
                        getApple[m]=1;

                switch(level1.map[moveProcess[mpCirculate].i][moveProcess[mpCirculate].j])
                {
                    uint32_t chmX=X_CORNER+2*moveProcess[mpCirculate].j*BLOCK_SIZE;
                    uint32_t chmY=Y_CORNER+2*moveProcess[mpCirculate].i*BLOCK_SIZE;
                    MainCharactor(chmX,chmY,2);
                    switch(level1.map[moveProcess[mpCirculate].i][moveProcess[mpCirculate].j])
                    {
                        case B_END: isPageChange=1; break;
                        default:break;
                    }

                    mpCirculate++;

                if(mpCirculate == mpLen)
                    isAnimate=0;
                }
            LCDPrintf(0xFFFFFF,BG_COLOR,50,300,3,"Apples: %d",AppleNumber(getApple));
            LCDPrintf(0x000000,0xFFFFFF,50,200,1,"frame: %d",TIMER->TIME-nowTime);
            LCDPrintf(0xFFFFFF,BG_COLOR,50,100,3,"Step: %d",gameStep);

            if(pageChange==1)
            {
                return PAGE_END;
            }

            while(TIMER -> TIME < nowTime + FRAME);
            }
}
