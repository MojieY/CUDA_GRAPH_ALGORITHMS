#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <cuda.h>

#define max 999

__global__ void Floyd(int n, int ** const A, int ** const path)
{

   // int i = blockDim.x * blockIdx.x + threadIdx.x;
   // int j = blockDim.y * blockIdx.y + threadIdx.y;
   // int k = blockDim.z * blockIdx.z + threadIdx.z;

    int i = threadIdx.x;
    int j = threadIdx.y;
    int k = threadIdx.z;
        if (i < n && j < n && k < n){
/*
                int newPath = A[i][k]+A[k][j];
                int oldPath = A[i][j];
                    if(oldPath > newPath)
                    {
                        A[i][j] = newPath;
                        path[i][j]=k;
                    }
                    if(i == j){
                        A[i][j] = 0;
                    }
*/
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

int main(){

    FILE *fp;

    printf("Begin reading the file...\n");

    fp = fopen("graph.txt","r");

    int MAXV;

    fscanf(fp, "%d", &MAXV);

    int **edges;
    edges = (int**)malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        edges[i] = (int*)malloc(MAXV*sizeof(int));

    int **A;
    A = (int**)malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        A[i] = (int*)malloc(MAXV*sizeof(int));

    int **path;
    path = (int**)malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        path[i] = (int*)malloc(MAXV*sizeof(int));

    for(int i = 0; i<MAXV; i++){
        for(int j = 0; j<MAXV; j++){
            edges[i][j]= max;
        }
    }

    for(int i = 0; i< MAXV; i++){
        for(int j = 0; j< MAXV; j++){

            fscanf(fp, "%d ",&edges[i][j]);

        }
    }

    for(int i=0;i<MAXV;i++)
    {
        for(int j=0;j<MAXV;j++)
        {

            A[i][j]=edges[i][j];
            path[i][j]=-1;
        }
    }

    if(!fp)
        fclose(fp);
    printf("Read file complete.\n");
    printf("the number of node is %d.\n", MAXV);

    for(int i = 0; i<MAXV; i++){
        for(int j = 0; j<MAXV; j++){

                printf("%d ", edges[i][j]);

        }
        printf("\n");
    }

    printf("end\n");
    printf("///////////////////////////\n");
    int *d_A;
    int *d_path;
    size_t pitch;
    cudaMallocPitch(&d_A, &pitch, sizeof(int)*MAXV, MAXV);

    cudaMallocPitch(&d_path, &pitch, sizeof(int**)*MAXV, MAXV);
    
    cudaMemcpy(d_A, A,
                        sizeof(int)*(MAXV*MAXV), cudaMemcpyHostToDevice);
    cudaMemcpy(d_path, path,
                        sizeof(int)*(MAXV*MAXV), cudaMemcpyHostToDevice);

    double start, stop, lapse;
    start = clock();
    Floyd<<<1,1,0>>>(MAXV, d_A, d_path);
    stop = clock();
    lapse = stop - start;
    printf("time: %fs\n", lapse);
    printf("///////////////////////////\n");
    cudaMemcpy(A, d_A,
                        sizeof(int)*(MAXV*MAXV), cudaMemcpyDeviceToHost);
    cudaMemcpy(path, d_path,
                        sizeof(int)*(MAXV*MAXV), cudaMemcpyDeviceToHost);
    printf("///////////////////////////\n");
        for(int i=0;i < MAXV;i++){
                for(int j = 0;j < MAXV; j++){
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

    free(edges);
    free(A);
    free(path);
    cudaFree(d_A);
    cudaFree(d_path);

    return 0;

}
