
#include <stdio.h>
#include <time.h>
#include <stdlib.h>


#define MAXV 800
#define max 999


typedef struct
{
    int edges[MAXV][MAXV];                               //邻接矩阵,可看做边表
    int n;                                               //图中当前的顶点数和边数
}MGraph;



void Floyd(MGraph g)
{
    printf("%d\n", 0);
    int A[MAXV][MAXV];
    printf("%d\n", 1);
    int path[MAXV][MAXV];
    printf("%d\n", 2);
    int i,j,k;
    //printf("%d\n", 1);
    int n=g.n;
    
    for(i=0;i<n;i++)
        {
            for(j=0;j<n;j++)
            {
                A[i][j]=g.edges[i][j];
                path[i][j]=-1;
            }
        }
        for(k=0;k<n;k++)
        {
            for(i=0;i<n;i++){
                for(j=0;j<n;j++){
                    if(A[i][j]>(A[i][k]+A[k][j]))
                    {
                        A[i][j]=A[i][k]+A[k][j];
                        path[i][j]=k;
                    }
                    if(i == j){
                        A[i][j] = 0;
                    }

                }
                
            }
            
           
        }
    /*
    for(i=0;i<n;i++){
        for(j=0;j<n;j++){
            if(A[i][j] == 999)
            {
                printf("%s ", "max");
            }
            else
            {
                printf("%d ", A[i][j]);
            }
        }
        printf("\n");
    }
    printf("/////////////////////////////\n");
    for(i=0;i<n;i++){
        for(j=0;j<n;j++){
            
            printf("%d ", path[i][j]);
        }
        printf("\n");
    }
*/
}

int main(){
    MGraph graph;
    malloc(MAXV*MAXV*sizeof(int));
    
    FILE *fp;
    
    printf("Begin reading the file...\n");
    
    fp = fopen("/Users/yousumijie/Desktop/graph.txt","r");
    
    fscanf(fp, "%d", &graph.n);
    
    for(int i = 0; i<graph.n; i++){
        for(int j = 0; j<graph.n; j++){
            graph.edges[i][j]= max;
        }
    }
   
    for(int i = 0; i<graph.n; i++){
        for(int j = 0; j<graph.n; j++){
            
            fscanf(fp, "%d ",&graph.edges[i][j]);
            
        }
    }

    
   /* for(int i = 0; i<5; i++){
            fscanf(fp, "%d %d %d", &nodestart, &nodeend, &nodeWeight);
            graph.edges[nodestart][nodeend] = nodeWeight;
    }
    */
    
    if(!fp)
        fclose(fp);
    printf("Read file complete.\n");
    printf("the number of node is %d.\n", graph.n);
   
    for(int i = 0; i<graph.n; i++){
        for(int j = 0; j<graph.n; j++){
            
                printf("%d ", graph.edges[i][j]);
            
        }
        printf("\n");
    }

    printf("end\n");
    
    double start, stop, lapse;
    start = clock();
    Floyd(graph);
    stop = clock();
    lapse = stop - start;
    printf("time: %fs\n", lapse/CLOCKS_PER_SEC);
    
    return 0;
    
}
