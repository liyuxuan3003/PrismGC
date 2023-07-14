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

const LevelMap level3=
{
    {
        {B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
    },
    {3,3},
    {{0,2},{9,0},{7,8}},
};

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
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BLDIR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
    },
    {0,0},
    {{7,3},{8,0},{1,11}},
};

const LevelMap levelTest=
{
    {
        {B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_END},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,BUDIR,B_BAR,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_GRA,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_GRA,B_GRA,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_GRA,B_GRA,B_GRA,B_GRA,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
    },
    {4,0},
    {{7,3},{7,0},{6,5}},
};

// const LevelMap level3=
// {
//     {
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//     },
//     {0,0},
//     {{3,0},{0,7},{10,7}},
// };

// const LevelMap level2=
// {
//     {
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE}
//     },
//     {4,0},
//     {{7,3},{7,0},{6,5}},
// };
