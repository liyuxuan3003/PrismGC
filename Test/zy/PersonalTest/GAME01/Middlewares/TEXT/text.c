/**
 ****************************************************************************************************
 * @file        text.c
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-28
 * @brief       ������ʾ ����
 *              �ṩtext_show_font��text_show_string��������,������ʾ����
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
 * �޸�˵��
 * V1.0 20200428
 * ��һ�η���
 *
 ****************************************************************************************************
 */

#include "string.h"
#include "./TEXT/text.h"
#include "./BSP/LCD/lcd.h"
#include "./MALLOC/malloc.h"
#include "./SYSTEM/usart/usart.h"
#include "./BSP/NORFLASH/norflash.h"

/**
 * @brief       ��ȡ���ֵ�������
 * @param       code  : ��ǰ���ֱ���(GBK��)
 * @param       mat   : ��ǰ���ֵ������ݴ�ŵ�ַ
 * @param       size  : �����С
 *   @note      size��С������,��������ݴ�СΪ: (size / 8 + ((size % 8) ? 1 : 0)) * (size)  �ֽ�
 * @retval      ��
 */
static void text_get_hz_mat(unsigned char *code, unsigned char *mat, uint8_t size)
{
    unsigned char qh, ql;
    unsigned char i;
    unsigned long foffset;
    uint8_t csize = (size / 8 + ((size % 8) ? 1 : 0)) * (size); /* �õ�����һ���ַ���Ӧ������ռ���ֽ��� */
    qh = *code;
    ql = *(++code);

    if (qh < 0x81 || ql < 0x40 || ql == 0xff || qh == 0xff)   /* �� ���ú��� */
    {
        for (i = 0; i < csize; i++)
        {
            *mat++ = 0x00;  /* ������� */
        }

        return;     /* �������� */
    }

    if (ql < 0x7f)
    {
        ql -= 0x40; /* ע��! */
    }
    else
    {
        ql -= 0x41;
    }

    qh -= 0x81;
    foffset = ((unsigned long)190 * qh + ql) * csize;   /* �õ��ֿ��е��ֽ�ƫ���� */

    switch (size)
    {
        case 12:
            norflash_read(mat, foffset + ftinfo.f12addr, csize);
            break;

        case 16:
            norflash_read(mat, foffset + ftinfo.f16addr, csize);
            break;

        case 24:
            norflash_read(mat, foffset + ftinfo.f24addr, csize);
            break;
    }
}

/**
 * @brief       ��ʾһ��ָ����С�ĺ���
 * @param       x,y   : ���ֵ�����
 * @param       font  : ����GBK��
 * @param       size  : �����С
 * @param       mode  : ��ʾģʽ
 *   @note              0, ������ʾ(����Ҫ��ʾ�ĵ�,��LCD����ɫ���,��g_back_color)
 *   @note              1, ������ʾ(����ʾ��Ҫ��ʾ�ĵ�, ����Ҫ��ʾ�ĵ�, ��������)
 * @param       color : ������ɫ
 * @retval      ��
 */
void text_show_font(uint16_t x, uint16_t y, uint8_t *font, uint8_t size, uint8_t mode, uint16_t color)
{
    uint8_t temp, t, t1;
    uint16_t y0 = y;
    uint8_t *dzk;
    uint8_t csize = (size / 8 + ((size % 8) ? 1 : 0)) * (size);     /* �õ�����һ���ַ���Ӧ������ռ���ֽ��� */

    if (size != 12 && size != 16 && size != 24 && size != 32)
    {
        return;     /* ��֧�ֵ�size */
    }

    dzk = mymalloc(SRAMIN, size);       /* �����ڴ� */

    if (dzk == 0) return;               /* �ڴ治���� */

    text_get_hz_mat(font, dzk, size);   /* �õ���Ӧ��С�ĵ������� */

    for (t = 0; t < csize; t++)
    {
        temp = dzk[t];                  /* �õ��������� */

        for (t1 = 0; t1 < 8; t1++)
        {
            if (temp & 0x80)
            {
                lcd_draw_point(x, y, color);        /* ����Ҫ��ʾ�ĵ� */
            }
            else if (mode == 0)     /* ����ǵ���ģʽ, ����Ҫ��ʾ�ĵ�,�ñ���ɫ��� */
            {
                lcd_draw_point(x, y, g_back_color);  /* ��䱳��ɫ */
            }

            temp <<= 1;
            y++;

            if ((y - y0) == size)
            {
                y = y0;
                x++;
                break;
            }
        }
    }

    myfree(SRAMIN, dzk);    /* �ͷ��ڴ� */
}

/**
 * @brief       ��ָ��λ�ÿ�ʼ��ʾһ���ַ���
 *   @note      �ú���֧���Զ�����
 * @param       x,y   : ��ʼ����
 * @param       width : ��ʾ������
 * @param       height: ��ʾ����߶�
 * @param       str   : �ַ���
 * @param       size  : �����С
 * @param       mode  : ��ʾģʽ
 *   @note              0, ������ʾ(����Ҫ��ʾ�ĵ�,��LCD����ɫ���,��g_back_color)
 *   @note              1, ������ʾ(����ʾ��Ҫ��ʾ�ĵ�, ����Ҫ��ʾ�ĵ�, ��������)
 * @param       color : ������ɫ
 * @retval      ��
 */
void text_show_string(uint16_t x, uint16_t y, uint16_t width, uint16_t height, char *str, uint8_t size, uint8_t mode, uint16_t color)
{
    uint16_t x0 = x;
    uint16_t y0 = y;
    uint8_t bHz = 0;                /* �ַ��������� */
    uint8_t *pstr = (uint8_t *)str; /* ָ��char*���ַ����׵�ַ */

    while (*pstr != 0)   /* ����δ���� */
    {
        if (!bHz)
        {
            if (*pstr > 0x80)   /* ���� */
            {
                bHz = 1;    /* ��������� */
            }
            else            /* �ַ� */
            {
                if (x > (x0 + width - size / 2))    /* ���� */
                {
                    y += size;
                    x = x0;
                }

                if (y > (y0 + height - size))break; /* Խ�緵�� */

                if (*pstr == 13)   /* ���з��� */
                {
                    y += size;
                    x = x0;
                    pstr++;
                }
                else
                {
                    lcd_show_char(x, y, *pstr, size, mode, color);   /* ��Ч����д�� */
                }

                pstr++;

                x += size / 2;  /* Ӣ���ַ����, Ϊ���ĺ��ֿ�ȵ�һ�� */
            }
        }
        else     /* ���� */
        {
            bHz = 0; /* �к��ֿ� */

            if (x > (x0 + width - size))   /* ���� */
            {
                y += size;
                x = x0;
            }

            if (y > (y0 + height - size))break; /* Խ�緵�� */

            text_show_font(x, y, pstr, size, mode, color); /* ��ʾ�������,������ʾ */
            pstr += 2;
            x += size; /* ��һ������ƫ�� */
        }
    }
}

/**
 * @brief       ��ָ����ȵ��м���ʾ�ַ���
 *   @note      ����ַ����ȳ�����len,����text_show_string_middle��ʾ
 * @param       x,y   : ��ʼ����
 * @param       str   : �ַ���
 * @param       size  : �����С
 * @param       width : ��ʾ������
 * @param       color : ������ɫ
 * @retval      ��
 */
void text_show_string_middle(uint16_t x, uint16_t y, char *str, uint8_t size, uint16_t width, uint16_t color)
{
    uint16_t strlenth = 0;
    strlenth = strlen((const char *)str);
    strlenth *= size / 2;

    if (strlenth > width) /* ������, ���ܾ�����ʾ */
    {
        text_show_string(x, y, lcddev.width, lcddev.height, str, size, 1, color);
    }
    else
    {
        strlenth = (width - strlenth) / 2;
        text_show_string(strlenth + x, y, lcddev.width, lcddev.height, str, size, 1, color);
    }
}













