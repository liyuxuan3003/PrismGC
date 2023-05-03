/**
 ****************************************************************************************************
 * @file        fattester.h
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.1
 * @date        2020-04-03
 * @brief       FATFS ���Դ���
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
 * V1.0 20200403
 * ��һ�η���
 *
 * V1.1 20221028
 * ����FATFS R0.14b
 *
 ****************************************************************************************************
 */


#ifndef __FATTESTER_H
#define __FATTESTER_H

#include "./SYSTEM/sys/sys.h"
#include "./FATFS/source/ff.h"


/* �����Ƿ�֧���ļ�ϵͳ���Թ���
 * 1, ֧��(����);
 * 0, ��֧��(�ر�);
 */
#define USE_FATTESTER         1




/* ���֧���ļ�ϵͳ���� ,��ʹ�����´��� */
#if USE_FATTESTER == 1
 
/* FATFS �����ýṹ�� */
typedef struct
{
    FIL *file;          /* �ļ��ṹ��ָ��1 */
    FILINFO fileinfo;   /* �ļ���Ϣ */
    DIR dir;            /* Ŀ¼ */
    uint8_t *fatbuf;    /* ��д���� */
    uint8_t initflag;   /* ��ʼ����־ */
} _m_fattester;

extern _m_fattester fattester;      /* FATFS���Խṹ�� */


uint8_t mf_init(void);              /* ��ʼ���ļ�ϵͳ���� */
void mf_free(void);                 /* �ͷ��ļ�ϵͳ����ʱ������ڴ� */


uint8_t mf_mount(uint8_t* path,uint8_t mt);
uint8_t mf_open(uint8_t*path,uint8_t mode);
uint8_t mf_close(void);
uint8_t mf_read(uint16_t len);
uint8_t mf_write(uint8_t*dat,uint16_t len);
uint8_t mf_opendir(uint8_t* path);
uint8_t mf_closedir(void);
uint8_t mf_readdir(void);
uint8_t mf_scan_files(uint8_t * path);
uint32_t mf_showfree(uint8_t *drv);
uint8_t mf_lseek(uint32_t offset);
uint32_t mf_tell(void);
uint32_t mf_size(void);
uint8_t mf_mkdir(uint8_t*pname);
uint8_t mf_fmkfs(uint8_t* path,uint8_t opt,uint16_t au);
uint8_t mf_unlink(uint8_t *pname);
uint8_t mf_rename(uint8_t *oldname,uint8_t* newname);
void mf_getlabel(uint8_t *path);
void mf_setlabel(uint8_t *path); 
void mf_gets(uint16_t size);
uint8_t mf_putc(uint8_t c);
uint8_t mf_puts(uint8_t*c);

#endif

 
#endif





























