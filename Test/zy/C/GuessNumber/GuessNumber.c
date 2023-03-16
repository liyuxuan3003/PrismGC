#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main(){
    int a,b,d,c=0;
    srand((unsigned)time(NULL));
    printf("选择难度(1:简单，2:中等，3:困难）:");
    scanf("%d",&d);
    if(0<d&&d<4)
    {
        if(d==1)
        {
            b=rand()%10;
            printf("简单难度：0~10随机整数\n");
        }
        else if(d==2)
        {
            b=rand()%100;
            printf("中等难度：0~100随机整数\n");
        }
        else if(d==3)
        {
            b=rand()%1000;
            printf("困难难度：0~1000随机整数\n");
        }
        printf("共有机会数：%d\n",5-c);
        printf("输入整数:");
    //printf("b=%d",b);
        scanf("%d",&a);
        while(a!=b&&c<4)
        {
            if(a>b)
            {
                printf("Too Big\n");
                c=c+1;
                printf("剩余机会数：%d\n",5-c);
                printf("输入整数:");
                scanf("%d",&a);
                printf("\n");
            }
            else if(a<b)
            {
                printf("Too Small\n");
                c=c+1;
                printf("剩余机会数：%d\n",5-c);
                printf("输入整数:");
                scanf("%d",&a);
                printf("\n");
            }
        }
        if(a!=b)
            printf("失败");
        else if(a==b)
        {
            printf("Correct!");
            printf("随机数=%d\n",b);
        }
    }
    else if(d<=0||d>=3)
    {
        printf("难度选择失败");
    }
    return 0;
}
