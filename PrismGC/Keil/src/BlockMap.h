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
#define B_ANM 14
#define B_MCG 15
#define BMCGB 16
#define BMCGI 17
#define B_BUT 18

#define MAP_W 12
#define MAP_H 12

#define APPLE_MAX 3
#define CHARA_MAX 3

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
    // MapCoord coordAnimal;
    // MapCoord coordMcgAct;
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
extern const LevelMap level29;
extern const LevelMap level30;
extern const LevelMap level31;
extern const LevelMap level32;
extern const LevelMap level33;
extern const LevelMap level34;
extern const LevelMap level35;
extern const LevelMap level36;
extern const LevelMap level37;
extern const LevelMap level38;
extern const LevelMap level39;
extern const LevelMap level40;
extern const LevelMap level41;
extern const LevelMap level42;
extern const LevelMap level43;
extern const LevelMap level44;
extern const LevelMap level45;
extern const LevelMap level46;
extern const LevelMap level47;
extern const LevelMap level48;

#endif