/**
 ****************************************************************************************************
 * @file        main.c
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-18
 * @brief       ������ ʵ��
 * @license     Copyright (c) 2020-2032, ������������ӿƼ����޹�˾
 ****************************************************************************************************
 * @attention
 *
 * ʵ��ƽ̨:����ԭ�� STM32������
 * ������Ƶ:www.yuanzige.com
 * ������̳:www.openedv.com
 * ��˾��ַ:www.alientek.com
 * �����ַ:openedv.taobao.com
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
    HAL_Init();                         /* ��ʼ��HAL�� */
    sys_stm32_clock_init(RCC_PLL_MUL9); /* ����ʱ��,72M */
    delay_init(72);                     /* ��ʼ����ʱ���� */
    led_init();                         /* ��ʼ��LED */
    beep_init();                        /* ��ʼ�������� */

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
