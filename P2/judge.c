#include <stdio.h>
int n;
char strings_1[25];
char strings_2[25];
int flag;
int main()
{
    scanf("%d",&n);
    for(int i=0;i<n;i++){
        scanf(" %c",&strings_1[i]);
        strings_2[n-1-i]=strings_1[i];
    }
    for(int i=0;i<n;i++){
        if(strings_1[i]!=strings_2[i]){
            flag=1;
            break;
        }
    }
    if(flag==1){
        printf("0");
    }
    else{
        printf("1");
    }
    return 0;
}