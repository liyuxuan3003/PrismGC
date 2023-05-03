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

int rectangle(int b,int x1,int x2,int y1,int y2);
int bianliang(int a);
int canshuA(int a);
int panding(int y1,int y2,int b);
int jiasu(int t,int y2);
int xueliang(int xue);
int xueliangjisuan(int xue,int b);
int xueliangjisuan1(int xue,int b);

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
        int x1=300,y1=0,x2=400,y2=100,b=0,a=0,t=0,xue=3;
        while(xue>0)
        {
            int x1=300,y1=0,x2=400,y2=100;
            a=canshuA(a);
            b=bianliang(a);
            while(y2<=800)
            {
                xueliang(xue);
                rectangle(b,x1,x2,y1,y2);
                if(y2==600)
                {
                    lcd_draw_line(0,600,1000,600,BLACK);
                    xue=xueliangjisuan(xue,b);
                    panding(y1,y2,b);
                    y2=panding(y1,y2,b);
                    t=jiasu(t,y2);
                    y1=y2-100;
                    delay_ms(500-t*10);
                    lcd_clear(WHITE);
                    continue;
                }
                else
                {
                    lcd_draw_line(0,600,1000,600,BLACK);
                    xue=xueliangjisuan1(xue,b);
                    y1=y1+100;
                    y2=y2+100;
                    delay_ms(500-t*10);
                    lcd_clear(WHITE);
                    continue;
                }
            };
            continue;
        };
        lcd_draw_rectangle(40,350,140,450,RED);
        lcd_draw_rectangle(190,350,290,450,GREEN);
        lcd_draw_rectangle(340,350,440,450,BLUE);
        delay_ms(2000);
    }        
    else
    {
        text_show_string(30,  50, 1000, 16, "Please click on KEY_UP Button Start the game", 16, 0, RED);
        delay_us(1);
    };
    return 0;
    }

int rectangle(int b,int x1,int x2,int y1,int y2)
{
    if(b<16)
    {
        lcd_draw_rectangle(x1,y1,x2,y2,GREEN);
    }
    else if(b<48)
    {
        lcd_draw_rectangle(x1,y1,x2,y2,RED);
    }
    else if(b<72)
    {
        lcd_draw_rectangle(x1,y1,x2,y2,BLUE);
    }
    else
    {
        lcd_draw_rectangle(x1,y1,x2,y2,RED);
    }
};
int bianliang(int a)
{
    int b;
    if(a<=8&&a>=0)
    {
        b=a*a;
        return b;
    }
    else
    {
        b=a-8;
        return b;
    }
}
int canshuA(int a)
{
    if(a<=8)
    {
        a=a+2;
    }
    else
    {
        a=a-8;
    }
    return a;
}

int panding(int y1,int y2,int b)
{
    if(b>=16&&b<48)
    {
        if(key_scan(1) == KEY0_PRES)
        {
            y2=1000;
        }
        else
        {
            y1=y1+100;
            y2=y2+100;
        } 
    }
    else
    {
        if(key_scan(1) == KEY1_PRES)
        {
            y2=1000;
        }
        else
        {
            y1=y1+100;
            y2=y2+100;
        } 
    }
    return y2;
}

int jiasu(int t,int y2)
{
    if(y2==1000)
    {
        t=t+1;
    }
    else
    {
        t=t;
    }
    return t;
}
int xueliang(int xue)
{
    if(xue==3)
    {
        lcd_draw_rectangle(10,10,50,50,RED);
        lcd_draw_rectangle(60,10,100,50,RED);
        lcd_draw_rectangle(110,10,150,50,RED);
    }
    else if(xue==2)
    {
        lcd_draw_rectangle(10,10,50,50,RED);
        lcd_draw_rectangle(60,10,100,50,RED);
    }
    else if(xue==1)
    {
        lcd_draw_rectangle(10,10,50,50,RED);
    }
}
int xueliangjisuan(int xue,int b)
{
    if(b>=16&&b<48)
    {
        if(key_scan(1) == KEY0_PRES)
        {
            xue=xue;
        }
        else
        {
            xue=xue-1;
        } 
    }
    else
    {
        if(key_scan(1) == KEY1_PRES)
        {
            xue=xue;
        }
        else
        {
            xue=xue-1;
        } 
    }
    return xue;
}
int xueliangjisuan1(int xue,int b)
{
    if(b>=16&&b<48)
    {
        if(key_scan(1) == KEY0_PRES)
        {
            xue=xue-1;
        }
        else
        {
            xue=xue;
        } 
    }
    else
    {
        if(key_scan(1) == KEY1_PRES)
        {
            xue=xue-1;
        }
        else
        {
            xue=xue;
        } 
    }
    return xue;
}










