#include <stdio.h>
int main()
{
    int a,min;
    int *p;

    /*printf("ȷ����Ҫ�Ӵ�С�������������:");
    scanf("%d",&a);
    int b[a];*/
    int b[10];

    //printf("������Ҫ�����%d������:",a);
    printf("������Ҫ�����10������:");
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

    printf("�Ӵ�С����Ϊ��\n");
    for(int l=0;l<10;l++)
    {
        p=&b[l];
        printf("%d\n",*p);
    }

    return 0;
}

