#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <cuda.h>

#define MAXV 5
#define max 999


typedef struct
{
    int edges[MAXV][MAXV];                               //邻接矩阵,可看做边表
    int n;                                               //图中当前的顶点数和边数
}MGraph;



__global__ void Floyd(MGraph g)
{
   // printf("%d\n", 0);
    int A[MAXV][MAXV];
   // printf("%d\n", 1);
    int path[MAXV][MAXV];
   // printf("%d\n", 2);
    //int i,j,k;
    //printf("%d\n", 1);
    int n=g.n;

    int i = threadIdx.x;
    int j = threadIdx.y;
    int k = threadIdx.z;

        for(int u = 0; u<n; u++){
            for(int v = 0; v<n; v++){
              A[u][v]=g.edges[u][v];
              path[u][v]=-1;
            }
        }

       // for(k=0;k<n;k++)
       // {
           // for(i=0;i<n;i++){
              //  for(j=0; j<n; j++){
                    if(A[i][j]>(A[i][k]+A[k][j]))
{
                        A[i][j]=A[i][k]+A[k][j];
                        path[i][j]=k;
                    }
                    if(i == j){
                        A[i][j] = 0;
                    }

         //       }

          //  }
            for(int i = 0; i<n; i++){
                for(int j = 0; j<n; j++){
                        g.edges[i][j]=A[i][j];
        }
}

}   /*
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
//}
int main(){
    MGraph graph;
    //malloc(MAXV*MAXV*sizeof(int));

    FILE *fp;

    printf("Begin reading the file...\n");

    fp = fopen("graph.txt","r");

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

    MGraph d_graph;

    cudaMalloc((void**)&d_graph, sizeof(int)*(MAXV*MAXV+1));
    cudaMemcpy(&d_graph, &graph,
                        sizeof(int)*(MAXV*MAXV+1), cudaMemcpyHostToDevice
                        );
    double start, stop, lapse;
    start = clock();
    Floyd<<<1,1,0>>>(d_graph);
    stop = clock();
    lapse = stop - start;
    printf("time: %fs\n", lapse);

    cudaMemcpy(&graph, &d_graph,
                        sizeof(int)*(MAXV*MAXV+1), cudaMemcpyDeviceToHost);

        for(int i=0;i<graph.n;i++){
                for(int j=0;j<graph.n;j++){
                        if(graph.edges[i][j] == 999)
            {
                printf("%s ", "max");
            }
            else
            {
                printf("%d ", graph.edges[i][j]);
            }
        }
        printf("\n");
    }
return 0;

}