#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main(){
    int a,b,d,c=0;
    srand((unsigned)time(NULL));
    printf("ѡ���Ѷ�(1:�򵥣�2:�еȣ�3:���ѣ�:");
    scanf("%d",&d);
    if(0<d&&d<4)
    {
        if(d==1)
        {
            b=rand()%10;
            printf("���Ѷȣ�0~10�������\n");
        }
        else if(d==2)
        {
            b=rand()%100;
            printf("�е��Ѷȣ�0~100�������\n");
        }
        else if(d==3)
        {
            b=rand()%1000;
            printf("�����Ѷȣ�0~1000�������\n");
        }
        printf("���л�������%d\n",5-c);
        printf("��������:");
    //printf("b=%d",b);
        scanf("%d",&a);
        while(a!=b&&c<4)
        {
            if(a>b)
            {
                printf("Too Big\n");
                c=c+1;
                printf("ʣ���������%d\n",5-c);
                printf("��������:");
                scanf("%d",&a);
                printf("\n");
            }
            else if(a<b)
            {
                printf("Too Small\n");
                c=c+1;
                printf("ʣ���������%d\n",5-c);
                printf("��������:");
                scanf("%d",&a);
                printf("\n");
            }
        }
        if(a!=b)
            printf("ʧ��");
        else if(a==b)
        {
            printf("Correct!");
            printf("�����=%d\n",b);
        }
    }
    else if(d<=0||d>=3)
    {
        printf("�Ѷ�ѡ��ʧ��");
    }
    return 0;
}
