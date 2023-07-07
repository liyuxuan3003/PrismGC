#ifndef PAGEBLOCKGAME_H
#define PAGEBLOCKGAME_H

#include <stdint.h>

#define BLOCK_WIDTH 20
#define BLOCK_HEIGHT 20

#define X1_BLOCK_PLACE 400
#define X2_BLOCK_PLACE 420
#define Y1_BLOCK_PLACE 0
#define Y2_BLOCK_PLACE 20

#define INIT_SCORE 0
#define UP_SCORE 5
#define INIT_HEALTH 5
#define DOWN_HEALTH 1 

uint8_t PageBlockGame();

#endif