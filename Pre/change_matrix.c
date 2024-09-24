#include <stdio.h>
int n,m;
int matrix[50][50];

int main()
{
    scanf("%d%d",&n,&m);
    for(int i=0;i<n;i++)
    for(int j=0;j<m;j++)
    scanf("%d",&matrix[i][j]);

    for(int i=n-1;i>=0;i--)
    {
        for(int j=m-1;j>=0;j--)
        {
            if(matrix[i][j]!=0)
            printf("%d %d %d\n",i+1,j+1,matrix[i][j]);
        }
    }
    return 0;
}