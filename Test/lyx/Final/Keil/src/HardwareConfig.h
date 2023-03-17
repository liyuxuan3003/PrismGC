#ifndef HARDWARECONFIG_H
#define HARDWARECONFIG_H

#include "BitOperate.h"
#include "GPIO.h"

#define SWI_0(X) (BASE(GPIOA_ADDR) X BIT(0))
#define LED_0(X) (BASE(GPIOA_ADDR) X BIT(8))
#define LED_1(X) (BASE(GPIOA_ADDR) X BIT(9))
typedef struct
{
    volatile uint8_t  I_SWI_DAT;
    volatile uint8_t  I_LED_DAT;
    volatile uint8_t  I_SEG_DAT;
    volatile uint8_t  I_SEGCS_DAT:4;
    volatile uint8_t  I_RESERVED_DAT:4;
    
    volatile uint8_t  O_SWI_ENA;
    volatile uint8_t  O_LED_ENA;
    volatile uint8_t  O_SEG_ENA;
    volatile uint8_t  O_SEGCS_ENA:4;
    volatile uint8_t  O_RESERVED_ENA:4;

    volatile uint8_t  O_SWI_DAT;
    volatile uint8_t  O_LED_DAT;
    volatile uint8_t  O_SEG_DAT;
    volatile uint8_t  O_SEGCS_DAT:4;
    volatile uint8_t  O_RESERVED_DAT:4;
} PORTAType;

typedef struct
{
    volatile uint8_t  I_LED_DAT;
    volatile uint8_t  I_SWI_DAT;
    volatile uint16_t I_RESERVED_DAT;
    
    volatile uint8_t  O_LED_ENA;
    volatile uint8_t  O_SWI_ENA;
    volatile uint16_t O_RESERVED_ENA;

    volatile uint8_t  O_LED_DAT;
    volatile uint8_t  O_SWI_DAT;
    volatile uint16_t O_RESERVED_DAT;
} PORTBType;

#define PORTA ((PORTAType *)GPIOA_BASE)
#define PORTB ((PORTBType *)GPIOB_BASE)

#endif