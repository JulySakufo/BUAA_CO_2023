#include <stdio.h>
int matrix_1[8][8];
int change_1[8][8];
int matrix_2[8][8];
int change_2[8][8];
int sum;
int n,m;

int main()
{
    scanf("%d%d",&n,&m);
    for(int i=0;i<n;i++){
        for(int j=0;j<m;j++){
            scanf("%d",&matrix_1[i][j]);
            change_1[j][i]=matrix_1[i][j];
        }
    }
    for(int i=0;i<n;i++){
        for(int j=0;j<m;j++){
            scanf("%d",&matrix_2[i][j]);
            change_2[j][i]=matrix_2[i][j];
        }
    }
    
    printf("The result is:\n");

    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            sum=change_1[i][j]+change_2[i][j];
            printf("%d ",sum);
        }
        printf("\n");
    }
    return 0;
}