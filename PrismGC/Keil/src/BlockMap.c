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
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_END},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
        {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
    },
    {4,0}
};

// //障碍BAR 冰面ICE 陷阱TRA 机关MEC 碎石GRA 传送DEL 终点END    小兽ANM
// const LevelMap level1=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_TRA,B_TRA,B_ICE,B_ICE,B_ICE,B_ICE,B_END},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level2=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_MEC,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_TRA,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_TRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_TRA,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level3=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_END,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level4=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_DEL,B_ICE,B_ICE,B_END,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_DEL,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_TRA,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_END,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_TRA,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level5=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ANM,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ANM,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_END,B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level6=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ANM,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_END,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ANM,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level7=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ANM,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ANM,B_ANM,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_END,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_TRA,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level8=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ANM,B_ICE,B_ICE,B_ANM,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_BAR,B_ANM,B_ICE,B_BAR,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_END,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level9=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_ANM,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ANM,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_BAR,B_BAR,B_BAR,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_END,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level10=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ANM,B_ICE,B_ICE,B_GRA,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_TRA,B_GRA,B_END,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_TRA,B_GRA,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_TRA,B_GRA,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_GRA,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_GRA,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level11=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_END,B_GRA,B_DEL,B_ICE,B_ANM,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ANM,B_GRA,B_ICE,B_DEL,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level12=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_ANM,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_END,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_GRA,B_DEL,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ANM,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_TRA,B_GRA,B_ICE,B_ICE,B_DEL,B_BAR,B_DEL,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };

// const LevelMap level13=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ANM,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_END,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_MEC,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_MEC,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ANM,B_ICE,B_ICE,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// }

// const initialLocation[25]={4,0,5,2,3,8,3,3,8,2,3,3,8,5,8,5,4,7,6,2,8,5,5,9,8,2};//i，j










// LevelMap levelO=
// {
//     {
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_ICE,B_ICE,B_BAR,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_MEC,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_TRA,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_END,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_TRA,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_TRA,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_ICE,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
//         {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR}
//     },
// };
