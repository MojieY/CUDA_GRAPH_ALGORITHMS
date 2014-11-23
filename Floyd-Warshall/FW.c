#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define max 999

int main(){
    
    
    FILE *fp;
    int num;
    printf("Begin reading the file...\n");
    
    fp = fopen("/Users/yousumijie/Desktop/graph.txt","r");
    
    fscanf(fp, "%d", &num);
    
    
    int MAXV = num;
    int **edges;
    edges=malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        edges[i] = malloc(MAXV*sizeof(int));
    
    
    for(int i = 0; i<num; i++){
        for(int j = 0; j<num; j++){
            edges[i][j]= max;
        }
    }
    
    for(int i = 0; i<num; i++){
        for(int j = 0; j<num; j++){
            
            fscanf(fp, "%d ",&edges[i][j]);
            
        }
    }
    
    
    if(!fp)
        fclose(fp);
    
    printf("Read file complete.\n");
    printf("the number of node is %d.\n", num);
    
    for(int i = 0; i<num; i++){
        for(int j = 0; j<num; j++){
            
            printf("%d ", edges[i][j]);
            
        }
        printf("\n");
    }
    
    printf("end\n");
    
    double start, stop, lapse;
    
    
    int **A;
    A = malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        A[i] = malloc(MAXV*sizeof(int));
    
    int **path;
    path = malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        path[i] = malloc(MAXV*sizeof(int));
    
    int i,j,k;
    
    int n = num;
    
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            A[i][j]=edges[i][j];
            path[i][j]=-1;
        }
    }
    
    start = clock();
    
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
    
    stop = clock();
    lapse = stop - start;
    printf("time: %fs\n", lapse/CLOCKS_PER_SEC);
    
    free(edges);
    free(A);
    free(path);
    
    return 0;
    
}
