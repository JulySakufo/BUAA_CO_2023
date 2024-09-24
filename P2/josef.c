#include <stdio.h>
#include <stdlib.h>
struct node
{
    int value;
    struct node* link;
};
int n,m;
int flag;
struct node *p,*head;
int main()
{
    scanf("%d%d",&n,&m);
    for(int i=0;i<n;i++)
    {
        if(i==0)
        {
            head=p=(struct node*)malloc(sizeof(struct node));
            head->value = p->value = i+1;
            head->link = p->link =NULL;
        }
        else
        {
            struct node *q = (struct node *)malloc(sizeof(struct node));
            q->value=i+1;
            q->link=NULL;
            p->link=q;
            p=q;
        }
    }
    p->link=head;
    struct node *prev,*now;
    for(prev=head;prev->link!=head;prev=prev->link);
    now=head;
    while(head->link!=NULL){
        if(head->link==head){
            printf("%d",head->value);
            break;
        }
        if(flag==m-1){
            printf("%d\n",now->value);
            prev->link=now->link;
            head=now->link;
            free(now);
            now=head;
            flag=0;
        }
        else
        {
            prev=now;
            now=now->link;
            flag++;
        }
    }
    return 0;
}