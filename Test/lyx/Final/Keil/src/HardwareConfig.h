#ifndef HARDWARECONFIG_H
#define HARDWARECONFIG_H

#include "BitOperate.h"
#include "GPIO.h"

#define SWI_0(X) (BASE(GPIOA_ADDR) X BIT(0))
#define LED_0(X) (BASE(GPIOA_ADDR) X BIT(8))
#define LED_1(X) (BASE(GPIOA_ADDR) X BIT(9))
typedef struct
{
    volatile uint8_t  I_SWI_DATA;
    volatile uint8_t  I_LED_DATA;
    volatile uint8_t  I_SEG_DATA;
    volatile uint8_t  I_SEGCS_DATA:4;
    volatile uint8_t  I_RESERVED_DATA:4;
    
    volatile uint8_t  O_SWI_EN;
    volatile uint8_t  O_LED_EN;
    volatile uint8_t  O_SEG_EN;
    volatile uint8_t  O_SEGCS_EN:4;
    volatile uint8_t  O_RESERVED_EN:4;

    volatile uint8_t  O_SWI_DATA;
    volatile uint8_t  O_LED_DATA;
    volatile uint8_t  O_SEG_DATA;
    volatile uint8_t  O_SEGCS_DATA:4;
    volatile uint8_t  O_RESERVED_DATA:4;
} PORTAType;

#define PORTA ((PORTAType *)GPIOA_BASE)

#endif