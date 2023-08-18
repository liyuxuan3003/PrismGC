typedef struct
{
    volatile uint32_t I_DAT;
    volatile uint32_t O_ENA;
    volatile uint32_t O_DAT;
} GPIOType;

#define GPIOA ((GPIOType *)GPIOA_BASE)
#define GPIOB ((GPIOType *)GPIOB_BASE)
#define GPIOC ((GPIOType *)GPIOC_BASE)
#define GPIOD ((GPIOType *)GPIOD_BASE)