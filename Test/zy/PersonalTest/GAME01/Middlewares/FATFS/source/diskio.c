/**
 ****************************************************************************************************
 * @file        diskio.c
 * @author      正点原子团队(ALIENTEK)
 * @version     V1.0
 * @date        2020-04-28
 * @brief       FATFS底层(diskio) 驱动代码
 * @license     Copyright (c) 2020-2032, 广州市星翼电子科技有限公司
 ****************************************************************************************************
 * @attention
 *
 * 实验平台:正点原子 STM32F103开发板
 * 在线视频:www.yuanzige.com
 * 技术论坛:www.openedv.com
 * 公司网址:www.alientek.com
 * 购买地址:openedv.taobao.com
 *
 * 修改说明
 * V1.0 20200428
 * 第一次发布
 *
 ****************************************************************************************************
 */

#include "./MALLOC/malloc.h"
#include "./FATFS/source/diskio.h"
#include "./BSP/SDIO/sdio_sdcard.h"
#include "./BSP/NORFLASH/norflash.h"



#define SD_CARD     0       /* SD卡,卷标为0 */
#define EX_FLASH    1       /* 外部qspi flash,卷标为1 */


/**
 * 对于25Q128 FLASH芯片, 我们规定前 12M 给FATFS使用, 12M以后
 * 紧跟字库, 3个字库 + UNIGBK.BIN, 总大小3.09M, 共占用15.09M
 * 15.09M以后的存储空间大家可以随便使用. 
 */

#define SPI_FLASH_SECTOR_SIZE   512
#define SPI_FLASH_SECTOR_COUNT  12 * 1024 * 2   /* 25Q128, 前12M字节给FATFS占用 */
#define SPI_FLASH_BLOCK_SIZE    8               /* 每个BLOCK有8个扇区 */
#define SPI_FLASH_FATFS_BASE    0               /* FATFS 在外部FLASH的起始地址 从0开始 */


/**
 * @brief       获得磁盘状态
 * @param       pdrv : 磁盘编号0~9
 * @retval      无
 */
DSTATUS disk_status (
    BYTE pdrv       /* Physical drive nmuber to identify the drive */
)
{
    return RES_OK;
}

/**
 * @brief       初始化磁盘
 * @param       pdrv : 磁盘编号0~9
 * @retval      无
 */
DSTATUS disk_initialize (
    BYTE pdrv       /* Physical drive nmuber to identify the drive */
)
{
    uint8_t res = 0;

    switch (pdrv)
    {
        case SD_CARD:           /* SD卡 */
            res = sd_init();    /* SD卡初始化 */
            break;

        case EX_FLASH:          /* 外部flash */
            norflash_init(); 
            break;

        default:
            res = 1;
    }

    if (res)
    {
        return  STA_NOINIT;
    }
    else
    {
        return 0; /* 初始化成功*/
    }
}

/**
 * @brief       读扇区
 * @param       pdrv   : 磁盘编号0~9
 * @param       buff   : 数据接收缓冲首地址
 * @param       sector : 扇区地址
 * @param       count  : 需要读取的扇区数
 * @retval      无
 */
DRESULT disk_read (
    BYTE pdrv,      /* Physical drive nmuber to identify the drive */
    BYTE *buff,     /* Data buffer to store read data */
    DWORD sector,   /* Sector address in LBA */
    UINT count      /* Number of sectors to read */
)
{
    uint8_t res = 0;

    if (!count)return RES_PARERR;   /* count不能等于0，否则返回参数错误 */

    switch (pdrv)
    {
        case SD_CARD:   /* SD卡 */
            res = sd_read_disk(buff, sector, count);

            while (res)   /* 读出错 */
            {
                if (res != 2)sd_init(); /* 重新初始化SD卡 */

                res = sd_read_disk(buff, sector, count);
                //printf("sd rd error:%d\r\n", res);
            }

            break;

        case EX_FLASH:/* 外部flash */
            for (; count > 0; count--)
            {
                norflash_read(buff, SPI_FLASH_FATFS_BASE + sector * SPI_FLASH_SECTOR_SIZE, SPI_FLASH_SECTOR_SIZE);
                sector++;
                buff += SPI_FLASH_SECTOR_SIZE;
            }

            res = 0;
            break;

        default:
            res = 1;
    }

    /* 处理返回值，将返回值转成ff.c的返回值 */
    if (res == 0x00)
    {
        return RES_OK;
    }
    else
    {
        return RES_ERROR; 
    }
}

/**
 * @brief       写扇区
 * @param       pdrv   : 磁盘编号0~9
 * @param       buff   : 发送数据缓存区首地址
 * @param       sector : 扇区地址
 * @param       count  : 需要写入的扇区数
 * @retval      无
 */
DRESULT disk_write (
    BYTE pdrv,          /* Physical drive nmuber to identify the drive */
    const BYTE *buff,   /* Data to be written */
    DWORD sector,       /* Sector address in LBA */
    UINT count          /* Number of sectors to write */
)
{
    uint8_t res = 0;

    if (!count)return RES_PARERR;   /* count不能等于0，否则返回参数错误 */

    switch (pdrv)
    {
        case SD_CARD:       /* SD卡 */
            res = sd_write_disk((uint8_t *)buff, sector, count);

            while (res)     /* 写出错 */
            {
                sd_init();  /* 重新初始化SD卡 */
                res = sd_write_disk((uint8_t *)buff, sector, count);
                //printf("sd wr error:%d\r\n", res);
            }

            break;

        case EX_FLASH:      /* 外部flash */
            for (; count > 0; count--)
            {
                norflash_write((uint8_t *)buff, SPI_FLASH_FATFS_BASE + sector * SPI_FLASH_SECTOR_SIZE, SPI_FLASH_SECTOR_SIZE);
                sector++;
                buff += SPI_FLASH_SECTOR_SIZE;
            }

            res = 0;
            break;

        default:
            res = 1;
    }

    /* 处理返回值，将返回值转成ff.c的返回值 */
    if (res == 0x00)
    {
        return RES_OK;
    }
    else
    {
        return RES_ERROR; 
    }
}

/**
 * @brief       获取其他控制参数
 * @param       pdrv   : 磁盘编号0~9
 * @param       ctrl   : 控制代码
 * @param       buff   : 发送/接收缓冲区指针
 * @retval      无
 */
DRESULT disk_ioctl (
    BYTE pdrv,      /* Physical drive nmuber (0..) */
    BYTE cmd,       /* Control code */
    void *buff      /* Buffer to send/receive control data */
)
{
    DRESULT res;

    if (pdrv == SD_CARD)    /* SD卡 */
    {
        switch (cmd)
        {
            case CTRL_SYNC:
                res = RES_OK;
                break;

            case GET_SECTOR_SIZE:
                *(DWORD *)buff = 512;
                res = RES_OK;
                break;

            case GET_BLOCK_SIZE:
                *(WORD *)buff = g_sdcard_handler.SdCard.BlockSize; //g_sd_card_info.CardBlockSize;
                res = RES_OK;
                break;

            case GET_SECTOR_COUNT:
                *(DWORD *)buff = ((long long)g_sdcard_handler.SdCard.BlockNbr * g_sdcard_handler.SdCard.BlockSize) / 512;   //g_sd_card_info.CardCapacity / 512;
                res = RES_OK;
                break;

            default:
                res = RES_PARERR;
                break;
        }
    }
    else if (pdrv == EX_FLASH)  /* 外部FLASH */
    {
        switch (cmd)
        {
            case CTRL_SYNC:
                res = RES_OK;
                break;

            case GET_SECTOR_SIZE:
                *(WORD *)buff = SPI_FLASH_SECTOR_SIZE;
                res = RES_OK;
                break;

            case GET_BLOCK_SIZE:
                *(WORD *)buff = SPI_FLASH_BLOCK_SIZE;
                res = RES_OK;
                break;

            case GET_SECTOR_COUNT:
                *(DWORD *)buff = SPI_FLASH_SECTOR_COUNT;
                res = RES_OK;
                break;

            default:
                res = RES_PARERR;
                break;
        }
    }
    else
    {
        res = RES_ERROR;    /* 其他的不支持 */
    }
    
    return res;
}




















