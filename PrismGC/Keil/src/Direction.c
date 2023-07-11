#include "Direction.h"

void uint8_t GetDirection()
{
    switch(KEYBOARD->KEY)
    {
        case 0x05: return PMG_R; break;
        case 0x07: return PMG_L; break;
        case 0x0A: return PMG_U; break;
        case 0x02: return PMG_D; break;
    }
    switch(NunchuckKey())
    {
        case 'R': return PMG_R; break;
        case 'L': return PMG_L; break;
        case 'U': return PMG_U; break;
        case 'D': return PMG_D; break;
        default: return 0; break;
    }
}