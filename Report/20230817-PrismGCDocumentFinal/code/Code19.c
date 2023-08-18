typedef struct
{
    volatile uint32_t X_POS;
    volatile uint32_t Y_POS;
    volatile uint32_t PIXEL;
    volatile uint32_t LEN;
    volatile uint32_t ENABLE;
    volatile uint32_t SYS_WR_LEN;
    volatile uint32_t SYS_VAILD;
    volatile uint32_t BUSY;
    volatile uint32_t PING_PONG;
} GPUType;

#define GPU ((GPUType *)GPU_LITE_BASE)
#define GPU_PIXELS ((uint32_t *)(GPU_LITE_BASE+16*4))