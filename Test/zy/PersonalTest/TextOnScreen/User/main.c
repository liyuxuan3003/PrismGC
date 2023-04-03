/**
 ****************************************************************************************************
 * @file        main.c
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-28
 * @brief       ͼƬ��ʾ ʵ��
 * @license     Copyright (c) 2020-2032, ������������ӿƼ����޹�˾
 ****************************************************************************************************
 * @attention
 *
 * ʵ��ƽ̨:����ԭ�� STM32F103������
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
#include "./USMART/usmart.h"
#include "./MALLOC/malloc.h"
#include "./FATFS/exfuns/exfuns.h"
#include "./TEXT/text.h"
#include "./BSP/LED/led.h"
#include "./BSP/LCD/lcd.h"
#include "./BSP/KEY/key.h"
#include "./BSP/SDIO/sdio_sdcard.h"
#include "./BSP/NORFLASH/norflash.h"
#include "./PICTURE/piclib.h"
#include "string.h"
#include "math.h"
#include <stdio.h>


/**
 * @brief       �õ�path·����,Ŀ���ļ����ܸ���
 * @param       path : ·��
 * @retval      ����Ч�ļ���
 */


int main(void)
{
    uint8_t res;
    DIR picdir;           /* ͼƬĿ¼ */
    FILINFO *picfileinfo; /* �ļ���Ϣ */
    char *pname;          /* ��·�����ļ��� */
    uint16_t totpicnum;   /* ͼƬ�ļ����� */
    uint16_t curindex;    /* ͼƬ��ǰ���� */
    uint8_t key;          /* ��ֵ */
    uint8_t pause = 0;    /* ��ͣ��� */
    uint8_t t;
    uint16_t temp;
    uint32_t *picoffsettbl; /* ͼƬ�ļ�offset������ */

    HAL_Init();                         /* ��ʼ��HAL�� */
    sys_stm32_clock_init(RCC_PLL_MUL9); /* ����ʱ��, 72Mhz */
    delay_init(72);                     /* ��ʱ��ʼ�� */
    usart_init(115200);                 /* ���ڳ�ʼ��Ϊ115200 */
    usmart_dev.init(72);                /* ��ʼ��USMART */
    led_init();                         /* ��ʼ��LED */
    lcd_init();                         /* ��ʼ��LCD */
    key_init();                         /* ��ʼ������ */
    my_mem_init(SRAMIN);                /* ��ʼ���ڲ�SRAM�ڴ�� */

    exfuns_init();           /* Ϊfatfs��ر��������ڴ� */
    f_mount(fs[0], "0:", 1); /* ����SD�� */
    f_mount(fs[1], "1:", 1); /* ����FLASH */
    if(key_scan(1) == WKUP_PRES)
    {
        int x=350,y=100,z=100,b=1,c=1;
        while(1)
        {
            if(y<500)
            {
                lcd_draw_circle(x,y,50,RED);
                delay_ms(500);
                y=y+100;
                lcd_clear(WHITE);
            }
            else if(y==500)
            {
                if (key_scan(1) == WKUP_PRES)
                {
                    lcd_clear(WHITE);
                    y=700;
                    z=100;
                    continue;
                }
                else
                {
                lcd_draw_circle(x,y,50,RED);
                delay_ms(500);
                y=y+100;
                lcd_clear(WHITE);
                };
            }
            else if(y==600)
            {
                lcd_draw_circle(x,y,50,RED);
                delay_ms(500);
                y=y+100;
                lcd_clear(WHITE);
            }
            else if(y<1100)
            {
                    lcd_draw_rectangle(300,z,400,z+100,GREEN);
                    delay_ms(500);
                    z=z+100;
                    y=y+100;
                    lcd_clear(WHITE);
            }
            else if(y==1100)
            {
                if (key_scan(1) == WKUP_PRES)
                {
                    lcd_clear(WHITE);
                    y=100;
                    z=100;
                    continue;
                }
                else
                {
                lcd_draw_rectangle(300,z,400,z+100,GREEN);
                delay_ms(500);
                z=z+100;
                y=y+100;
                lcd_clear(WHITE);
                };
            }
            else if(y==1200)
            {
                    lcd_draw_rectangle(300,z,400,z+100,GREEN);
                    delay_ms(500);
                    z=z+100;
                    y=y+100;
                    lcd_clear(WHITE);
            }
            else if(y==1300)
                {
                    y=100;
                    z=100;
                }
            };
        }
    else
    {
        text_show_string(30,  50, 1000, 16, "Please click on KEY_UP Button Start the game", 16, 0, RED);
        delay_us(1);
    };
    return 0;
    }













