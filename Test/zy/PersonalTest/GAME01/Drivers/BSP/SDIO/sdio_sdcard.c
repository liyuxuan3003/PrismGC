/**
 ****************************************************************************************************
 * @file        sdio_sdcard.c
 * @author      ����ԭ���Ŷ�(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-28
 * @brief       SD�� ��������
 * @license     Copyright (c) 2020-2032, ������������ӿƼ����޹�˾
 ****************************************************************************************************
 * @attention
 *
 * ʵ��ƽ̨:����ԭ�� STM32F103������
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
#include "./SYSTEM/usart/usart.h"
#include "./BSP/SDIO/sdio_sdcard.h"

SD_HandleTypeDef g_sdcard_handler;            /* SD����� */
HAL_SD_CardInfoTypeDef g_sd_card_info_handle; /* SD����Ϣ�ṹ�� */

/* sdmmc_read_disk/sdmmc_write_disk����ר��buf,�����������������ݻ�������ַ����4�ֽڶ����ʱ��,
 * ��Ҫ�õ�������,ȷ�����ݻ�������ַ��4�ֽڶ����.
 */
__ALIGNED(4) uint8_t g_sd_data_buffer[512];

/**
 * @brief       ��ʼ��SD��
 * @param       ��
 * @retval      ����ֵ:0 ��ʼ����ȷ������ֵ����ʼ������
 */
uint8_t sd_init(void)
{
    uint8_t SD_Error;

    /* ��ʼ��ʱ��ʱ�Ӳ��ܴ���400KHZ */
    g_sdcard_handler.Instance = SDIO;
    g_sdcard_handler.Init.ClockEdge = SDIO_CLOCK_EDGE_RISING;                      /* ������ */
    g_sdcard_handler.Init.ClockBypass = SDIO_CLOCK_BYPASS_DISABLE;                 /* ��ʹ��bypassģʽ��ֱ����HCLK���з�Ƶ�õ�SDIO_CK */
    g_sdcard_handler.Init.ClockPowerSave = SDIO_CLOCK_POWER_SAVE_DISABLE;          /* ����ʱ���ر�ʱ�ӵ�Դ */
    g_sdcard_handler.Init.BusWide = SDIO_BUS_WIDE_1B;                              /* 1λ������ */
    g_sdcard_handler.Init.HardwareFlowControl = SDIO_HARDWARE_FLOW_CONTROL_ENABLE; /* ����Ӳ������ */
    g_sdcard_handler.Init.ClockDiv = SDIO_TRANSFER_CLK_DIV;                        /* SD����ʱ��Ƶ�����25MHZ */

    SD_Error = HAL_SD_Init(&g_sdcard_handler);
    if (SD_Error != HAL_OK)
    {
        return 1;
    }

//    SD_Error = HAL_SD_ConfigWideBusOperation(&g_sdcard_handler, SDIO_BUS_WIDE_4B); /* ʹ�ܿ�����ģʽ,-O0 �Ż��������� */
//    if (SD_Error != HAL_OK)
//    {
//        return 2;
//    }
    return 0;
}

/**
 * @brief       SDMMC�ײ�������ʱ��ʹ�ܣ��������ã�DMA����
                �˺����ᱻHAL_SD_Init()����
 * @param       hsd:SD�����
 * @retval      ��
 */
void HAL_SD_MspInit(SD_HandleTypeDef *hsd)
{
    if (hsd->Instance == SDIO)
    {
        DMA_HandleTypeDef TxDMAHandler, RxDMAHandler;
        GPIO_InitTypeDef GPIO_Initure;

        __HAL_RCC_SDIO_CLK_ENABLE(); /* ʹ��SDIOʱ�� */
        //__HAL_RCC_DMA2_CLK_ENABLE(); /* ʹ��DMA2ʱ�� */

        SD_D0_GPIO_CLK_ENABLE();  /* D0����IOʱ��ʹ�� */
        SD_D1_GPIO_CLK_ENABLE();  /* D1����IOʱ��ʹ�� */
        SD_D2_GPIO_CLK_ENABLE();  /* D2����IOʱ��ʹ�� */
        SD_D3_GPIO_CLK_ENABLE();  /* D3����IOʱ��ʹ�� */
        SD_CLK_GPIO_CLK_ENABLE(); /* CLK����IOʱ��ʹ�� */
        SD_CMD_GPIO_CLK_ENABLE(); /* CMD����IOʱ��ʹ�� */

        /* SD_D0����ģʽ���� */
        GPIO_Initure.Pin = SD_D0_GPIO_PIN;
        GPIO_Initure.Mode = GPIO_MODE_AF_PP;           /* ���츴�� */
        GPIO_Initure.Pull = GPIO_PULLUP;               /* ���� */
        GPIO_Initure.Speed = GPIO_SPEED_FREQ_HIGH;     /* ���� */
        HAL_GPIO_Init(SD_D0_GPIO_PORT, &GPIO_Initure); /* ��ʼ�� */
        /* SD_D1����ģʽ���� */
        GPIO_Initure.Pin = SD_D1_GPIO_PIN;
        HAL_GPIO_Init(SD_D1_GPIO_PORT, &GPIO_Initure); /* ��ʼ�� */
        /* SD_D2����ģʽ���� */
        GPIO_Initure.Pin = SD_D2_GPIO_PIN;
        HAL_GPIO_Init(SD_D2_GPIO_PORT, &GPIO_Initure); /* ��ʼ�� */
                                                       /* SD_D3����ģʽ���� */
        GPIO_Initure.Pin = SD_D3_GPIO_PIN;
        HAL_GPIO_Init(SD_D3_GPIO_PORT, &GPIO_Initure); /* ��ʼ�� */
        /* SD_CLK����ģʽ���� */
        GPIO_Initure.Pin = SD_CLK_GPIO_PIN;
        HAL_GPIO_Init(SD_CLK_GPIO_PORT, &GPIO_Initure); /* ��ʼ�� */
        /* SD_CMD����ģʽ���� */
        GPIO_Initure.Pin = SD_CMD_GPIO_PIN;
        HAL_GPIO_Init(SD_CMD_GPIO_PORT, &GPIO_Initure); /* ��ʼ�� */
    }
}

/**
 * @brief       ��ȡ����Ϣ����
 * @param       cardinfo:SD����Ϣ���
 * @retval      ����ֵ:��ȡ����Ϣ״ֵ̬
 */
uint8_t get_sd_card_info(HAL_SD_CardInfoTypeDef *cardinfo)
{
    uint8_t sta;
    sta = HAL_SD_GetCardInfo(&g_sdcard_handler, cardinfo);
    return sta;
}

/**
 * @brief       �ж�SD���Ƿ���Դ���(��д)����
 * @param       ��
 * @retval      ����ֵ:SD_TRANSFER_OK      ������ɣ����Լ�����һ�δ���
                       SD_TRANSFER_BUSY SD ����æ�������Խ�����һ�δ���
 */
uint8_t get_sd_card_state(void)
{
    return ((HAL_SD_GetCardState(&g_sdcard_handler) == HAL_SD_CARD_TRANSFER) ? SD_TRANSFER_OK : SD_TRANSFER_BUSY);
}

/**
 * @brief       ��SD��(fatfs/usb����)
 * @param       pbuf  : ���ݻ�����
 * @param       saddr : ������ַ
 * @param       cnt   : ��������
 * @retval      0, ����;  ����, �������(���SD_Error����);
 */
uint8_t sd_read_disk(uint8_t *pbuf, uint32_t saddr, uint32_t cnt)
{
    uint8_t sta = HAL_OK;
    uint32_t timeout = SD_TIMEOUT;
    long long lsector = saddr;
    __disable_irq();                                                                       /* �ر����ж�(POLLINGģʽ,�Ͻ��жϴ��SDIO��д����!!!) */
    sta = HAL_SD_ReadBlocks(&g_sdcard_handler, (uint8_t *)pbuf, lsector, cnt, SD_TIMEOUT); /* ���sector�Ķ����� */

    /* �ȴ�SD������ */
    while (get_sd_card_state() != SD_TRANSFER_OK)
    {
        if (timeout-- == 0)
        {
            sta = SD_TRANSFER_BUSY;
        }
    }
    __enable_irq(); /* �������ж� */
    return sta;
}

/**
 * @brief       дSD��(fatfs/usb����)
 * @param       pbuf  : ���ݻ�����
 * @param       saddr : ������ַ
 * @param       cnt   : ��������
 * @retval      0, ����;  ����, �������(���SD_Error����);
 */
uint8_t sd_write_disk(uint8_t *pbuf, uint32_t saddr, uint32_t cnt)
{
    uint8_t sta = HAL_OK;
    uint32_t timeout = SD_TIMEOUT;
    long long lsector = saddr;
    __disable_irq();                                                                        //�ر����ж�(POLLINGģʽ,�Ͻ��жϴ��SDIO��д����!!!)
    sta = HAL_SD_WriteBlocks(&g_sdcard_handler, (uint8_t *)pbuf, lsector, cnt, SD_TIMEOUT); //���sector��д����

    /* �ȴ�SD��д�� */
    while (get_sd_card_state() != SD_TRANSFER_OK)
    {
        if (timeout-- == 0)
        {
            sta = SD_TRANSFER_BUSY;
        }
    }
    __enable_irq(); /* �������ж� */
    return sta;
}
