/**
 ****************************************************************************************************
 * @file        bmp.h
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-04
 * @brief       ͼƬ����-bmp���� ����
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

#ifndef __BMP_H
#define __BMP_H

#include "./SYSTEM/sys/sys.h"


/******************************************************************************************/
/* �û������� */
#define BMP_USE_MALLOC      1           /* �����Ƿ�ʹ��malloc,��������ѡ��ʹ��malloc */
#define BMP_DBUF_SIZE       2048        /* ����bmp��������Ĵ�С(����ӦΪLCD���*3) */

/******************************************************************************************/


/* BMP��Ϣͷ */
typedef __PACKED_STRUCT
{
    uint32_t biSize ;           /* ˵��BITMAPINFOHEADER�ṹ����Ҫ�������� */
    long  biWidth ;             /* ˵��ͼ��Ŀ�ȣ�������Ϊ��λ */
    long  biHeight ;            /* ˵��ͼ��ĸ߶ȣ�������Ϊ��λ */
    uint16_t  biPlanes ;        /* ΪĿ���豸˵��λ��������ֵ�����Ǳ���Ϊ1 */
    uint16_t  biBitCount ;      /* ˵��������/���أ���ֵΪ1��4��8��16��24����32 */
    uint32_t biCompression ;    /* ˵��ͼ������ѹ�������͡���ֵ����������ֵ֮һ
                                 * BI_RGB      ��û��ѹ��
                                 * BI_RLE8     ��ÿ������8���ص�RLEѹ�����룬ѹ����ʽ��2�ֽ����(�ظ����ؼ�������ɫ����) 
                                 * BI_RLE4     ��ÿ������4���ص�RLEѹ�����룬ѹ����ʽ��2�ֽ���� 
                                 * BI_BITFIELDS��ÿ�����صı�����ָ����������� 
                                 */
    uint32_t biSizeImage ;      /* ˵��ͼ��Ĵ�С�����ֽ�Ϊ��λ������BI_RGB��ʽʱ��������Ϊ0 */
    long  biXPelsPerMeter ;     /* ˵��ˮƽ�ֱ��ʣ�������/�ױ�ʾ */
    long  biYPelsPerMeter ;     /* ˵����ֱ�ֱ��ʣ�������/�ױ�ʾ */
    uint32_t biClrUsed ;        /* ˵��λͼʵ��ʹ�õĲ�ɫ���е���ɫ������ */
    uint32_t biClrImportant ;   /* ˵����ͼ����ʾ����ҪӰ�����ɫ��������Ŀ�������0����ʾ����Ҫ */
}BITMAPINFOHEADER ;

/* BMPͷ�ļ� */
typedef __PACKED_STRUCT
{
    uint16_t  bfType ;          /* �ļ���־.ֻ��'BM',����ʶ��BMPλͼ���� */
    uint32_t  bfSize ;          /* �ļ���С,ռ�ĸ��ֽ� */
    uint16_t  bfReserved1 ;     /* ���� */
    uint16_t  bfReserved2 ;     /* ���� */
    uint32_t  bfOffBits ;       /* ���ļ���ʼ��λͼ����(bitmap data)��ʼ֮��ĵ�ƫ���� */
}BITMAPFILEHEADER ;

/* ��ɫ��  */
typedef __PACKED_STRUCT
{
    uint8_t rgbBlue ;           /* ָ����ɫǿ�� */
    uint8_t rgbGreen ;          /* ָ����ɫǿ�� */
    uint8_t rgbRed ;            /* ָ����ɫǿ�� */
    uint8_t rgbReserved ;       /* ����������Ϊ0 */
}RGBQUAD ;

/* λͼ��Ϣͷ */
typedef __PACKED_STRUCT
{ 
    BITMAPFILEHEADER bmfHeader;
    BITMAPINFOHEADER bmiHeader;  
    uint32_t RGB_MASK[3];       /* ��ɫ�����ڴ��RGB���� */
    //RGBQUAD bmiColors[256];
}BITMAPINFO; 

typedef RGBQUAD * LPRGBQUAD;    /* ��ɫ�� */


/* ͼ������ѹ�������� */
#define BI_RGB          0       /* û��ѹ��.RGB 5,5,5 */
#define BI_RLE8         1       /* ÿ������8���ص�RLEѹ�����룬ѹ����ʽ��2�ֽ����(�ظ����ؼ�������ɫ����) */
#define BI_RLE4         2       /* ÿ������4���ص�RLEѹ�����룬ѹ����ʽ��2�ֽ���� */
#define BI_BITFIELDS    3       /* ÿ�����صı�����ָ����������� */



/* BMP�����ӿں��� */
uint8_t stdbmp_decode(const char *filename);
uint8_t minibmp_decode(uint8_t *filename,uint16_t x,uint16_t y,uint16_t width,uint16_t height,uint16_t acolor,uint8_t mode);/* �ߴ�С��240*320��bmpͼƬ���� */
uint8_t bmp_encode(uint8_t *filename,uint16_t x,uint16_t y,uint16_t width,uint16_t height,uint8_t mode);

#endif








