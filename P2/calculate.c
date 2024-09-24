#include <stdio.h>
int n;
int cnt[26];//用于小写字母字符的个数
int appear[26];//用于记录出现顺序；
char ch;
int main()
{
    scanf("%d",&n);
    for(int i=0;i<n;i++){
        scanf(" %c",&ch);
        for(int j=0;j<26;j++){
            if(appear[j]==ch)//如果在顺序数组中出现过该字符，无须再记录顺序；
            break;
            if(appear[j]==0){//没找到，则顺次记录然后退出循环;
                appear[j]=ch;
                break;
            }
        }
        cnt[ch-'a']++;
    }
    for(int i=0;i<26;i++){
        if(cnt[appear[i]-'a']!=0){
            printf("%c %d\n",appear[i],cnt[appear[i]-'a']);
        }
    }
    return 0;
}