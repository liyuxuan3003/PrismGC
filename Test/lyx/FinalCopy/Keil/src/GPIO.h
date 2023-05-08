#ifndef GPIO_H
#define GPIO_H

#include <stdint.h>

#include "Peripheral.h"

//GPIO DEF
#define GPIOA_BASE (GPIO_BASE + 0x00)
#define GPIOA_ADDR (*(volatile unsigned *)GPIOA_BASE) 

#define GPIOB_BASE (GPIO_BASE + 0x10)
#define GPIOB_ADDR (*(volatile unsigned *)GPIOB_BASE) 

#define GPIOC_BASE (GPIO_BASE + 0x20)
#define GPIOC_ADDR (*(volatile unsigned *)GPIOC_BASE) 

#define GPIOD_BASE (GPIO_BASE + 0x30)
#define GPIOD_ADDR (*(volatile unsigned *)GPIOD_BASE) 

typedef struct
{
    volatile uint32_t I_DAT;
    volatile uint32_t O_ENA;
    volatile uint32_t O_DAT;
} GPIOType;

#define GPIOA ((GPIOType *)GPIOA_BASE)
#define GPIOB ((GPIOType *)GPIOB_BASE)
#define GPIOC ((GPIOType *)GPIOC_BASE)
#define GPIOD ((GPIOType *)GPIOD_BASE)

//IDAT
#define P     +0)&              //P-Pin         获取输入寄存器上的指定位的值

//OENA
#define I     +1)&=~            //I-Input       设置输出使能寄存器上的指定位为0 设置其为输入
#define O     +1)|=             //O-Output      设置输出使能寄存器上的指定位为1 设置其为输出

//ODAT
#define R     +2)&              //R-Register    获取输出寄存器上的指定位的值
#define L     +2)&=~            //L-Low         设置输出寄存器上的指定位为0 输出低电平
#define H     +2)|=             //H-High        设置输出寄存器上的指定位为1 输出高电平
#define V     +2)^=             //V-Reverse     翻转输出寄存器上的指定位

#define BASE(PORT) *((&(PORT))

#endif