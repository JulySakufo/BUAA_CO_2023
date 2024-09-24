#include <stdio.h>
int n;
int matrix_1[8][8];
int matrix_2[8][8];
int sum;
int main()
{
    scanf("%d",&n);
    for(int i=0;i<n;i++)
    {
        for(int j=0;j<n;j++){
            scanf("%d",&matrix_1[i][j]);
        }
    }
    for(int i=0;i<n;i++){
        for(int j=0;j<n;j++){
            scanf("%d",&matrix_2[i][j]);
        }
    }
    for(int i=0;i<n;i++){
        for(int j=0;j<n;j++){
            sum=0;
            for(int k=0;k<n;k++){
                sum = sum+matrix_1[i][k]*matrix_2[k][j];
            }
            printf("%d ",sum);
        }
        printf("\n");
    }
    return 0;
}