typedef struct
{
    volatile uint8_t KEY;
} KeyBoardType;

#define KEYBOARD ((KeyBoardType *)KEYBOARD_BASE)