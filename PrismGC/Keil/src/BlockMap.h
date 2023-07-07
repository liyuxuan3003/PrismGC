#ifndef BLOCKMAP_H
#define BLOCKMAP_H

#include <stdint.h>

#define B_ICE 0
#define B_BAR 1

#define MAP_W 12
#define MAP_H 12

const uint8_t level1[MAP_W][MAP_H]=
{
    {B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR,B_BAR},
    {},
}

#endif