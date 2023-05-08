#include"code_def.h"

void SYSInit(void)
{
	// IRQ enable
	NVIC_CTRL_ADDR	=	0x7;

    // Systick initial
	Set_SysTick_CTRL(0);
}

void Delay(uint32_t time)
{
	Set_SysTick_CTRL(0);
	Set_SysTick_LOAD(time);
	Set_SysTick_VALUE(0);
	Set_SysTick_CTRL(0x7);
	__wfi();
}

void PlayBGM(char* BeginAddr,bool isCyl)
{
    Buzzer->BuzzerBGMAddr = (uint32_t)BeginAddr;
    if(isCyl)
    {
        Buzzer->BuzzerBGMCtr = 6;
    }
    else
    {
        Buzzer->BuzzerBGMCtr = 2;
    }
}

void StopBGM()
{
    Buzzer->BuzzerBGMCtr |= 1;
}

void StartBGM()
{
    Buzzer->BuzzerBGMCtr &= 0xFFFFFFFE;
}

void PlaySound(char* BeginAddr,uint32_t Pri)
{
    Buzzer->BuzzerSoundAddr = (uint32_t)BeginAddr;
    Buzzer->BuzzerSoundCtr  = (Pri << 1) + 1;
}

void ResetBGM()
{
    Buzzer->BuzzerBGMCtr &= 0;
}

//LCD

uint32_t LCD_ini_finish;

void LCD_INI_FINISH(void)
{
	LCD_ini_finish = 1; 
}
