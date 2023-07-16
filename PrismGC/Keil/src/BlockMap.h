#ifndef BLOCKMAP_H
#define BLOCKMAP_H

#include <stdint.h>

#define B_ICE 0
#define B_BAR 1
#define B_END 2
#define B_TRP 3
#define BUDIR 5     // DO NOT USE 4 HERE!
#define BDDIR 6
#define BLDIR 7
#define BRDIR 8
#define B_GRA 9
#define BHGRA 10
#define B1POR 11
#define B2POR 12
#define B3POR 13

#define MAP_W 12
#define MAP_H 12

#define APPLE_MAX 3

#define POR_NUM 3

typedef struct
{
    int32_t i;
    int32_t j;
} MapCoord;

MapCoord _MapCoord(int32_t i,int32_t j);
MapCoord MapCoordPlus(MapCoord a,MapCoord b);
MapCoord MapCoordMinus(MapCoord a,MapCoord b);
uint8_t MapCoordEqual(MapCoord a,MapCoord b);

typedef struct 
{
    uint8_t map[MAP_W][MAP_H];
    MapCoord coord;
    MapCoord coordApple[APPLE_MAX];
} LevelMap;

typedef struct
{
    MapCoord p1;
    MapCoord p2;
    uint8_t marker;
} PortalPair;

MapCoord PortalAnother(MapCoord here,PortalPair portal);
void PortalWrite(MapCoord coord,PortalPair *portal);

extern const LevelMap level1;
extern const LevelMap level2;
extern const LevelMap level3;
extern const LevelMap level4;
extern const LevelMap level5;
extern const LevelMap level6;
extern const LevelMap level7;
extern const LevelMap level8;
extern const LevelMap level9;
extern const LevelMap level10;
extern const LevelMap level11;
extern const LevelMap level12;
extern const LevelMap level13;
extern const LevelMap level14;
extern const LevelMap level15;
extern const LevelMap level16;
extern const LevelMap level17;
extern const LevelMap level18;
extern const LevelMap level19;
extern const LevelMap level20;
extern const LevelMap level21;
extern const LevelMap level22;
extern const LevelMap level23;
extern const LevelMap level24;
extern const LevelMap level25;
extern const LevelMap level26;
extern const LevelMap level27;
extern const LevelMap level28;

#endif