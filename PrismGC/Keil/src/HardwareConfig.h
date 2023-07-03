#ifndef HARDWARECONFIG_H
#define HARDWARECONFIG_H

#include "BitOperate.h"
#include "GPIO.h"

#define SWI_0(X) (BASE(GPIOA_ADDR) X BIT(0))
#define SWI_1(X) (BASE(GPIOA_ADDR) X BIT(1))
#define SWI_2(X) (BASE(GPIOA_ADDR) X BIT(2))
#define SWI_3(X) (BASE(GPIOA_ADDR) X BIT(3))
#define SWI_4(X) (BASE(GPIOA_ADDR) X BIT(4))
#define SWI_5(X) (BASE(GPIOA_ADDR) X BIT(5))
#define SWI_6(X) (BASE(GPIOA_ADDR) X BIT(6))
#define SWI_7(X) (BASE(GPIOA_ADDR) X BIT(7))

#define LED_0(X) (BASE(GPIOA_ADDR) X BIT(8))
#define LED_1(X) (BASE(GPIOA_ADDR) X BIT(9))
#define LED_2(X) (BASE(GPIOA_ADDR) X BIT(10))
#define LED_3(X) (BASE(GPIOA_ADDR) X BIT(11))
#define LED_4(X) (BASE(GPIOA_ADDR) X BIT(12))
#define LED_5(X) (BASE(GPIOA_ADDR) X BIT(13))
#define LED_6(X) (BASE(GPIOA_ADDR) X BIT(14))
#define LED_7(X) (BASE(GPIOA_ADDR) X BIT(15))

#define SCL(X) (BASE(GPIOB_ADDR) X BIT(0))
#define SDA(X) (BASE(GPIOB_ADDR) X BIT(1))

typedef struct
{
    volatile uint8_t   I_SWI_DAT;
    volatile uint8_t   I_LED_DAT;
    volatile uint16_t  I_RESERVED_DAT;
    
    volatile uint8_t   O_SWI_ENA;
    volatile uint8_t   O_LED_ENA;
    volatile uint16_t  O_RESERVED_ENA;

    volatile uint8_t   O_SWI_DAT;
    volatile uint8_t   O_LED_DAT;
    volatile uint16_t  O_RESERVED_DAT;
} PORTAType;

typedef struct
{
    volatile uint8_t  I_DB_DAT;
    volatile uint32_t I_RESERVED_DAT:24;
    
    volatile uint8_t  O_DB_ENA;
    volatile uint32_t O_RESERVED_ENA:24;

    volatile uint8_t  O_DB_DAT;
    volatile uint32_t O_RESERVED_DAT:24;
} PORTBType;

#define PORTA ((PORTAType *)GPIOA_BASE)
#define PORTB ((PORTBType *)GPIOB_BASE)

#endif