#include "./SYSTEM/sys/sys.h"
#include "./SYSTEM/usart/usart.h"
#include "./SYSTEM/delay/delay.h"
int main(void)
{
 uint8_t t = 0;
 sys_stm32_clock_init(9); /* ����ʱ��, 72Mhz */
 delay_init(72); /* ��ʱ��ʼ�� */
 usart_init(72, 115200); /* ���ڳ�ʼ�� */
 while (1)
 {
 printf("t:%d\r\n", t);
 delay_ms(500);
 t++;
 }
}