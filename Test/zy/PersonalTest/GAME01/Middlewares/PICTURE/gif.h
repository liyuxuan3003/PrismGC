/**
 ****************************************************************************************************
 * @file        gif.h
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-04
 * @brief       ͼƬ����-gif���� ����
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
 * V1.0 20200404
 * ��һ�η���
 *
 ****************************************************************************************************
 */

#ifndef __GIF_H
#define __GIF_H

#include "./SYSTEM/sys/sys.h"
#include "./FATFS/source/ff.h"

/******************************************************************************************/
/* �û������� */

#define GIF_USE_MALLOC          1       /* �����Ƿ�ʹ��malloc,��������ѡ��ʹ��malloc */

/******************************************************************************************/


#define LCD_MAX_LOG_COLORS      256
#define MAX_NUM_LWZ_BITS        12


#define GIF_INTRO_TERMINATOR    ';'    /* 0X3B   GIF�ļ������� */
#define GIF_INTRO_EXTENSION     '!'     /* 0X21 */
#define GIF_INTRO_IMAGE         ','     /* 0X2C */

#define GIF_COMMENT             0xFE
#define GIF_APPLICATION         0xFF
#define GIF_PLAINTEXT           0x01
#define GIF_GRAPHICCTL          0xF9

typedef struct
{
    uint8_t    aBuffer[258];                    /*  Input buffer for data block */
    short aCode  [(1 << MAX_NUM_LWZ_BITS)];     /*  This array stores the LZW codes for the compressed strings */
    uint8_t    aPrefix[(1 << MAX_NUM_LWZ_BITS)];/*  Prefix character of the LZW code */
    uint8_t    aDecompBuffer[3000];             /*  Decompression buffer. The higher the compression, the more bytes are needed in the buffer */
    uint8_t   *sp;                              /*  Pointer into the decompression buffer */
    int   CurBit;
    int   LastBit;
    int   GetDone;
    int   LastByte;
    int   ReturnClear;
    int   CodeSize;
    int   SetCodeSize;
    int   MaxCode;
    int   MaxCodeSize;
    int   ClearCode;
    int   EndCode;
    int   FirstCode;
    int   OldCode;
} LZW_INFO;

/* �߼���Ļ������ */
typedef __PACKED_STRUCT
{
    uint16_t width;     /* GIF��� */
    uint16_t height;    /* GIF�߶� */
    uint8_t flag;       /* ��ʶ��  1:3:1:3=ȫ����ɫ���־(1):��ɫ���(3):�����־(1):ȫ����ɫ���С(3) */
    uint8_t bkcindex;   /* ����ɫ��ȫ����ɫ���е�����(��������ȫ����ɫ��ʱ��Ч) */
    uint8_t pixratio;   /* ���ؿ�߱� */
} LogicalScreenDescriptor;


/* ͼ�������� */
typedef __PACKED_STRUCT
{
    uint16_t xoff;      /* x����ƫ�� */
    uint16_t yoff;      /* y����ƫ�� */
    uint16_t width;     /* ��� */
    uint16_t height;    /* �߶� */
    uint8_t flag;       /* ��ʶ��  1:1:1:2:3=�ֲ���ɫ���־(1):��֯��־(1):����(2):�ֲ���ɫ���С(3) */
} ImageScreenDescriptor;

/* ͼ������ */
typedef __PACKED_STRUCT
{
    LogicalScreenDescriptor gifLSD; /* �߼���Ļ������ */
    ImageScreenDescriptor gifISD;   /* ͼ�������� */
    uint16_t colortbl[256];         /* ��ǰʹ����ɫ�� */
    uint16_t bkpcolortbl[256];      /* ������ɫ��.�����ھֲ���ɫ��ʱʹ�� */
    uint16_t numcolors;             /* ��ɫ���С */
    uint16_t delay;                 /* �ӳ�ʱ�� */
    LZW_INFO *lzw;                  /* LZW��Ϣ */
} gif89a;

extern uint8_t g_gif_decoding;      /* GIF���ڽ����� */





/* GIF�����ӿں��� */
void gif_quit(void);    /* �˳���ǰ���� */
uint8_t gif_getinfo(FIL *file, gif89a *gif);    /* ��ȡGIF��Ϣ */
uint8_t gif_decode(const char *filename, uint16_t x, uint16_t y, uint16_t width, uint16_t height);/* ��ָ���������һ��GIF�ļ� */


#endif




















