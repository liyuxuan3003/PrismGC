#include <stdio.h>
#include <stdlib.h>
int main()
{
    int a,min,max;
    printf("请输入需要排序的整数个数：");
    scanf("%d",&a);
    int *p,*q;
    p=(int*)malloc(a*sizeof(int));
    /*printf("确定需要从大到小排序的数字数量:");
    scanf("%d",&a);
    int b[a];*/
    printf("输入需要排序的%d个数字:",a);
    for(int i=0;i<a;i++)
    {
        scanf("%d",p+i);
    }
    /*for(int i=0;i<a;i++)
    {
        printf("%d ",*(p+i));
    }*/
    for(int j=0;j<a;j++)
    {
        for(int k=0;k<a;k++)
        {
            min=*(p+k);
            max=*(p+k+1);
            if(min<max)
            {
                *(p+k)=max;
                *(p+k+1)=min;
            }
        }
    }
    printf("从大到小排序为：\n");
    for(int l=0;l<a;l++)
    {
        printf("%d ",*(p+l));
    }
    return 0;
}

