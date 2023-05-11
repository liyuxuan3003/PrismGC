#include "HealthDetermination.h"

uint16_t HealthDetermination(uint16_t x1, uint16_t l, uint8_t Health)
{
    if(x1==16*l)
    {
        Health=Health;
    }
    else
    {
        Health=Health-1;
    }
    return Health;
}