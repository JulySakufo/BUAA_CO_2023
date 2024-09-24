#include <stdio.h>
int n,m;
int sum;
int graph[8][8];
int src_i,src_j,des_i,des_j;
void dfs(int pos_i,int pos_j);
int main()
{
    scanf("%d%d",&n,&m);
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            graph[i][j]=1;
        }
    }
    for(int i=0;i<n;i++){
        for(int j=0;j<m;j++){
            scanf("%d",&graph[i][j]);
        }
    }
    scanf("%d%d%d%d",&src_i,&src_j,&des_i,&des_j);
    src_i--;
    src_j--;
    des_i--;
    des_j--;//调整系数使之与矩阵真实行列数相匹配；
    graph[src_i][src_j]=1;
    dfs(src_i,src_j);
    printf("%d",sum);
    return 0;
}

void dfs(int pos_i,int pos_j){
    if(pos_i==des_i&&pos_j==des_j){
        sum=sum+1;
        return;
    } //找到了从起点到终点的一条路径;

    if((pos_j+1<m)&&graph[pos_i][pos_j+1]==0){
        graph[pos_i][pos_j+1]=1;//标记这个位置被走过;
        dfs(pos_i,pos_j+1);
        graph[pos_i][pos_j+1]=0;//返回;
    } //向右移动;

    if((pos_j-1>=0)&&graph[pos_i][pos_j-1]==0){
        graph[pos_i][pos_j-1]=1;
        dfs(pos_i,pos_j-1);
        graph[pos_i][pos_j-1]=0;
    }

    if((pos_i+1<n)&&graph[pos_i+1][pos_j]==0){
        graph[pos_i+1][pos_j]=1;
        dfs(pos_i+1,pos_j);
        graph[pos_i+1][pos_j]=0;
    }

    if((pos_i-1>=0)&&graph[pos_i-1][pos_j]==0){
        graph[pos_i-1][pos_j]=1;
        dfs(pos_i-1,pos_j);
        graph[pos_i-1][pos_j]=0;
    }
}