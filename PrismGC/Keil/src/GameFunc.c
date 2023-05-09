#include "GameFunc.h"

#include "KeyBoard.h"

uint16_t MoveX(uint16_t x1)
{
    uint16_t xNext=x1;
    if(x1 >= BLOCK_SIZE && KEYBOARD -> KEY == 0x06)
        xNext -= H_SPEED;
    else if(x1 <= H_DISP-BLOCK_SIZE && KEYBOARD -> KEY == 0x05)
        xNext += H_SPEED;
    return xNext;
}