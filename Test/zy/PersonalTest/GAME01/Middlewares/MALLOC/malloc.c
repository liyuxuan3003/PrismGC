/**
 ****************************************************************************************************
 * @file        malloc.c
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-28
 * @brief       �ڴ���� ����
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

#include "./MALLOC/malloc.h"

#if !(__ARMCC_VERSION >= 6010050)   /* ����AC6����������ʹ��AC5������ʱ */

/* �ڴ��(64�ֽڶ���) */
static __align(64) uint8_t mem1base[MEM1_MAX_SIZE];                                     /* �ڲ�SRAM�ڴ�� */
static __align(64) uint8_t mem2base[MEM2_MAX_SIZE] __attribute__((at(0X68000000)));     /* ����SRAM�ڴ�� */

/* �ڴ����� */
static MT_TYPE mem1mapbase[MEM1_ALLOC_TABLE_SIZE];                                                      /* �ڲ�SRAM�ڴ��MAP */
static MT_TYPE mem2mapbase[MEM2_ALLOC_TABLE_SIZE] __attribute__((at(0X68000000 + MEM2_MAX_SIZE)));      /* ����SRAM�ڴ��MAP */

#else   /* ��AC6��������ʹ��AC6������ʱ */

/* mem2base�ĵ�ַ��0x68000000��AC6��֧��at�궨����ʽ���޸�Ϊ���µĺ궨����ʽ�� */


/* �ڴ��(64�ֽڶ���) */
static __ALIGNED(64) uint8_t mem1base[MEM1_MAX_SIZE];                                                       /* �ڲ�SRAM�ڴ�� */
static __ALIGNED(64) uint8_t mem2base[MEM2_MAX_SIZE] __attribute__((section(".bss.ARM.__at_0X68000000")));  /* ����SRAM�ڴ�� */

/* �ڴ����� */
static MT_TYPE mem1mapbase[MEM1_ALLOC_TABLE_SIZE];                                                          /* �ڲ�SRAM�ڴ��MAP */
static MT_TYPE mem2mapbase[MEM2_ALLOC_TABLE_SIZE] __attribute__((section(".bss.ARM.__at_0X680F0C00")));     /* ����SRAM�ڴ��MAP */

#endif

/* �ڴ������� */
const uint32_t memtblsize[SRAMBANK] = {MEM1_ALLOC_TABLE_SIZE, MEM2_ALLOC_TABLE_SIZE};   /* �ڴ���С */
const uint32_t memblksize[SRAMBANK] = {MEM1_BLOCK_SIZE, MEM2_BLOCK_SIZE};               /* �ڴ�ֿ��С */
const uint32_t memsize[SRAMBANK]    = {MEM1_MAX_SIZE, MEM2_MAX_SIZE};                   /* �ڴ��ܴ�С */

/* �ڴ��������� */
struct _m_mallco_dev mallco_dev =
{
    my_mem_init,                    /* �ڴ��ʼ�� */
    my_mem_perused,                 /* �ڴ�ʹ���� */
    mem1base, mem2base,             /* �ڴ�� */
    mem1mapbase, mem2mapbase,       /* �ڴ����״̬�� */
    0, 0,                           /* �ڴ����δ���� */
};

/**
 * @brief       �����ڴ�
 * @param       *des : Ŀ�ĵ�ַ
 * @param       *src : Դ��ַ
 * @param       n    : ��Ҫ���Ƶ��ڴ泤��(�ֽ�Ϊ��λ)
 * @retval      ��
 */
void my_mem_copy(void *des, void *src, uint32_t n)
{
    uint8_t *xdes = des;
    uint8_t *xsrc = src;

    while (n--)*xdes++ = *xsrc++;
}

/**
 * @brief       �����ڴ�ֵ
 * @param       *s    : �ڴ��׵�ַ
 * @param       c     : Ҫ���õ�ֵ
 * @param       count : ��Ҫ���õ��ڴ��С(�ֽ�Ϊ��λ)
 * @retval      ��
 */
void my_mem_set(void *s, uint8_t c, uint32_t count)
{
    uint8_t *xs = s;

    while (count--)*xs++ = c;
}

/**
 * @brief       �ڴ�����ʼ��
 * @param       memx : �����ڴ��
 * @retval      ��
 */
void my_mem_init(uint8_t memx)
{
    uint8_t mttsize = sizeof(MT_TYPE);  /* ��ȡmemmap��������ͳ���(uint16_t /uint32_t)*/
    my_mem_set(mallco_dev.memmap[memx], 0, memtblsize[memx]*mttsize); /* �ڴ�״̬���������� */
    mallco_dev.memrdy[memx] = 1;        /* �ڴ�����ʼ��OK */
}

/**
 * @brief       ��ȡ�ڴ�ʹ����
 * @param       memx : �����ڴ��
 * @retval      ʹ����(������10��,0~1000,����0.0%~100.0%)
 */
uint16_t my_mem_perused(uint8_t memx)
{
    uint32_t used = 0;
    uint32_t i;

    for (i = 0; i < memtblsize[memx]; i++)
    {
        if (mallco_dev.memmap[memx][i])used++;
    }

    return (used * 1000) / (memtblsize[memx]);
}

/**
 * @brief       �ڴ����(�ڲ�����)
 * @param       memx : �����ڴ��
 * @param       size : Ҫ������ڴ��С(�ֽ�)
 * @retval      �ڴ�ƫ�Ƶ�ַ
 *   @arg       0 ~ 0XFFFFFFFE : ��Ч���ڴ�ƫ�Ƶ�ַ
 *   @arg       0XFFFFFFFF     : ��Ч���ڴ�ƫ�Ƶ�ַ
 */
static uint32_t my_mem_malloc(uint8_t memx, uint32_t size)
{
    signed long offset = 0;
    uint32_t nmemb;     /* ��Ҫ���ڴ���� */
    uint32_t cmemb = 0; /* �������ڴ���� */
    uint32_t i;

    if (!mallco_dev.memrdy[memx])
    {
        mallco_dev.init(memx);          /* δ��ʼ��,��ִ�г�ʼ�� */
    }
    
    if (size == 0) return 0XFFFFFFFF;   /* ����Ҫ���� */

    nmemb = size / memblksize[memx];    /* ��ȡ��Ҫ����������ڴ���� */

    if (size % memblksize[memx]) nmemb++;

    for (offset = memtblsize[memx] - 1; offset >= 0; offset--)  /* ���������ڴ������ */
    {
        if (!mallco_dev.memmap[memx][offset])
        {
            cmemb++;            /* �������ڴ�������� */
        }
        else 
        {
            cmemb = 0;          /* �����ڴ������ */
        }
        
        if (cmemb == nmemb)     /* �ҵ�������nmemb�����ڴ�� */
        {
            for (i = 0; i < nmemb; i++) /* ��ע�ڴ��ǿ� */
            {
                mallco_dev.memmap[memx][offset + i] = nmemb;
            }

            return (offset * memblksize[memx]); /* ����ƫ�Ƶ�ַ */
        }
    }

    return 0XFFFFFFFF;  /* δ�ҵ����Ϸ����������ڴ�� */
}

/**
 * @brief       �ͷ��ڴ�(�ڲ�����)
 * @param       memx   : �����ڴ��
 * @param       offset : �ڴ��ַƫ��
 * @retval      �ͷŽ��
 *   @arg       0, �ͷųɹ�;
 *   @arg       1, �ͷ�ʧ��;
 *   @arg       2, ��������(ʧ��);
 */
static uint8_t my_mem_free(uint8_t memx, uint32_t offset)
{
    int i;

    if (!mallco_dev.memrdy[memx])   /* δ��ʼ��,��ִ�г�ʼ�� */
    {
        mallco_dev.init(memx);
        return 1;                   /* δ��ʼ�� */
    }

    if (offset < memsize[memx])     /* ƫ�����ڴ����. */
    {
        int index = offset / memblksize[memx];      /* ƫ�������ڴ����� */
        int nmemb = mallco_dev.memmap[memx][index]; /* �ڴ������ */

        for (i = 0; i < nmemb; i++)                 /* �ڴ������ */
        {
            mallco_dev.memmap[memx][index + i] = 0;
        }

        return 0;
    }
    else
    {
        return 2;   /* ƫ�Ƴ�����. */
    }
}

/**
 * @brief       �ͷ��ڴ�(�ⲿ����)
 * @param       memx : �����ڴ��
 * @param       ptr  : �ڴ��׵�ַ
 * @retval      ��
 */
void myfree(uint8_t memx, void *ptr)
{
    uint32_t offset;

    if (ptr == NULL)return;     /* ��ַΪ0. */

    offset = (uint32_t)ptr - (uint32_t)mallco_dev.membase[memx];
    my_mem_free(memx, offset);  /* �ͷ��ڴ� */
}

/**
 * @brief       �����ڴ�(�ⲿ����)
 * @param       memx : �����ڴ��
 * @param       size : Ҫ������ڴ��С(�ֽ�)
 * @retval      ���䵽���ڴ��׵�ַ.
 */
void *mymalloc(uint8_t memx, uint32_t size)
{
    uint32_t offset;
    offset = my_mem_malloc(memx, size);

    if (offset == 0XFFFFFFFF)   /* ������� */
    {
        return NULL;            /* ���ؿ�(0) */
    }
    else    /* ����û����, �����׵�ַ */
    {
        return (void *)((uint32_t)mallco_dev.membase[memx] + offset);
    }
}

/**
 * @brief       ���·����ڴ�(�ⲿ����)
 * @param       memx : �����ڴ��
 * @param       *ptr : ���ڴ��׵�ַ
 * @param       size : Ҫ������ڴ��С(�ֽ�)
 * @retval      �·��䵽���ڴ��׵�ַ.
 */
void *myrealloc(uint8_t memx, void *ptr, uint32_t size)
{
    uint32_t offset;
    offset = my_mem_malloc(memx, size);

    if (offset == 0XFFFFFFFF)   /* ������� */
    {
        return NULL;            /* ���ؿ�(0) */
    }
    else    /* ����û����, �����׵�ַ */
    {
        my_mem_copy((void *)((uint32_t)mallco_dev.membase[memx] + offset), ptr, size); /* �������ڴ����ݵ����ڴ� */
        myfree(memx, ptr);  /* �ͷž��ڴ� */
        return (void *)((uint32_t)mallco_dev.membase[memx] + offset);   /* �������ڴ��׵�ַ */
    }
}












