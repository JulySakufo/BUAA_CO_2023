#include <stdio.h>
int n;
int ans[1005];
int flag;
int main()
{
    scanf("%d",&n);
    ans[0]=1;
    for(int i=1;i<n+1;i++){
        for(int j=0;j<1005;j++){
            ans[j]=ans[j]*i;
        }
        for(int j=0;j<1005;j++){
            if(ans[j]>=10){
                ans[j+1]=ans[j+1]+ans[j]/10;
                ans[j]=ans[j]%10;
            }
        }
    }
    int k=1004;
    while(ans[k]==0&&k>=0){
        k--;
    }
    for(int i=k;i>=0;i--){
        printf("%d",ans[i]);
    }
    return 0;
}