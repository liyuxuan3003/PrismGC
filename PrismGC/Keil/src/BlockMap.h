#ifndef BLOCKMAP_H
#define BLOCKMAP_H

#include <stdint.h>

#define B_ICE 0
#define B_BAR 1
#define B_END 2
#define B_TRP 3
#define BUDIR 4
#define BDDIR 5
#define BLDIR 6
#define BRDIR 7

#define MAP_W 12
#define MAP_H 12

#define APPLE_MAX 3

typedef struct
{
    int32_t i;
    int32_t j;
} MapCoord;

MapCoord _MapCoord(int32_t i,int32_t j);
MapCoord MapCoordPlus(MapCoord a,MapCoord b);
MapCoord MapCoordMinus(MapCoord a,MapCoord b);
uint8_t MapCoordEqual(MapCoord a,MapCoord b);

// uint8_t MapCoordEqual(MapCoord a,MapCoord b,uint32_t mpLen);
// uint8_t _MapCoordEqual(MapCoord a,MapCoord b);

typedef struct 
{
    uint8_t map[MAP_W][MAP_H];
    MapCoord coord;
    MapCoord coordApple[APPLE_MAX];
} LevelMap;

extern const LevelMap level1;
extern const LevelMap level2;

#endif