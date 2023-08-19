#include "BlockMap.h"

MapCoord _MapCoord(int32_t i,int32_t j)
{
    MapCoord coord={i,j};
    return coord;
}

MapCoord MapCoordPlus(MapCoord a,MapCoord b)
{
    MapCoord result;
    result.i=a.i+b.i;
    result.j=a.j+b.j;
    return result;
}

MapCoord MapCoordMinus(MapCoord a,MapCoord b)
{
    MapCoord result;
    result.i=a.i-b.i;
    result.j=a.j-b.j;
    return result;
}

uint8_t MapCoordEqual(MapCoord a,MapCoord b)
{
    return (a.i==b.i && a.j==b.j);
}

MapCoord PortalAnother(MapCoord here,PortalPair portal)
{
    if(MapCoordEqual(portal.p1,here))
        return portal.p2;
    else
        return portal.p1;
}

void PortalWrite(MapCoord coord,PortalPair *portal)
{
    switch(portal->marker)
    {
        case 0: portal->p1=coord; portal->marker++; break;
        case 1: portal->p2=coord; portal->marker++; break;
        default: break;
    }
}

const LevelMap level1=
{
    {
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_END,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
    },
    {4,0},
    {{7,4},{4,4},{5,11}},
};
//RDRU L

const LevelMap level2=
{
    {
        {B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {0,0},
    {{3,0},{0,7},{10,7}},
};
//DRUL DRUL D

const LevelMap level3=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE}
    },
    {3,3},
    {{0,1},{6,0},{11,11}},
};
//ULDR DLUR DLU

const LevelMap level4=
{
    {
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_END,BLDIR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {BRDIR,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
    },
    {4,0},
    {{6,0},{7,2},{6,5}},
};
//DRRU 

const LevelMap level5=
{
    {
        {B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE,B_ICE,B_END,B_ICE,BLDIR,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BRDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,BRDIR,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,BRDIR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {0,0},
    {{4,1},{6,3},{5,11}},
};
//DRUL DDRU RDUL D

const LevelMap level6=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_END,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR},
        {B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {5,4},
    {{8,0},{11,5},{3,0}},
};
//UDRD LUDR

const LevelMap level7=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BDDIR},
        {B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE},
        {B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END}
    },
    {0,0},
    {{1,5},{1,11},{5,1}},
};
//DRDR LDRR UDR

const LevelMap level8=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,BDDIR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE,BRDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,BRDIR,B_ICE,B_ICE,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_END,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {6,6},
    {{8,3},{0,7},{7,11}},
};
//RDLU RLUL D

const LevelMap level9=
{
    {
        {B_ICE,B_ICE,B_ICE,BDDIR,B_END,B_ICE,B_ICE,B_ICE,BRDIR,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR}
    },
    {0,0},
    {{7,0},{0,10},{10,7}},
};
//DRRU RDLU DRL

const LevelMap level10=
{
    {
        {B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_ICE,BRDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {0,0},
    {{7,3},{8,0},{1,11}},
};
//DRDL URDU L

const LevelMap level11=
{
    {
        {B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA},
        {B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_GRA,B_END,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BLDIR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,BRDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE}
    },
    {5,4},
    {{0,0},{1,11},{6,10}},
};
//LULR RDDU

const LevelMap level12=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE},
        {B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_GRA,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_GRA},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_GRA,B_GRA,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_GRA,B_ICE,B_GRA,B_ICE,B_ICE,B_END,B_ICE,B_GRA,B_ICE,B_GRA,B_ICE}
    },
    {11,5},
    {{6,3},{5,6},{8,9}},
};
//UURR UULL DURD DRDD D

const LevelMap level13=
{
    {
        {B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_GRA,B_GRA,B_ICE,B_GRA,B_GRA,B_ICE,B_GRA,B_GRA,B_ICE,B_GRA,B_GRA},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_GRA,B_GRA,B_ICE,B_GRA,B_GRA,B_ICE,B_GRA,B_GRA,B_ICE,B_GRA,B_GRA},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_GRA,B_GRA,B_GRA,B_GRA,B_GRA,B_GRA,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE}
    },
    {3,1},
    {{11,5},{5,5},{1,9}},
};
//DRUU LDLD DRRU U

const LevelMap level14=
{
    {
        {B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,BDDIR,BDDIR,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_GRA,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_GRA,B_GRA,B_GRA},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,BLDIR,BLDIR,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,BRDIR,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,BRDIR,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,BUDIR,BDDIR,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_GRA,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_GRA,B_GRA},
        {B_ICE,B_ICE,B_GRA,B_ICE,BLDIR,B_ICE,B_ICE,BRDIR,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_GRA,B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE}
    },
    {10,6},
    {{3,0},{0,7},{10,7}},
};
//RRDU UULL LDDD RRRR U

const LevelMap level15=
{
    {
        {B_ICE,B_ICE,BLDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_GRA},
        {B_GRA,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE,B_ICE},
        {BUDIR,B_GRA,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_GRA,BDDIR},
        {B_ICE,BRDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,BUDIR,B_ICE,B_ICE,BRDIR,B_ICE,B_END}
    },
    {11,0},
    {{1,1},{0,9},{10,10}},
};
//RLDU RDRU DDD
//RLUU DURR DDR

const LevelMap level16=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,BDDIR,BLDIR,B_GRA,B_ICE,BLDIR,BLDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,BDDIR,BRDIR,BRDIR,B_ICE,B_GRA,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_GRA,BDDIR,BUDIR,B_ICE,B_ICE,B_ICE,BUDIR,B_GRA,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA},
        {B_GRA,B_ICE,BDDIR,BDDIR,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_GRA,B_ICE,B_ICE},
        {B_ICE,B_ICE,BDDIR,BRDIR,BRDIR,B_ICE,B_GRA,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,BRDIR,BRDIR,BRDIR,B_ICE,B_GRA,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {0,0},
    {{6,9},{11,11},{6,7}},
};
//RDLD RDLL URRD

const LevelMap level17=
{
    {
        {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END},
        {B_ICE,B_ICE,B_ICE,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
    },
    {6,0},
    {{0,4},{9,0},{10,2}},
};
//RULD LUDR URDR

const LevelMap level18=
{
    {
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_END},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE}
    },
    {2,10},
    {{2,5},{3,3},{11,5}},
};
//DLUR DRUR DR

const LevelMap level19=
{
    {
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B1POR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END},
        {B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B1POR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {2,1},
    {{2,0},{5,4},{11,11}},
};
//DRUL DR

const LevelMap level20=
{
    {
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B1POR,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_GRA,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_END,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B1POR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR}
    },
    {9,7},
    {{1,10},{11,7},{3,5}},
};

const LevelMap level21=
{
    {
        {B3POR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_GRA,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B1POR,B_ICE,B_ICE,B2POR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,BDDIR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_END,B_ICE,B_ICE,B3POR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_GRA},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE},
        {B2POR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B1POR}
    },
    {6,5},
    {{5,2},{9,11},{3,5}},
};

const LevelMap level22=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {9,7},
    {{1,10},{11,7},{3,5}},
};

const LevelMap level23=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {9,7},
    {{1,10},{11,7},{3,5}},
};

const LevelMap level24=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {9,7},
    {{1,10},{11,7},{3,5}},
};

const LevelMap level25=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {9,7},
    {{1,10},{11,7},{3,5}},
};

const LevelMap level26=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {9,7},
    {{1,10},{11,7},{3,5}},
};

const LevelMap level27=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {9,7},
    {{1,10},{11,7},{3,5}},
};

const LevelMap level28=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {9,7},
    {{1,10},{11,7},{3,5}},
};
//LDRU RLLD RULD LURU LDRD
//DULD RURL DLLU RULD RD