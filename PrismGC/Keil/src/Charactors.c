#include "Charactors.h"
#include "GPULite.h"

void MainCharactor (uint32_t x,uint32_t y)
{
    uint32_t l1[9]={BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK};
    uint32_t l2[13]={BLACK,BLACK,LIGHTBLUE,LIGHTBLUE,LIGHTBLUE,LIGHTBLUE,LIGHTBLUE,LIGHTBLUE,LIGHTBLUE,LIGHTBLUE,LIGHTBLUE,BLACK,BLACK};
    uint32_t l3[15]={BLACK,LIGHTBLUE,LIGHTBLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,LIGHTBLUE,LIGHTBLUE,BLACK};
    uint32_t l4[15]={BLACK,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLACK};
    uint32_t l5[15]={BLACK,BLUE,BLUE,WHITE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,WHITE,BLUE,BLUE,BLACK};
    uint32_t l6[16]={BLACK,LIGHTBLUE,BLUE,BLUE,BLACK,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLACK,BLUE,BLUE,LIGHTBLUE,BLACK};
    uint32_t l7[16]={BLACK,BLUE,BLUE,BLUE,BLACK,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLACK,BLUE,BLUE,BLUE,BLACK};
    uint32_t l8[16]={BLACK,BLUE,BLUE,BLUE,DARKBLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,DARKBLUE,BLUE,BLUE,BLUE,BLACK};
    uint32_t l9[16]={BLACK,DARKBLUE,DARKBLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,DARKBLUE,BLACK};
    uint32_t l10[15]={BLACK,BLACK,DARKBLUE,DARKBLUE,DARKBLUE,DARKBLUE,DARKBLUE,DARKBLUE,DARKBLUE,DARKBLUE,DARKBLUE,DARKBLUE,DARKBLUE,BLACK,BLACK};
    uint32_t l11[11]={BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK};

    LCDPixels(l1,x-4,y-2,9);
    LCDPixels(l2,x-6,y-1,13);
    LCDPixels(l3,x-7,y,15);
    LCDPixels(l4,x-7,y+1,15);
    LCDPixels(l5,x-7,y+2,15);
    LCDPixels(l6,x-8,y+3,16);
    LCDPixels(l7,x-8,y+4,16);
    LCDPixels(l8,x-8,y+5,16);
    LCDPixels(l9,x-8,y+6,16);
    LCDPixels(l10,x-7,y+7,15);
    LCDPixels(l11,x-7,y+8,11);

    // LCDPixels(l1,x-6,y-2,9);
    // LCDPixels(l2,x-6,y-1,13);
    // LCDPixels(l3,x-6,y,15);
    // LCDPixels(l4,x-6,y+1,15);
    // LCDPixels(l5,x-6,y+2,15);
    // LCDPixels(l6,x-6,y+3,16);
    // LCDPixels(l7,x-6,y+4,16);
    // LCDPixels(l8,x-6,y+5,16);
    // LCDPixels(l9,x-6,y+6,16);
    // LCDPixels(l10,x-6,y+7,15);
    // LCDPixels(l11,x-6,y+8,11);

    LCDPixel(DARKBLUE,x-10,y+2);
    LCDPixel(DARKBLUE,x+11,y+2);
    LCDPixel(DARKBLUE,x-13,y+2);
    LCDPixel(DARKBLUE,x+13,y+3);
    LCDPixel(DARKBLUE,x-12,y+5);
    LCDPixel(DARKBLUE,x+11,y+5);
}