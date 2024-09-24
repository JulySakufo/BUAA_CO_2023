#include <stdio.h>
int m,n;
int array[1000];
int key;
void binary_search(int key);
int main()
{
    scanf("%d",&m);
    for(int i=0;i<m;i++){
        scanf("%d",&array[i]);
    }

    scanf("%d",&n);
    for(int i=0;i<n;i++){
        scanf("%d",&key);
        binary_search(key);
    }
    return 0;
}

void binary_search(int key){
    int low=0,high=m-1,mid;
    int flag=0;
    while(low<=high){
        mid=low+(high-low)/2;
        if(array[mid]>key){
            high=mid-1;
        }
        else if(array[mid]==key){
            printf("1\n");
            flag=1;
            break;
        }
        else{
            low=mid+1;
        }
    }
    if(flag==0){
        printf("0\n");
    }
}