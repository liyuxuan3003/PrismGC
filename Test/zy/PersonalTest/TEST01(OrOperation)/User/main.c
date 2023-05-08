/**
 ****************************************************************************************************
 * @file        main.c
 * @author      正点原子团队(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-18
 * @brief       蜂鸣器 实验
 * @license     Copyright (c) 2020-2032, 广州市星翼电子科技有限公司
 ****************************************************************************************************
 * @attention
 *
 * 实验平台:正点原子 STM32开发板
 * 在线视频:www.yuanzige.com
 * 技术论坛:www.openedv.com
 * 公司网址:www.alientek.com
 * 购买地址:openedv.taobao.com
 *
 ****************************************************************************************************
 */

#include "./SYSTEM/sys/sys.h"
#include "./SYSTEM/usart/usart.h"
#include "./SYSTEM/delay/delay.h"
#include "./BSP/LED/led.h"
#include "./BSP/BEEP/beep.h"
#include <stdio.h>


int main(void)
{
    HAL_Init();                         /* 初始化HAL库 */
    sys_stm32_clock_init(RCC_PLL_MUL9); /* 设置时钟,72M */
    delay_init(72);                     /* 初始化延时函数 */
    led_init();                         /* 初始化LED */
    beep_init();                        /* 初始化蜂鸣器 */

    while (1)
    {
        LED0(1);
        LED1(1);
        BEEP(0);
        delay_ms(1000);
        LED0(0);
        LED1(1);
        BEEP(1);
        delay_ms(1000);
        LED0(1);
        LED1(0);
        BEEP(1);
        delay_ms(1000);
        LED0(0);
        LED1(0);
        BEEP(1);
        delay_ms(1000);
    }
    printf("Hello world!/r/n");
    uint32_t temp=10;
    printf("%d/r/n",temp);
}
