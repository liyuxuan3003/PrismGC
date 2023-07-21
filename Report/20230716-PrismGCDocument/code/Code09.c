#define BIT(x) (1<<x)                       //获取一个第x位为1的数

#define SWI_0(X) (BASE(GPIOA_ADDR) X BIT(0))
#define SWI_1(X) (BASE(GPIOA_ADDR) X BIT(1))
#define SWI_2(X) (BASE(GPIOA_ADDR) X BIT(2))
#define SWI_3(X) (BASE(GPIOA_ADDR) X BIT(3))
#define SWI_4(X) (BASE(GPIOA_ADDR) X BIT(4))
#define SWI_5(X) (BASE(GPIOA_ADDR) X BIT(5))
#define SWI_6(X) (BASE(GPIOA_ADDR) X BIT(6))
#define SWI_7(X) (BASE(GPIOA_ADDR) X BIT(7))

#define LED_0(X) (BASE(GPIOA_ADDR) X BIT(8))
#define LED_1(X) (BASE(GPIOA_ADDR) X BIT(9))
#define LED_2(X) (BASE(GPIOA_ADDR) X BIT(10))
#define LED_3(X) (BASE(GPIOA_ADDR) X BIT(11))
#define LED_4(X) (BASE(GPIOA_ADDR) X BIT(12))
#define LED_5(X) (BASE(GPIOA_ADDR) X BIT(13))
#define LED_6(X) (BASE(GPIOA_ADDR) X BIT(14))
#define LED_7(X) (BASE(GPIOA_ADDR) X BIT(15))

#define SCL(X) (BASE(GPIOB_ADDR) X BIT(0))
#define SDA(X) (BASE(GPIOB_ADDR) X BIT(1))