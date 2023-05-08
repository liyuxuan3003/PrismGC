/*----------------------------------------------*/
/* TJpgDec System Configurations R0.03          */
/*----------------------------------------------*/

#define	JD_SZBUF        1024
/* Specifies size of stream input buffer */

#define JD_FORMAT       1
/* Specifies output pixel format.
/  0: RGB888 (24-bit/pix)
/  1: RGB565 (16-bit/pix)
/  2: Grayscale (8-bit/pix)
*/

#define	JD_USE_SCALE    1
/* Switches output descaling feature.
/  0: Disable
/  1: Enable
*/

#define JD_TBLCLIP      1
/* Use table conversion for saturation arithmetic. A bit faster, but increases 1 KB of code size.
/  0: Disable
/  1: Enable
*/

#define JD_FASTDECODE   2
/* Optimization level
/  0: Basic optimization. Suitable for 8/16-bit MCUs.
/  1: + 32-bit barrel shifter. Suitable for 32-bit MCUs.
/  2: + Table conversion for huffman decoding (wants 6 << HUFF_BIT bytes of RAM)
*/

/******************************************************************************************/
/* �û�������(����ԭ���Ŷ����) */
/* R0.03����� R0.01C �ٶ������޴�, ��F4��, R0.01C ����800*480ͼƬ��Ҫ950ms���� 
 * R0.03 ����JD_FASTDECODE = 2 ʱ, ����ͬһ��ͼƬ, ֻ��Ҫ620ms, ����35%.
 * �ٿ���-O2�Ż�, ����ͬһ��ͼƬ, ֻ��Ҫ504ms, ����47%.
 * H750����tjpg.c�Ǵ�����ⲿSPI FLASH,��������ļ�������Ҳ�Ƿ����ⲿSPI FLASH���������ܼ���û���������������½���
 * ��������������԰�tjpgd.o�ŵ��ڲ�FLASH���޸ķ�ɢ�����ļ��������ٶȻ�������
 */

#define JPEG_USE_MALLOC     1               /* �����Ƿ�ʹ��malloc,��������ѡ��ʹ��malloc */
#define JPEG_WBUF_SIZE      6144 + 4096     /* ���幤���������С,����Ӧ��С��3092�ֽ�, ���JD_FASTDECODE==2, ����Ҫ���� 6144�ֽ��ڴ� */

/******************************************************************************************/










