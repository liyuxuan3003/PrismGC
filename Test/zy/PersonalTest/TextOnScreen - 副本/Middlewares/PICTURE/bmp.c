/**
 ****************************************************************************************************
 * @file        bmp.c
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

#include "string.h"
#include "./PICTURE/bmp.h"
#include "./PICTURE/piclib.h"



/* ��ʹ���ڴ���� */
#if BMP_USE_MALLOC == 0
FIL f_bfile;
uint8_t bmpreadbuf[BMP_DBUF_SIZE];
#endif


/**
 * @brief       ��׼��bmp����,����filename���BMP�ļ�
 *   @note      ���Խ����ߴ�BMP(�Զ�����), �����ٶȱȽ���
 * @param       filename : ����·�����ļ���(.bmp)
 * @retval      �������
 *   @arg       0   , �ɹ�
 *   @arg       ����, ������
 */
uint8_t stdbmp_decode(const char *filename)
{
    FIL *f_bmp;
    uint16_t br;

    uint16_t count;
    uint8_t  rgb, color_byte;
    uint16_t x, y, color;
    uint16_t countpix = 0;      /* ��¼���� */

    /* x,y��ʵ������ */
    uint16_t  realx = 0;
    uint16_t realy = 0;
    uint8_t  yok = 1;
    uint8_t res;


    uint8_t *databuf;           /* ���ݶ�ȡ��ŵ�ַ */
    uint16_t readlen = BMP_DBUF_SIZE;   /* һ�δ�SD����ȡ���ֽ������� */

    uint8_t *bmpbuf;            /* ���ݽ����ַ */
    uint8_t biCompression = 0;  /* ��¼ѹ����ʽ */

    uint16_t rowlen;            /* ˮƽ�����ֽ��� */
    BITMAPINFO *pbmp;           /* ��ʱָ�� */

#if BMP_USE_MALLOC == 1         /* ʹ��malloc */
    databuf = (uint8_t *)piclib_mem_malloc(readlen); /* ����readlen�ֽڵ��ڴ����� */

    if (databuf == NULL)return PIC_MEM_ERR;     /* �ڴ�����ʧ�� */

    f_bmp = (FIL *)piclib_mem_malloc(sizeof(FIL));   /* ����FIL�ֽڵ��ڴ����� */

    if (f_bmp == NULL)          /* �ڴ�����ʧ�� */
    {
        piclib_mem_free(databuf);
        return PIC_MEM_ERR;
    }

#else   /* ��ʹ��malloc */
    databuf = bmpreadbuf;
    f_bmp = &f_bfile;
#endif
    res = f_open(f_bmp, (const TCHAR *)filename, FA_READ);  /* ���ļ� */

    if (res == 0)   /* �򿪳ɹ� */
    {
        f_read(f_bmp, databuf, readlen, (UINT *)&br);   /* ����readlen���ֽ� */
        pbmp = (BITMAPINFO *)databuf;                   /* �õ�BMP��ͷ����Ϣ */
        count = pbmp->bmfHeader.bfOffBits;              /* ����ƫ��,�õ����ݶεĿ�ʼ��ַ */
        color_byte = pbmp->bmiHeader.biBitCount / 8;    /* ��ɫλ 16/24/32 */
        biCompression = pbmp->bmiHeader.biCompression;  /* ѹ����ʽ */
        picinfo.ImgHeight = pbmp->bmiHeader.biHeight;   /* �õ�ͼƬ�߶� */
        picinfo.ImgWidth = pbmp->bmiHeader.biWidth;     /* �õ�ͼƬ��� */
        piclib_ai_draw_init();                          /* ��ʼ�����ܻ�ͼ */

        /* ˮƽ���ر�����4�ı���!! */
        if ((picinfo.ImgWidth * color_byte) % 4)
        {
            rowlen = ((picinfo.ImgWidth * color_byte) / 4 + 1) * 4;
        }
        else
        {
            rowlen = picinfo.ImgWidth * color_byte;
        }
        
        /* ��ʼ����BMP */
        color = 0;  /* ��ɫ��� */
        x = 0 ;
        y = picinfo.ImgHeight;
        rgb = 0;
        
        /* ���ڳߴ�С�ڵ����趨�ߴ��ͼƬ,���п��ٽ��� */
        realy = (y * picinfo.Div_Fac) >> 13;
        bmpbuf = databuf;

        while (1)
        {
            while (count < readlen)     /* ��ȡһ��1024���� (SectorsPerClust ÿ��������) */
            {
                if (color_byte == 3)    /* 24λ��ɫͼ */
                {
                    switch (rgb)
                    {
                        case 0:
                            color = bmpbuf[count] >> 3; /* B */
                            break ;

                        case 1:
                            color += ((uint16_t)bmpbuf[count] << 3) & 0X07E0;   /* G */
                            break;

                        case 2 :
                            color += ((uint16_t)bmpbuf[count] << 8) & 0XF800;   /* R */
                            break ;
                    }
                }
                else if (color_byte == 2)   /* 16λ��ɫͼ */
                {
                    switch (rgb)
                    {
                        case 0 :
                            if (biCompression == BI_RGB)    /* RGB:5,5,5 */
                            {
                                color = ((uint16_t)bmpbuf[count] & 0X1F);           /* R */
                                color += (((uint16_t)bmpbuf[count]) & 0XE0) << 1;   /* G */
                            }
                            else    /* RGB:5,6,5 */
                            {
                                color = bmpbuf[count];  /* G,B */
                            }

                            break ;

                        case 1 :
                            if (biCompression == BI_RGB)/* RGB:5,5,5 */
                            {
                                color += (uint16_t)bmpbuf[count] << 9;  /* R,G */
                            }
                            else    /* RGB:5,6,5 */
                            {
                                color += (uint16_t)bmpbuf[count] << 8;  /* R,G */
                            }

                            break ;
                    }
                }
                else if (color_byte == 4)   /* 32λ��ɫͼ */
                {
                    switch (rgb)
                    {
                        case 0:
                            color = bmpbuf[count] >> 3; /* B */
                            break ;

                        case 1:
                            color += ((uint16_t)bmpbuf[count] << 3) & 0X07E0;   /* G */
                            break;

                        case 2 :
                            color += ((uint16_t)bmpbuf[count] << 8) & 0XF800;   /* R */
                            break ;

                        case 3 :
                            //alphabend=bmpbuf[count]; /* ����ȡ  ALPHAͨ�� */
                            break ;
                    }
                }
                else if (color_byte == 1)   /* 8λɫ,��ʱ��֧��,��Ҫ�õ���ɫ�� */
                {
                }

                rgb++;
                count++ ;

                if (rgb == color_byte)  /* ˮƽ�����ȡ��1���������ݺ���ʾ */
                {
                    if (x < picinfo.ImgWidth)
                    {
                        realx = (x * picinfo.Div_Fac) >> 13; /* x��ʵ��ֵ */

                        if (piclib_is_element_ok(realx, realy, 1) && yok)   /* �������� */
                        {
                            pic_phy.draw_point(realx + picinfo.S_XOFF, realy + picinfo.S_YOFF - 1, color);  /* ��ʾͼƬ */
                        }
                    }

                    x++;    /* x������һ������ */
                    color = 0x00;
                    rgb = 0;
                }

                countpix++; /* �����ۼ� */

                if (countpix >= rowlen) /* ˮƽ��������ֵ����.���� */
                {
                    y--;

                    if (y == 0)break;

                    realy = (y * picinfo.Div_Fac) >> 13;        /* ʵ��yֵ�ı� */

                    if (piclib_is_element_ok(realx, realy, 0))yok = 1; /* �˴����ı�picinfo.staticx,y��ֵ */
                    else yok = 0;

                    if ((realy + picinfo.S_YOFF) == 0)break;    /* y����������0 */

                    x = 0;
                    countpix = 0;
                    color = 0x00;
                    rgb = 0;
                }
            }

            res = f_read(f_bmp, databuf, readlen, (UINT *)&br); /* ����readlen���ֽ� */

            if (br != readlen)readlen = br; /* ���һ������ */

            if (res || br == 0)break;       /* ��ȡ���� */

            bmpbuf = databuf;
            count = 0;
        }

        f_close(f_bmp); /* �ر��ļ� */
    }

#if BMP_USE_MALLOC == 1 /* ʹ��malloc */
    piclib_mem_free(databuf);
    piclib_mem_free(f_bmp);
#endif
    return res;         /* BMP��ʾ���� */
}

/**
 * @brief       С�ߴ��bmp����,����filename���BMP�ļ�
 *   @note      ��������֧��С��LCD��Ļ�ֱ��ʵ�bmp�ļ�����.
 * @param       filename    : ����·�����ļ���(.bmp)
 * @param       x, y        : ��ʾ��ʼ����
 * @param       width,height: ��ʾ�����С
 * @param       acolor      : ���ӵ�alphablend����ɫ(�������32λɫbmp��Ч!!!)
 * @param       mode        : ģʽ(����bit5,�����ľ�ֻ��32λɫbmp��Ч!!!)
 *                              bit[7:6]: 00, ��ʹ��ͼƬ����͵�ɫalphablend;
 *                                        01, ��ͼƬ��acolor����alphablend,���Ҳ����ø��ӵ�͸����; 
 *                                        10, ��ɫ,acolor,ͼƬ,һ�����alphablend;
 *                              bit5    : ����
 *                              bit4~0  : 0~31, ʹ�ø���alphablend��͸���̶�
 *
 * @retval      �������
 *   @arg       0   , �ɹ�
 *   @arg       ����, ������
 */
uint8_t minibmp_decode(uint8_t *filename, uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint16_t acolor, uint8_t mode) 
{
    FIL *f_bmp;
    uint16_t br;
    uint8_t  color_byte;
    uint16_t tx, ty, color;
    
    /* tx,ty��ʵ������ */
    uint8_t res;
    uint16_t i, j;
    uint8_t *databuf;                   /* ���ݶ�ȡ�� �ŵ�ַ */
    uint16_t readlen = BMP_DBUF_SIZE;   /* һ�δ�SD����ȡ���ֽ�������,����С��LCD���*3!!! */

    uint8_t *bmpbuf;                    /* ���ݽ����ַ */
    uint8_t biCompression = 0;          /* ��¼ѹ����ʽ */

    uint16_t rowcnt;                    /* һ�ζ�ȡ������ */
    uint16_t rowlen;                    /* ˮƽ�����ֽ��� */
    uint16_t rowpix = 0;                /* ˮƽ���������� */
    uint8_t rowadd;                     /* ÿ������ֽ��� */

    uint16_t tmp_color;

    uint8_t alphabend = 0xff;           /* ����͸��ɫΪ0����ȫ��͸�� */
    uint8_t alphamode = mode >> 6;      /* �õ�ģʽֵ,0/1/2 */
    BITMAPINFO *pbmp;                   /* ��ʱָ�� */
    
    /* �õ�����ߴ� */
    picinfo.S_Height = height;
    picinfo.S_Width = width;

#if BMP_USE_MALLOC == 1                 /* ʹ��malloc */
    databuf = (uint8_t *)piclib_mem_malloc(readlen); /* ����readlen�ֽڵ��ڴ����� */

    if (databuf == NULL)return PIC_MEM_ERR;     /* �ڴ�����ʧ�� */

    f_bmp = (FIL *)piclib_mem_malloc(sizeof(FIL));   /* ����FIL�ֽڵ��ڴ����� */

    if (f_bmp == NULL)                          /* �ڴ�����ʧ�� */
    {
        piclib_mem_free(databuf);
        return PIC_MEM_ERR;
    }

#else
    databuf = bmpreadbuf;
    f_bmp = &f_bfile;
#endif
    res = f_open(f_bmp, (const TCHAR *)filename, FA_READ);  /* ���ļ� */

    if (res == 0)   /* �򿪳ɹ� */
    {
        f_read(f_bmp, databuf, sizeof(BITMAPINFO), (UINT *)&br);/* ����BITMAPINFO��Ϣ */
        pbmp = (BITMAPINFO *)databuf;                   /* �õ�BMP��ͷ����Ϣ */
        color_byte = pbmp->bmiHeader.biBitCount / 8;    /* ��ɫλ 16/24/32 */
        biCompression = pbmp->bmiHeader.biCompression;  /* ѹ����ʽ */
        picinfo.ImgHeight = pbmp->bmiHeader.biHeight;   /* �õ�ͼƬ�߶� */
        picinfo.ImgWidth = pbmp->bmiHeader.biWidth;     /* �õ�ͼƬ��� */

        /* ˮƽ���ر�����4�ı���!! */
        if ((picinfo.ImgWidth * color_byte) % 4)
        {
            rowlen = ((picinfo.ImgWidth * color_byte) / 4 + 1) * 4;
        }
        else
        {
            rowlen = picinfo.ImgWidth * color_byte;
        }
        
        rowadd = rowlen - picinfo.ImgWidth * color_byte;/* ÿ������ֽ��� */
        /* ��ʼ����BMP */
        color = 0; /* ��ɫ��� */
        tx = 0 ;
        ty = picinfo.ImgHeight - 1;

        if (picinfo.ImgWidth <= picinfo.S_Width && picinfo.ImgHeight <= picinfo.S_Height)
        {
            x += (picinfo.S_Width - picinfo.ImgWidth) / 2;      /* ƫ�Ƶ������� */
            y += (picinfo.S_Height - picinfo.ImgHeight) / 2;    /* ƫ�Ƶ������� */
            rowcnt = readlen / rowlen;  /* һ�ζ�ȡ������ */
            readlen = rowcnt * rowlen;  /* һ�ζ�ȡ���ֽ��� */
            rowpix = picinfo.ImgWidth;  /* ˮƽ���������ǿ�� */
            f_lseek(f_bmp, pbmp->bmfHeader.bfOffBits);          /* ƫ�Ƶ�������ʼλ�� */

            while (1)
            {
                res = f_read(f_bmp, databuf, readlen, (UINT *)&br); /* ����readlen���ֽ� */
                bmpbuf = databuf;       /* �����׵�ַ */

                if (br != readlen)rowcnt = br / rowlen; /* ���ʣ�µ����� */

                if (color_byte == 3)    /* 24λBMPͼƬ */
                {
                    for (j = 0; j < rowcnt; j++)        /* ÿ�ζ��������� */
                    {
                        for (i = 0; i < rowpix; i++)    /* дһ������ */
                        {
                            color = (*bmpbuf++) >> 3;		   		 	/* B */
                            color += ((uint16_t)(*bmpbuf++) << 3) & 0X07E0;	/* G */
                            color += (((uint16_t) * bmpbuf++) << 8) & 0XF800;	/* R */
                            pic_phy.draw_point(x + tx, y + ty, color); /* ��ʾͼƬ */
                            tx++;
                        }

                        bmpbuf += rowadd;   /* ��������� */
                        tx = 0;
                        ty--;
                    }
                }
                else if (color_byte == 2)   /* 16λBMPͼƬ */
                {
                    for (j = 0; j < rowcnt; j++)        /* ÿ�ζ��������� */
                    {
                        if (biCompression == BI_RGB)    /* RGB:5,5,5 */
                        {
                            for (i = 0; i < rowpix; i++)
                            {
                                color = ((uint16_t) * bmpbuf & 0X1F);           /* R */
                                color += (((uint16_t) * bmpbuf++) & 0XE0) << 1; /* G */
                                color += ((uint16_t) * bmpbuf++) << 9;          /* R,G */
                                pic_phy.draw_point(x + tx, y + ty, color);      /* ��ʾͼƬ */
                                tx++;
                            }
                        }
                        else     /* RGB 565 */
                        {
                            for (i = 0; i < rowpix; i++)
                            {
                                color = *bmpbuf++;  /* G,B */
                                color += ((uint16_t) * bmpbuf++) << 8;      /* R,G */
                                pic_phy.draw_point(x + tx, y + ty, color);  /* ��ʾͼƬ */
                                tx++;
                            }
                        }

                        bmpbuf += rowadd;   /* ��������� */
                        tx = 0;
                        ty--;
                    }
                }
                else if (color_byte == 4)   /* 32λBMPͼƬ */
                {
                    for (j = 0; j < rowcnt; j++)    /* ÿ�ζ��������� */
                    {
                        for (i = 0; i < rowpix; i++)
                        {
                            color = (*bmpbuf++) >> 3;   /* B */
                            color += ((uint16_t)(*bmpbuf++) << 3) & 0X07E0;     /* G */
                            color += (((uint16_t) * bmpbuf++) << 8) & 0XF800;   /* R */
                            alphabend = *bmpbuf++;  /* ALPHAͨ�� */

                            if (alphamode != 1)     /* ��Ҫ��ȡ��ɫ */
                            {
                                tmp_color = pic_phy.read_point(x + tx, y + ty); /* ��ȡ��ɫ */

                                if (alphamode == 2) /* ��Ҫ���ӵ�alphablend */
                                {
                                    tmp_color = piclib_alpha_blend(tmp_color, acolor, mode & 0X1F); /* ��ָ����ɫ����blend */
                                }

                                color = piclib_alpha_blend(tmp_color, color, alphabend / 8);    /* �͵�ɫ����alphablend */
                            }
                            else
                            {
                                tmp_color = piclib_alpha_blend(acolor, color, alphabend / 8);   /* ��ָ����ɫ����blend */
                            }
                            
                            pic_phy.draw_point(x + tx, y + ty, color);  /* ��ʾͼƬ */
                            tx++;           /* x������һ������ */
                        }

                        bmpbuf += rowadd;   /* ��������� */
                        tx = 0;
                        ty--;
                    }

                }

                if (br != readlen || res)break;
            }
        }

        f_close(f_bmp);     /* �ر��ļ� */
    }
    else
    {
        res = PIC_SIZE_ERR; /* ͼƬ�ߴ���� */
    }
    
#if BMP_USE_MALLOC == 1     /* ʹ��malloc */
    piclib_mem_free(databuf);
    piclib_mem_free(f_bmp);
#endif
    return res;
}

/**
 * @brief       BMP���뺯��
 *   @note      ����ǰLCD��Ļ��ָ�������ͼ,��Ϊ16λ��ʽ��BMP�ļ� RGB565��ʽ.
 *              ����Ϊrgb565����Ҫ����,��Ҫ����ԭ���ĵ�ɫ��λ����������.���������Ѿ�����������.
 *              ����Ϊrgb555��ʽ����Ҫ��ɫת��,��ʱ��ȽϾ�,���Ա���Ϊ565������ٵİ취.
 *
 * @param       filename    : �����洢·�����ļ���(.bmp)
 * @param       x, y        : ��ʼ����
 * @param       width,height: �����С
 * @param       acolor      : ���ӵ�alphablend����ɫ(�������32λɫbmp��Ч!!!)
 * @param       mode        : ����ģʽ
 *   @arg                     0, �����������ļ��ķ�ʽ����;
 *   @arg                     1, ���֮ǰ�����ļ�,�򸲸�֮ǰ���ļ�.���û��,�򴴽��µ��ļ�; 
 * @retval      �������
 *   @arg       0   , �ɹ�
 *   @arg       ����, ������
 */
uint8_t bmp_encode(uint8_t *filename, uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint8_t mode)
{
    FIL *f_bmp;
    uint32_t bw = 0;
    uint16_t bmpheadsize;   /* bmpͷ��С */
    BITMAPINFO hbmp;        /* bmpͷ */
    uint8_t res = 0;
    uint16_t tx, ty;        /* ͼ��ߴ� */
    uint16_t *databuf;      /* ���ݻ�������ַ */
    uint16_t pixcnt;        /* ���ؼ����� */
    uint16_t bi4width;      /* ˮƽ�����ֽ��� */

    if (width == 0 || height == 0)return PIC_WINDOW_ERR;        /* ������� */

    if ((x + width - 1) > lcddev.width)return PIC_WINDOW_ERR;   /* ������� */

    if ((y + height - 1) > lcddev.height)return PIC_WINDOW_ERR; /* ������� */

#if BMP_USE_MALLOC == 1     /* ʹ��malloc */
    
    /* ��������bi4width��С���ֽڵ��ڴ����� ,��240�����,480���ֽھ͹���.���֧��1024��ȵ�bmp���� */
    databuf = (uint16_t *)piclib_mem_malloc(2048);

    if (databuf == NULL)return PIC_MEM_ERR;     /* �ڴ�����ʧ��. */

    f_bmp = (FIL *)piclib_mem_malloc(sizeof(FIL));   /* ����FIL�ֽڵ��ڴ����� */

    if (f_bmp == NULL)      /* �ڴ�����ʧ�� */
    {
        piclib_mem_free(databuf);
        return PIC_MEM_ERR;
    }

#else
    databuf = (uint16_t *)bmpreadbuf;
    f_bmp = &f_bfile;
#endif
    bmpheadsize = sizeof(hbmp);         /* �õ�bmp�ļ�ͷ�Ĵ�С */
    my_mem_set((uint8_t *)&hbmp, 0, sizeof(hbmp));        /* ��������뵽���ڴ� */
    hbmp.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);   /* ��Ϣͷ��С */
    hbmp.bmiHeader.biWidth = width;     /* bmp�Ŀ�� */
    hbmp.bmiHeader.biHeight = height;   /* bmp�ĸ߶� */
    hbmp.bmiHeader.biPlanes = 1;        /* ��Ϊ1 */
    hbmp.bmiHeader.biBitCount = 16;     /* bmpΪ16λɫbmp */
    hbmp.bmiHeader.biCompression = BI_BITFIELDS;        /* ÿ�����صı�����ָ����������� */
    hbmp.bmiHeader.biSizeImage = hbmp.bmiHeader.biHeight * hbmp.bmiHeader.biWidth * hbmp.bmiHeader.biBitCount / 8;  /* bmp��������С */

    hbmp.bmfHeader.bfType = ((uint16_t)'M' << 8) + 'B'; /* BM��ʽ��־ */
    hbmp.bmfHeader.bfSize = bmpheadsize + hbmp.bmiHeader.biSizeImage; /* ����bmp�Ĵ�С */
    hbmp.bmfHeader.bfOffBits = bmpheadsize; /* ����������ƫ�� */

    hbmp.RGB_MASK[0] = 0X00F800;        /* ��ɫ���� */
    hbmp.RGB_MASK[1] = 0X0007E0;        /* ��ɫ���� */
    hbmp.RGB_MASK[2] = 0X00001F;        /* ��ɫ���� */

    if (mode == 1)
    {
        res = f_open(f_bmp, (const TCHAR *)filename, FA_READ | FA_WRITE);       /* ���Դ�֮ǰ���ļ� */
    }
    
    if (mode == 0 || res == 0x04)
    {
        res = f_open(f_bmp, (const TCHAR *)filename, FA_WRITE | FA_CREATE_NEW); /* ģʽ0,���߳��Դ�ʧ��,�򴴽����ļ� */
    }
    
    if ((hbmp.bmiHeader.biWidth * 2) % 4)   /* ˮƽ����(�ֽ�)��Ϊ4�ı��� */
    {
        bi4width = ((hbmp.bmiHeader.biWidth * 2) / 4 + 1) * 4;  /* ʵ��Ҫд��Ŀ������,����Ϊ4�ı��� */
    }
    else
    {
        bi4width = hbmp.bmiHeader.biWidth * 2;  /* �պ�Ϊ4�ı��� */
    }

    if (res == FR_OK)   /* �����ɹ� */
    {
        res = f_write(f_bmp, (uint8_t *)&hbmp, bmpheadsize, &bw);   /* д��BMP�ײ� */

        for (ty = y + height - 1; hbmp.bmiHeader.biHeight; ty--)
        {
            pixcnt = 0;

            for (tx = x; pixcnt != (bi4width / 2);)
            {
                if (pixcnt < hbmp.bmiHeader.biWidth)
                {
                    databuf[pixcnt] = pic_phy.read_point(tx, ty);   /* ��ȡ������ֵ */
                }
                else
                {
                    databuf[pixcnt] = 0Xffff;   /* �����ɫ������ */
                }
                
                pixcnt++;
                tx++;
            }

            hbmp.bmiHeader.biHeight--;
            res = f_write(f_bmp, (uint8_t *)databuf, bi4width, &bw);    /* д������ */
        }

        f_close(f_bmp);
    }

#if BMP_USE_MALLOC == 1     /* ʹ��malloc */
    piclib_mem_free(databuf);
    piclib_mem_free(f_bmp);
#endif
    return res;
}

















