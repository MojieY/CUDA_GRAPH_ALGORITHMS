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
      if(i == j)
      {
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
    //get the edges matrix
    int **edges;
    edges = (int**)malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        edges[i] = (int*)malloc(MAXV*sizeof(int));
        
    //create the new matrix A, the shortest distance will be stored here
    int **A;
    A = (int**)malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        A[i] = (int*)malloc(MAXV*sizeof(int));

    //create the path matrix
    int **path;
    path = (int**)malloc(sizeof(int**)*MAXV);
    for (int i = 0; i < MAXV; i++)
        path[i] = (int*)malloc(MAXV*sizeof(int));
    
    //initial the edges matrix to the max
    for(int i = 0; i<MAXV; i++){
        for(int j = 0; j<MAXV; j++){
            edges[i][j]= max;
        }
    }
    //get the value of the edge matrix from the file
    for(int i = 0; i< MAXV; i++){
        for(int j = 0; j< MAXV; j++){

            fscanf(fp, "%d ",&edges[i][j]);

        }
    }
    
    //close the file
    if(!fp)
        fclose(fp);
    printf("Read file complete.\n");
    printf("the number of node is %d.\n", MAXV);
    
    //initial the A and path matrix, A == edges, path == -1
    for(int i=0;i<MAXV;i++)
    {
        for(int j=0;j<MAXV;j++)
        {

            A[i][j]=edges[i][j];
            path[i][j]=-1;
        }
    }
    
    //printing the edge matrix
    for(int i = 0; i<MAXV; i++){
        for(int j = 0; j<MAXV; j++){

                printf("%d ", edges[i][j]);

        }
        printf("\n");
    }

    printf("end\n");
    printf("///////////////////////////\n");
    
    //initial the device matrix
    int *d_A;
    int *d_path;
    size_t pitch;
    
    //malloc the memory for the device
    cudaMallocPitch(&d_A, &pitch, sizeof(int)*MAXV, MAXV);

    cudaMallocPitch(&d_path, &pitch, sizeof(int**)*MAXV, MAXV);
    
    //copy from the host to the device
    cudaMemcpy(d_A, A,
                        sizeof(int)*(MAXV*MAXV), cudaMemcpyHostToDevice);
    cudaMemcpy(d_path, path,
                        sizeof(int)*(MAXV*MAXV), cudaMemcpyHostToDevice);

    //creating the time point
    double start, stop, lapse;
    start = clock();
    
    //call the kernel function
    Floyd<<<1,1,0>>>(MAXV, d_A, d_path);
    stop = clock();
    lapse = stop - start;
    printf("time: %fs\n", lapse);
    printf("///////////////////////////\n");
    
    //copy the data back to the host
    cudaMemcpy(A, d_A,
                        sizeof(int)*(MAXV*MAXV), cudaMemcpyDeviceToHost);
    cudaMemcpy(path, d_path,
                        sizeof(int)*(MAXV*MAXV), cudaMemcpyDeviceToHost);
    printf("///////////////////////////\n");
    
    //printing the matrix A     
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

    //free the memory
    free(edges);
    free(A);
    free(path);
    cudaFree(d_A);
    cudaFree(d_path);
    
    //*FINISHED*//
    return 0;

}
