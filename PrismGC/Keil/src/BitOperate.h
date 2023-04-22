#ifndef BITOPERATE_H
#define BITOPERATE_H

#define BIT(x) (1<<x)                       //获取一个第x位为1的数
#define BIT_SET(a,x) (a|=(BIT(x)))          //设置a的第x位为1
#define BIT_CLR(a,x) (a&=~(BIT(x)))         //设置a的第x位为0
#define BIT_IS1(a,x) (a&(BIT(x)))           //判断a的第x位是否为1
#define BIT_IS0(a,x) (!(a&(BIT(x))))        //判读a的第x位是否为0

#define IS1(a) (a)
#define IS0(a) (!a)

#endif