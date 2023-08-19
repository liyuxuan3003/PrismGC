#ifndef BUZZER_H
#define BUZZER_H

#include <stdint.h>

#include "Peripheral.h"

#define BUZ 0
#define AUD 1

typedef struct
{
    volatile uint32_t NOTE:4;
    volatile uint32_t NOTE_NC:28;
    volatile uint32_t TIME;
    volatile uint32_t OUTPUT:2;
    volatile uint32_t OUTPUT_NC:30;
} BuzzerType;

#define BUZZER ((BuzzerType *)BUZZER_BASE)

void BuzzerConfig();
void BuzzerOutput(uint8_t note,uint32_t time);

// #define T0 200
// #define T1 180

// #define N8(t) t 
// #define N4(t) t,t 
// #define N2(t) t,t,t,t

// #define L8 T1
// #define L4 T0,T1 
// #define L2 T0,T0,T0,T1

// static const uint8_t noteArr[] = 
// {
//     N4(1),N4(2),N4(3),N4(1),
//     N4(1),N4(2),N4(3),N4(1),
//     N4(3),N4(4),N2(5),
//     N4(3),N4(4),N2(5),
//     N8(5),N8(6),N8(5),N8(4),N4(3),N4(1),
//     N8(5),N8(6),N8(5),N8(4),N4(3),N4(1),
//     N4(1),N4(1),N2(1),
//     N4(1),N4(1),N2(1)
// };

// static const uint16_t noteLenArr[] =
// {
//     L4,L4,L4,L4,
//     L4,L4,L4,L4,
//     L4,L4,L2,
//     L4,L4,L2,
//     L8,L8,L8,L8,L4,L4,
//     L8,L8,L8,L8,L4,L4,
//     L4,L4,L2,
//     L4,L4,L2
// };

#endif