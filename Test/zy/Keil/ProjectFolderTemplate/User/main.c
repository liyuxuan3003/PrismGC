#include "./SYSTEM/sys/sys.h"
#include "./SYSTEM/usart/usart.h"
#include "./SYSTEM/delay/delay.h"
int main(void)
{
 uint8_t t = 0;
 sys_stm32_clock_init(9); /* 设置时钟, 72Mhz */
 delay_init(72); /* 延时初始化 */
 usart_init(72, 115200); /* 串口初始化 */
 while (1)
 {
 printf("t:%d\r\n", t);
 delay_ms(500);
 t++;
 }
}