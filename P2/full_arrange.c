#include <stdio.h>
int symbol[7],array[7];
int n;
void full_arrange(int index);
int main()
{
    scanf("%d",&n);
    full_arrange(0);
    return 0;
}

void full_arrange(int index){
    int i;
    if(index>=n){
        for(i=0;i<n;i++){
            printf("%d ",array[i]);
        }
        printf("\n");
        return;
    }

    for(i=0;i<n;i++){
        if(symbol[i]==0){
            array[index]=i+1;
            symbol[i]=1;
            full_arrange(index+1);
            symbol[i]=0;
        }
    }
}