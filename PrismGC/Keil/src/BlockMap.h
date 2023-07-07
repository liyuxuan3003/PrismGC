#ifndef BLOCKMAP_H
#define BLOCKMAP_H

#include <stdint.h>

#define B_ICE 0
#define B_BAR 1
#define B_END 2
#define B_TRAP 3

#define MAP_W 12
#define MAP_H 12

typedef struct 
{
    uint8_t map[MAP_W][MAP_H];
    uint32_t istart;
    uint32_t jstart;
} LevelMap;

int initialLocation[]

extern LevelMap levelO;

#endif