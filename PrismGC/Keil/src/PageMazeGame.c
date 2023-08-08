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

static MapCoord CoordNext(MapCoord coord,uint8_t direction,MapCoord *moveProcess,uint32_t *mpLen,MapCoord *hitCoord,uint32_t *animalVec,MapCoord coordMcgAct)
{
    uint32_t mpI=0;
    uint32_t isMcgChange=0;
    *mpLen=0;
    *hitCoord=_MapCoord(-1,-1);
    MapCoord unitVec=_MapCoord(0,0);
    switch (direction)
    {
        case KEY_R: unitVec=_MapCoord(0,+1); *animalVec=4; break;
        case KEY_L: unitVec=_MapCoord(0,-1); *animalVec=3; break;
        case KEY_U: unitVec=_MapCoord(-1,0); *animalVec=1; break;
        case KEY_D: unitVec=_MapCoord(+1,0); *animalVec=2; break;
    }

    MapCoord coordResult=coord;
    MapCoord coordStep=coord;
    MapCoord coordMcgTest=coord;

    while(1)
    {
        coordStep=MapCoordPlus(coordStep,unitVec);

        uint8_t flag=0;
        if(CoordVailed(coordStep))
        {
            uint8_t blk=map.map[coordStep.i][coordStep.j];
            MapCoord portalCoord=_MapCoord(0,0);

            if(MapCoordEqual(coordStep,coordMcgAct))
                isMcgChange=1;

            if(blk!=B_BAR && blk!=B_GRA && blk!=BMCGB)
            {
                coordMcgTest=coordResult;
                coordResult=coordStep;
                moveProcess[mpI]=coordStep;
                if(blk == BMCGI && isMcgChange==1)
                    moveProcess[mpI]=coordMcgTest;
                mpI++;
            }

            switch(blk)
            {
                case B_ICE: break;
                case BMCGI: 
                {
                    if(isMcgChange==1)
                    {
                        coordResult=coordMcgTest;
                        flag=1;
                        break;
                    }
                    else
                        break;
                }
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
                case BMCGB: 
                {
                    if(isMcgChange==1)
                    {
                        coordMcgTest=coordResult;
                        coordResult=coordStep;
                        moveProcess[mpI]=coordStep;
                        mpI++;
                        break;
                    }
                    else
                    {
                        flag=1;
                        break;
                    }
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

static void MapFix()
{
    LCDRectangle(BG_COLOR,
        H_DISP/4-8,
        0,
        H_DISP/4+8,
        V_DISP);

    return;
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
        default: pmap=&level1;  break;
    }

    for(uint32_t i=0;i<POR_NUM;i++)
    {
        portal[i].p1=_MapCoord(0,0);
        portal[i].p2=_MapCoord(0,0);
        portal[i].marker=0;
    } 

    map.coord=pmap->coord;
    // map.coordAnimal=pmap->coordAnimal;
    map.coordMcgAct=pmap->coordMcgAct;
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

// static MapCoord AnimalCoordNext(MapCoord coordAnimal,uint32_t animalVec,MapCoord *animalMoveProcess,uint32_t *mapLen)
// {
//     MapCoord animalCoordStep=coordAnimal;
//     MapCoord animalCoordNext=coordAnimal;
//     MapCoord animalMoveVec=_MapCoord(0,0);
//     uint8_t mapI=0;
//     *mapLen=0;
//     switch (animalVec)
//     {
//         case 3: animalMoveVec=_MapCoord(+1,0); break;
//         case 2: animalMoveVec=_MapCoord(-1,0); break;
//         case 1: animalMoveVec=_MapCoord(0,+1); break;
//         case 4: animalMoveVec=_MapCoord(0,-1); break;
//         default: break;
//     }
//     while(1)
//     {
//         animalCoordNext=MapCoordPlus(animalCoordNext,animalMoveVec);
//         uint8_t flag=0;
//         if(CoordVailed(animalCoordNext))
//         {
//             uint8_t blk=map.map[animalCoordNext.i][animalCoordNext.j];
//             if(blk == B_ICE)
//             {
//                 animalCoordStep=animalCoordNext;
//                 animalMoveProcess[mapI]=animalCoordNext;
//                 mapI++;
//             }
//             else
//             {
//                 flag=1;
//             }
//         }
//         if(flag==1)
//         {
//             *mapLen=mapI;
//             return animalCoordStep;
//         }

//     }
// }

// static uint8_t isAroundAnimal(MapCoord coord,MapCoord coordAnimal)
// {
//     if(MapCoordEqual(MapCoordPlus(coordAnimal,_MapCoord(+1,0)),coord))
//         return 1;
//     else if(MapCoordEqual(MapCoordPlus(coordAnimal,_MapCoord(-1,0)),coord))
//         return 1;
//     else if(MapCoordEqual(MapCoordPlus(coordAnimal,_MapCoord(0,+1)),coord))
//         return 1;
//     else if(MapCoordEqual(MapCoordPlus(coordAnimal,_MapCoord(0,-1)),coord))
//         return 1;
//     else
//         return 0;
// }

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
    // MapCoord coordAnimal=map.coordAnimal;
    MapCoord coordMcgAct=map.coordMcgAct;

    MapCoord coordMechanismGate[MP_L];
    MapCoord moveProcess[MP_L];
    MapCoord animalMoveProcess[MP_L];
    uint32_t mpLen;
    uint32_t mapLen;
    uint32_t mcgNumber=0;
    uint32_t mpCirculate=0;
    uint32_t mapCirculate=0;
    uint32_t animalVec=0;
    uint8_t  mCGProcess=3;

    uint32_t isAnimate=0;
    uint32_t isAnimalAnimate=0;
    uint8_t isPageChange=0;
    uint8_t gameStep=0;
    uint8_t isWin=1;
    uint8_t isChange=0;
    uint8_t isMCGStart=0;

    uint8_t getApple[APPLE_MAX]={0};

    MapCoord hitCoord=_MapCoord(-1,-1);
    uint8_t waitHit=0;

    for(int8_t i=MAP_W-1;i>=0;i--)
    {
        for(int8_t j=MAP_H-1;j>=0;j--)
        {
            if(map.map[i][j] == B_MCG)
            {
                coordMechanismGate[mcgNumber]=_MapCoord(i,j); 
                mcgNumber++; 
                map.map[i][j]=BMCGB;
            }
        }
    }

    while(1)
    {
        nowTime = TIMER -> TIME;

        uint8_t key=GetKey();

        if(key == KEY_E)
            return PAGE_MAIN;

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
                    // case B_TRP: BlockTRP(x,y); break;
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
                    case BMCGI: 
                    {
                        if(isMCGStart==1)
                        {
                            BlockDOR(x,y,mCGProcess);
                            mCGProcess --;
                            if(mCGProcess==1)
                            {
                                isMCGStart=0;
                            }
                        }
                        else
                        {
                            BlockDOR(x,y,mCGProcess);
                        }
                        break;
                    }
                    case BMCGB:
                    {
                        if(isMCGStart==1)
                        {
                            BlockDOR(x,y,mCGProcess);
                            mCGProcess ++;
                            if(mCGProcess==3)
                            {
                                isMCGStart=0;
                            }
                        }
                        else
                        {
                            BlockDOR(x,y,mCGProcess);
                        }
                        break;
                    }
                }

                for(uint32_t m=0;m<APPLE_MAX;m++)
                    if(MapCoordEqual(map.coordApple[m],_MapCoord(i,j)) && !getApple[m])
                        Apple(x,y,2);
            }
        }
        
        if(mcgNumber != 0)
        {
            BlockBUT(CalX(coordMcgAct),CalY(coordMcgAct),mCGProcess);
        }

        // LCDPrintf(BLACK,BISQUE,50,300,1,"coordAnimal.i: %02d",coordAnimal.i);
        // LCDPrintf(BLACK,BISQUE,50,400,1,"coordAnimal.j: %02d",coordAnimal.j);
        // LCDPrintf(BLACK,BISQUE,50,350,1,"animalVec: %02d",animalVec);
        // LCDPrintf(BLACK,BISQUE,50,350,1,"B_MCG: %02d",map.map[coordMechanismGate.i][coordMechanismGate.j]);
        // LCDPrintf(BLACK,BISQUE,50,400,1,"coordMechanismGate.i: %02d",coordMechanismGate.i);
        // LCDPrintf(BLACK,BISQUE,50,450,1,"coordMechanismGate.j: %02d",coordMechanismGate.j);
        
        MapFix();

        // LCDPrintf(BLACK,WHITE,50,450,1,"%d,%d : %d,%d",
        //     portal[0].p1.i,portal[0].p1.j,
        //     portal[0].p2.i,portal[0].p2.j);
        // LCDPrintf(BLACK,WHITE,50,470,1,"%d,%d : %d,%d",
        //     portal[1].p1.i,portal[1].p1.j,
        //     portal[1].p2.i,portal[1].p2.j);
        // LCDPrintf(BLACK,WHITE,50,490,1,"%d,%d : %d,%d",
        //     portal[2].p1.i,portal[2].p1.j,
        //     portal[2].p2.i,portal[2].p2.j);

        // LCDPrintf(0x000000,0xFFFFFF,50,450,1,"i: %d",coord.i);
        // LCDPrintf(0x000000,0xFFFFFF,50,500,1,"j: %d",coord.j);

        if(!isAnimate)
        {
            MainCharactor(CalX(coord),CalY(coord),2);

            if(map.map[coord.i][coord.j]==B_END)
            {
                isPageChange=1;
                isWin=1;
            }
            else if(map.map[coord.i][coord.j]==B_TRP)
            {
                isPageChange=1;
                isWin=0;
            }

            if(IsDirection(key))
            {
                // 情况1：正常移动了若干格 首末坐标不等 距离不等于零
                // 情况3：向折射方格移动 回到原位 首末坐标相等 距离不等于零
                // 情况2：向墙壁移动 首末坐标相等 距离等于零
                MapCoord coordNext=CoordNext(coord,key,moveProcess,&mpLen,&hitCoord,&animalVec,coordMcgAct);
                if(mpLen!=0)
                {
                    coord=coordNext;
                    gameStep++;
                    isAnimate=1;
                    mpCirculate=0;
                }
            }

            // if(isAroundAnimal(coord,coordAnimal))
            // {
            //     isAnimalAnimate=1;
            //     coordAnimal=AnimalCoordNext(coordAnimal,animalVec,animalMoveProcess,&mapLen);
            //     mapCirculate=0;
            // }

        }
        else
        {
            MainCharactor(CalX(moveProcess[mpCirculate]),CalY(moveProcess[mpCirculate]),2);
            
            for(uint32_t m=0;m<APPLE_MAX;m++)
            {
                if(MapCoordEqual(moveProcess[mpCirculate],map.coordApple[m]) && !getApple[m])
                {
                    getApple[m]=1;
                    BUZZER -> NOTE = 2; 
                    BUZZER -> TIME = 200;
                }
            }

            switch(GetBlockType(moveProcess[mpCirculate]))
            {
                case B1POR: BUZZER -> NOTE = 7; BUZZER -> TIME = 40; break;
                case B2POR: BUZZER -> NOTE = 7; BUZZER -> TIME = 40; break;
                case B3POR: BUZZER -> NOTE = 7; BUZZER -> TIME = 40; break;
                case BLDIR: BUZZER -> NOTE = 5; BUZZER -> TIME = 80; break;
                case BRDIR: BUZZER -> NOTE = 5; BUZZER -> TIME = 80; break;
                case BUDIR: BUZZER -> NOTE = 5; BUZZER -> TIME = 80; break;
                case BDDIR: BUZZER -> NOTE = 5; BUZZER -> TIME = 80; break;
                case B_END: BUZZER -> NOTE = 4; BUZZER -> TIME = 500; break;
                default: break;
            }

            if(MapCoordEqual(moveProcess[mpCirculate],coordMcgAct))
            {
                isChange++;
                BUZZER -> NOTE = 5; BUZZER -> TIME = 80;
                isMCGStart=1;
                if(isChange%2==0)
                    for(int i=0; i < mcgNumber; i++)
                        map.map[coordMechanismGate[i].i][coordMechanismGate[i].j]=BMCGB;
                else
                    for(int i=0; i < mcgNumber; i++)
                        map.map[coordMechanismGate[i].i][coordMechanismGate[i].j]=BMCGI;
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
                        BUZZER -> NOTE = 1; 
                        BUZZER -> TIME = 200;
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

        // if(!isAnimalAnimate)
        //     BlockANM(CalX(coordAnimal),CalY(coordAnimal));

        // else
        // {
        //     BlockANM(CalX(animalMoveProcess[mapCirculate]),CalY(animalMoveProcess[mapCirculate]));
        //     mapCirculate++;
        //     if(mapCirculate == mapLen)
        //         isAnimalAnimate=0;
        // }

        LCDPrintf(WHITE,BG_COLOR,50,50,3,"Level %02d",levelId);
        LCDPrintf(WHITE,BG_COLOR,50,180,2,"Step: %d",gameStep);
        LCDPrintf(WHITE,BG_COLOR,50,260,2,"Apples: %d",AppleNumber(getApple));
        
        LCDPrintf(WHITE,BG_COLOR,50,560,1,"Frame: %d",TIMER->TIME-nowTime);

        if(isPageChange)
        {
            ConfigEnd(levelId,AppleNumber(getApple),gameStep,isWin);
            return PAGE_END;
        }

        while(TIMER -> TIME < nowTime + FRAME);
    }
}
