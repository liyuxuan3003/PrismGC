/**
 ****************************************************************************************************
 * @file        fonts.h
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-28
 * @brief       �ֿ� ����
 *              �ṩfonts_update_font��fonts_init�����ֿ���ºͳ�ʼ��
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

#ifndef __FONTS_H
#define __FONTS_H

#include "./SYSTEM/sys/sys.h"



/* ������Ϣ�����׵�ַ
 * ռ41���ֽ�,��1���ֽ����ڱ���ֿ��Ƿ����.����ÿ8���ֽ�һ��,�ֱ𱣴���ʼ��ַ���ļ���С
 */
extern uint32_t FONTINFOADDR;

/* �ֿ���Ϣ�ṹ�嶨��
 * ���������ֿ������Ϣ����ַ����С��
 */
typedef __PACKED_STRUCT
{
    uint8_t fontok;             /* �ֿ���ڱ�־��0XAA���ֿ��������������ֿⲻ���� */
    uint32_t ugbkaddr;          /* unigbk�ĵ�ַ */
    uint32_t ugbksize;          /* unigbk�Ĵ�С */
    uint32_t f12addr;           /* gbk12��ַ */
    uint32_t gbk12size;         /* gbk12�Ĵ�С */
    uint32_t f16addr;           /* gbk16��ַ */
    uint32_t gbk16size;         /* gbk16�Ĵ�С */
    uint32_t f24addr;           /* gbk24��ַ */
    uint32_t gbk24size;         /* gbk24�Ĵ�С */
} _font_info;

/* �ֿ���Ϣ�ṹ�� */
extern _font_info ftinfo;


uint8_t fonts_update_font(uint16_t x, uint16_t y, uint8_t size, uint8_t *src, uint16_t color);  /* ����ȫ���ֿ� */
uint8_t fonts_init(void);       /* ��ʼ���ֿ� */

#endif





















