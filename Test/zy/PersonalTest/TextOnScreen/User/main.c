/**
 ****************************************************************************************************
 * @file        main.c
 * @author      正点原子团队(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-28
 * @brief       图片显示 实验
 * @license     Copyright (c) 2020-2032, 广州市星翼电子科技有限公司
 ****************************************************************************************************
 * @attention
 *
 * 实验平台:正点原子 STM32F103开发板
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
 * @brief       得到path路径下,目标文件的总个数
 * @param       path : 路径
 * @retval      总有效文件数
 */


int main(void)
{
    uint8_t res;
    DIR picdir;           /* 图片目录 */
    FILINFO *picfileinfo; /* 文件信息 */
    char *pname;          /* 带路径的文件名 */
    uint16_t totpicnum;   /* 图片文件总数 */
    uint16_t curindex;    /* 图片当前索引 */
    uint8_t key;          /* 键值 */
    uint8_t pause = 0;    /* 暂停标记 */
    uint8_t t;
    uint16_t temp;
    uint32_t *picoffsettbl; /* 图片文件offset索引表 */

    HAL_Init();                         /* 初始化HAL库 */
    sys_stm32_clock_init(RCC_PLL_MUL9); /* 设置时钟, 72Mhz */
    delay_init(72);                     /* 延时初始化 */
    usart_init(115200);                 /* 串口初始化为115200 */
    usmart_dev.init(72);                /* 初始化USMART */
    led_init();                         /* 初始化LED */
    lcd_init();                         /* 初始化LCD */
    key_init();                         /* 初始化按键 */
    my_mem_init(SRAMIN);                /* 初始化内部SRAM内存池 */

    exfuns_init();           /* 为fatfs相关变量申请内存 */
    f_mount(fs[0], "0:", 1); /* 挂载SD卡 */
    f_mount(fs[1], "1:", 1); /* 挂载FLASH */
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













