#include <stdio.h>
int main()
{
    int a,min;
    int *p;

    /*printf("确定需要从大到小排序的数字数量:");
    scanf("%d",&a);
    int b[a];*/
    int b[10];

    //printf("输入需要排序的%d个数字:",a);
    printf("输入需要排序的10个数字:");
    for(int i=0;i<10;i++)
    {
        scanf("%d",&b[i]);
    }

    for(int j=0;j<10-1;j++)
    {
        for(int k=0;k<10-1;k++)
        {
            min=b[k];
            if(b[k]<b[k+1])
            {
                b[k]=b[k+1];
                b[k+1]=min;
            }
        }
    }

    printf("从大到小排序为：\n");
    for(int l=0;l<10;l++)
    {
        p=&b[l];
        printf("%d\n",*p);
    }

    return 0;
}

