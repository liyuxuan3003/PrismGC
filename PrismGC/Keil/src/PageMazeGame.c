#include "PageMazeGame.h"

#include "GlobalDefine.h"
#include "Timer.h"
#include "GetKey.h"
#include "GPULite.h"
#include "Buzzer.h"

#include "Block.h"
#include "BlockMap.h"
#include "Charactors.h"
#include "PageEnd.h"
#include "Sleep.h"
#include "Console.h"
#include "HardwareConfig.h"
#include "Digit.h"

static LevelMap map;
static PortalPair portal[POR_NUM];
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

static uint8_t GetBlockType(MapCoord coord)
{
    return map.map[coord.i][coord.j];
}

static void SetBlockType(MapCoord coord,uint8_t type)
{
    map.map[coord.i][coord.j]=type;
    return;
}

static MapCoord CoordNext(MapCoord coord,uint8_t direction,MapCoord *moveProcess,uint32_t *mpLen,MapCoord *hitCoord,uint8_t doorStatus)
{
    uint32_t mpI=0;
    *mpLen=0;
    *hitCoord=_MapCoord(-1,-1);
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
            uint8_t blk=map.map[coordStep.i][coordStep.j];
            MapCoord portalCoord=_MapCoord(0,0);

            if(GetBlockType(coordStep)==B_BUT)
                doorStatus=(doorStatus==0) ? 2 : 0;

            if(blk!=B_BAR && blk!=B_GRA && !(blk==B_MCG && doorStatus==0))
            {
                coordResult=coordStep;
                moveProcess[mpI]=coordStep;
                mpI++;
            }

            switch(blk)
            {
                case B_ICE: break;
                case B_END: flag=1; break;
                case B_TRP: flag=1; break;
                case BUDIR: unitVec=_MapCoord(-1,0); break;
                case BDDIR: unitVec=_MapCoord(+1,0); break;
                case BLDIR: unitVec=_MapCoord(0,-1); break;
                case BRDIR: unitVec=_MapCoord(0,+1); break;
                case B1POR: portalCoord=PortalAnother(coordStep,portal[0]); break;
                case B2POR: portalCoord=PortalAnother(coordStep,portal[1]); break;
                case B3POR: portalCoord=PortalAnother(coordStep,portal[2]); break;
                case B_GRA: flag=1; *hitCoord=coordStep; break;
                case B_BAR: flag=1; break;
                case B_MCG: 
                {
                    if(doorStatus!=2) 
                        flag=1;
                    break; 
                }
            }

            if(blk==B1POR || blk==B2POR || blk==B3POR)
            {
                coordStep=portalCoord;
                coordResult=coordStep;
                moveProcess[mpI]=coordStep;
                mpI++;
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

void ConfigMazeGame(uint8_t _levelId)
{
    levelId=_levelId;
    const LevelMap *pmap;
    switch(_levelId)
    {
        case 1 : pmap=&level1;  break;
        case 2 : pmap=&level2;  break;
        case 3 : pmap=&level3;  break;
        case 4 : pmap=&level4;  break;
        case 5 : pmap=&level5;  break;
        case 6 : pmap=&level6;  break;
        case 7 : pmap=&level7;  break;
        case 8 : pmap=&level8;  break;
        case 9 : pmap=&level9;  break;
        case 10: pmap=&level10; break;
        case 11: pmap=&level11; break;
        case 12: pmap=&level12; break;
        case 13: pmap=&level13; break;
        case 14: pmap=&level14; break;
        case 15: pmap=&level15; break;
        case 16: pmap=&level16; break;
        case 17: pmap=&level17; break;
        case 18: pmap=&level18; break;
        case 19: pmap=&level19; break;
        case 20: pmap=&level20; break;
        case 21: pmap=&level21; break;
        case 22: pmap=&level22; break;
        case 23: pmap=&level23; break;
        case 24: pmap=&level24; break;
        case 25: pmap=&level25; break;
        case 26: pmap=&level26; break;
        case 27: pmap=&level27; break;
        case 28: pmap=&level28; break;
        case 29: pmap=&level29; break;
        case 30: pmap=&level30; break;
        case 31: pmap=&level31; break;
        case 32: pmap=&level32; break;
        case 33: pmap=&level33; break;
        case 34: pmap=&level34; break;
        case 35: pmap=&level35; break;
        case 36: pmap=&level36; break;
        case 37: pmap=&level37; break;
        case 38: pmap=&level38; break;
        case 39: pmap=&level39; break;
        case 40: pmap=&level40; break;
        case 41: pmap=&level41; break;
        case 42: pmap=&level42; break;
        case 43: pmap=&level43; break;
        case 44: pmap=&level44; break;
        case 45: pmap=&level45; break;
        case 46: pmap=&level46; break;
        case 47: pmap=&level47; break;
        case 48: pmap=&level48; break;
        default: pmap=&level1;  break;
    }

    for(uint32_t i=0;i<POR_NUM;i++)
    {
        portal[i].p1=_MapCoord(0,0);
        portal[i].p2=_MapCoord(0,0);
        portal[i].marker=0;
    } 

    map.coord=pmap->coord;
    for(uint32_t i=0;i<APPLE_MAX;i++)
        map.coordApple[i]=pmap->coordApple[i];
    for(uint32_t i=0;i<MAP_H;i++)
    {
        for(uint32_t j=0;j<MAP_W;j++)
        {
            uint8_t blk=pmap->map[i][j];
            SetBlockType(_MapCoord(i,j),blk);
            switch(blk)
            {
                case B1POR: PortalWrite(_MapCoord(i,j),&portal[0]); break;
                case B2POR: PortalWrite(_MapCoord(i,j),&portal[1]); break;
                case B3POR: PortalWrite(_MapCoord(i,j),&portal[2]); break;
            }
        }      
    }

    return;
}

static uint8_t AppleNumber(const uint8_t *getApple)
{
    uint8_t applenumber=0;
    for(uint32_t m=0;m<APPLE_MAX;m++)
        if(getApple[m])
            applenumber++;

    return applenumber;
}

static uint8_t MechanismGate(uint8_t isChange)
{
    uint8_t blk;
    if(isChange%2==0)
        blk = B_BAR;
    else if(isChange%2==1)
        blk = B_ICE;
    return blk;
}

uint8_t PageMazeGame()
{
    uint32_t nowTime;

    MapCoord coord=map.coord;

    MapCoord moveProcess[MP_L];
    
    uint32_t mpLen;
    uint32_t mapLen;
    
    uint32_t mpCirculate=0;

    MapCoord doorCoord[MP_L];
    uint32_t doorNum=0;
    uint8_t  doorStatus=0;
    uint8_t  doorAnim=0;

    // uint32_t mcgNumber=0;
    // uint8_t  mCGProcess=3;
    // uint8_t  isMCGStart=0;
    // uint8_t isChange=0;

    uint32_t isAnimate=0;
    uint8_t isPageChange=0;
    uint8_t gameStep=0;
    uint8_t isWin=1;
    
    uint8_t getApple[APPLE_MAX]={0};

    MapCoord hitCoord=_MapCoord(-1,-1);
    uint8_t waitHit=0;

    for(uint8_t i=0;i<4;i++)
    {
        DIG[i].ENA = 1;
        DIG[i].DOT = 0;
    }

    for(int8_t i=0;i<MAP_W;i++)
    {
        for(int8_t j=0;j<MAP_H;j++)
        {
            if(map.map[i][j] == B_MCG)
            {
                doorCoord[doorNum]=_MapCoord(i,j); 
                doorNum++; 
            }
        }
    }

    while(1)
    {
        nowTime = TIMER -> TIME;

        DIG[0].COD=gameStep%10;
        DIG[1].COD=(gameStep/10)%10;
        DIG[2].COD=(gameStep/100)%10;
        DIG[3].COD=0;

        BuzzerConfig();

        uint8_t key=GetKey(0);

        if(key == KEY_E || key == KEY_C)
            return PAGE_MENU;

        PingPong();
        LCDBackground(BG_COLOR);
        MapBackground();
        for(int8_t i=MAP_W-1;i>=0;i--)
        {
            for(int8_t j=MAP_H-1;j>=0;j--)
            {
                uint32_t x=CalX(_MapCoord(i,j));
                uint32_t y=CalY(_MapCoord(i,j));
                switch(map.map[i][j])
                {
                    case B_ICE: BlockICE(x,y); break;
                    case B_BAR: BlockBAR(x,y); break;
                    case B_END: BlockEND(x,y); break;
                    case BUDIR: BlockDIR(x,y,1); break;
                    case BDDIR: BlockDIR(x,y,2); break;
                    case BLDIR: BlockDIR(x,y,3); break;
                    case BRDIR: BlockDIR(x,y,4); break;
                    case B_GRA: BlockGRA(x,y,0); break;
                    case BHGRA: BlockGRA(x,y,1); break;
                    case B1POR: BlockPOR(x,y,1); break;
                    case B2POR: BlockPOR(x,y,2); break;
                    case B3POR: BlockPOR(x,y,3); break;
                    case B_TRP: BlockTRP(x,y); break;
                    case B_MCG: BlockDOR(x,y,(doorAnim==1) ? doorAnim : doorStatus); break;
                    case B_BUT: BlockBUT(x,y,doorStatus); break; 
                }

                for(uint32_t m=0;m<APPLE_MAX;m++)
                    if(MapCoordEqual(map.coordApple[m],_MapCoord(i,j)) && !getApple[m])
                        Apple(x,y,2);
            }
        }

        if(doorAnim==1) doorAnim=0;

        if(!isAnimate)
        {
            MainCharactor(CalX(coord),CalY(coord),2);

            if(GetBlockType(coord)==B_END)
            {
                isPageChange=1;
                isWin=1;
            }
            
            if(GetBlockType(coord)==B_TRP)
            {
                isPageChange=1;
                isWin=0;
            }

            if(IsDirection(key))
            {
                // 情况1：正常移动了若干格 首末坐标不等 距离不等于零
                // 情况3：向折射方格移动 回到原位 首末坐标相等 距离不等于零
                // 情况2：向墙壁移动 首末坐标相等 距离等于零
                MapCoord coordNext=
                    CoordNext(coord,key,moveProcess,&mpLen,&hitCoord,doorStatus);
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
            {
                if(MapCoordEqual(moveProcess[mpCirculate],map.coordApple[m]) && !getApple[m])
                {
                    getApple[m]=1;
                    BuzzerOutput(3,200);
                }
            }

            switch(GetBlockType(moveProcess[mpCirculate]))
            {
                case B1POR: BuzzerOutput(7,40); break;
                case B2POR: BuzzerOutput(8,40); break;
                case B3POR: BuzzerOutput(9,40); break;
                case BLDIR: BuzzerOutput(5,80); break;
                case BRDIR: BuzzerOutput(5,80); break;
                case BUDIR: BuzzerOutput(5,80); break;
                case BDDIR: BuzzerOutput(5,80); break;
                case B_END: BuzzerOutput(10,500); break;
                case B_TRP: BuzzerOutput(1,500); break;
                case B_BUT: BuzzerOutput(14,800); break;
                default: break;
            }

            if(GetBlockType(moveProcess[mpCirculate])==B_BUT)
            {
                doorStatus = (doorStatus==0) ? 2 : 0;
                doorAnim = 1;
            }
            
            mpCirculate++;

            if(mpCirculate == mpLen)
            {
                if(MapCoordEqual(hitCoord,_MapCoord(-1,-1)))
                    isAnimate=0;
                else
                {
                    mpCirculate=mpLen-1;
                    if(waitHit==0)
                    {
                        waitHit=1;
                        BuzzerOutput(2,200);
                        SetBlockType(hitCoord,BHGRA);
                    }
                    else
                    {
                        waitHit=0;
                        SetBlockType(hitCoord,B_ICE);
                        isAnimate=0;
                    }
                }
            }
                
        }

        LCDPrintf(WHITE,BG_COLOR,50,50,3,"Level %02d",levelId);
        LCDPrintf(WHITE,BG_COLOR,50,180,2,"Step: %d",gameStep);
        LCDPrintf(WHITE,BG_COLOR,50,260,2,"Apples: %d",AppleNumber(getApple));
        
        LCDPrintf(WHITE,BG_COLOR,50,560,1,"Frame: %d",TIMER->TIME-nowTime);

        if(isPageChange)
        {
            mdelay(500);
            ConfigEnd(levelId,AppleNumber(getApple),gameStep,isWin);
            return PAGE_END;
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
}
