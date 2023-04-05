/**
 ****************************************************************************************************
 * @file        exfuns.h
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-28
 * @brief       FATFS ��չ����
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

#ifndef __EXFUNS_H
#define __EXFUNS_H

#include "./SYSTEM/sys/sys.h"
#include "./FATFS/source/ff.h"


extern FATFS *fs[FF_VOLUMES];
extern FIL *file;
extern FIL *ftemp;
extern UINT br, bw;
extern FILINFO fileinfo;
extern DIR dir;
extern uint8_t *fatbuf;     /* SD�����ݻ����� */



/* exfuns_file_type���ص����Ͷ���
 * ���ݱ�FILE_TYPE_TBL���.��exfuns.c���涨��
 */
#define T_BIN       0X00    /* bin�ļ� */
#define T_LRC       0X10    /* lrc�ļ� */

#define T_NES       0X20    /* nes�ļ� */
#define T_SMS       0X21    /* sms�ļ� */

#define T_TEXT      0X30    /* .txt�ļ� */
#define T_C         0X31    /* .c�ļ� */
#define T_H         0X32    /* .h�ļ� */

#define T_WAV       0X40    /* WAV�ļ� */
#define T_MP3       0X41    /* MP3�ļ� */
#define T_OGG       0X42    /* OGG�ļ� */
#define T_FLAC      0X43    /* FLAC�ļ� */
#define T_AAC       0X44    /* AAC�ļ� */
#define T_WMA       0X45    /* WMA�ļ� */
#define T_MID       0X46    /* MID�ļ� */

#define T_BMP       0X50    /* bmp�ļ� */
#define T_JPG       0X51    /* jpg�ļ� */
#define T_JPEG      0X52    /* jpeg�ļ� */
#define T_GIF       0X53    /* gif�ļ� */

#define T_AVI       0X60    /* avi�ļ� */


uint8_t exfuns_init(void);                  /* �����ڴ� */
uint8_t exfuns_file_type(char *fname);   /* ʶ���ļ����� */

uint8_t exfuns_get_free(uint8_t *pdrv, uint32_t *total, uint32_t *free);    /* �õ�������������ʣ������ */
uint32_t exfuns_get_folder_size(uint8_t *fdname);   /* �õ��ļ��д�С */
uint8_t *exfuns_get_src_dname(uint8_t *dpfn);
uint8_t exfuns_file_copy(uint8_t(*fcpymsg)(uint8_t *pname, uint8_t pct, uint8_t mode), uint8_t *psrc, uint8_t *pdst, uint32_t totsize, uint32_t cpdsize, uint8_t fwmode);       /* �ļ����� */
uint8_t exfuns_folder_copy(uint8_t(*fcpymsg)(uint8_t *pname, uint8_t pct, uint8_t mode), uint8_t *psrc, uint8_t *pdst, uint32_t *totsize, uint32_t *cpdsize, uint8_t fwmode);   /* �ļ��и��� */
#endif
























