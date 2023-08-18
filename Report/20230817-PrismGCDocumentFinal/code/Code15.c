typedef struct
{
    volatile uint32_t NOTE:4;
    volatile uint32_t NOTE_NC:28;
    volatile uint32_t TIME;
    volatile uint32_t OUTPUT:2;
    volatile uint32_t OUTPUT_NC:30;
} BuzzerType;

#define BUZZER ((BuzzerType *)BUZZER_BASE)