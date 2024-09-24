#include <stdio.h>
int m,n;
int a,b,c;//百位，十位，个位；
int main()
{
    scanf("%d%d",&m,&n);
    for(int i=m;i<n;i++){
        int origin=i;
        a=origin%10;
        origin=origin/10;
        b=origin%10;
        origin=origin/10;
        c=origin%10;
        if(a*a*a+b*b*b+c*c*c==i)
        printf("%d ",i);
    }
    return 0;
}