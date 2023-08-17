#include "GetKey.h"

#include "Keyboard.h"
#include "Nunchuck.h"

uint8_t GetKey(uint8_t buttonZ)
{
    uint8_t key=0;

    // 判断来自键盘的输入
    switch(KEYBOARD->KEY)
    {
        case 0x05: key=KEY_R; break;
        case 0x07: key=KEY_L; break;
        case 0x0A: key=KEY_U; break;
        case 0x02: key=KEY_D; break;
        case 0x06: key=KEY_C; break;
        case 0x0F: key=KEY_E; break;
    }

    // 判断来自手柄的输入
    if(IsNumchuckReady()==0)
    {
        switch(NunchuckKey(buttonZ))
        {
            case 'R': key=KEY_R; break;
            case 'L': key=KEY_L; break;
            case 'U': key=KEY_U; break;
            case 'D': key=KEY_D; break;
            case 'C': key=KEY_C; break;
            case 'E': key=KEY_E; break;
        }
    }

    return key;
}

uint8_t IsDirection(uint8_t key)
{
    if(key==KEY_R || key==KEY_L || key==KEY_U || key==KEY_D)
        return 1;
    else
        return 0;
}