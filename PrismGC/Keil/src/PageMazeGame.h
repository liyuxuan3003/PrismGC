#ifndef PAGEMAZEGAME_H
#define PAGEMAZEGAME_H

#define PMG_L 1
#define PMG_R 2
#define PMG_U 3
#define PMG_D 4

#include "GPULite.h"
#include "Block.h"
#include "BlockMap.h"

#include <stdint.h>

#define X_CORNER (H_DISP/2)-(MAP_W-1)*BLOCK_SIZE+120
#define Y_CORNER (V_DISP/2)-(MAP_H-1)*BLOCK_SIZE

uint8_t PageMazeGame();

#endif