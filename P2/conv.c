#include <stdio.h>
int m1,n1,m2,n2;
int matrix[11][11];
int core[11][11];
int i_difference,j_difference;
int sum;
int main()
{
    scanf("%d%d%d%d",&m1,&n1,&m2,&n2);
    for(int i=0;i<m1;i++){
        for(int j=0;j<n1;j++){
            scanf("%d",&matrix[i][j]);
        }
    }
    for(int i=0;i<m2;i++){
        for(int j=0;j<n2;j++){
            scanf("%d",&core[i][j]);
        }
    }
    i_difference = m1-m2+1;
    j_difference = n1-n2+1;
    for(int i=0;i<i_difference;i++){
        for(int j=0;j<j_difference;j++){
            sum=0;
            for(int p=0;p<m2;p++){
                for(int q=0;q<n2;q++){
                    sum = sum + matrix[i+p][j+q]*core[p][q];
                }
            }
            printf("%d ",sum);
        }
        printf("\n");
    }
    return 0;
}