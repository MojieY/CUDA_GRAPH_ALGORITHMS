//
//  main.c
//  stream
//
//  Created by 姚墨杰 on 11/15/14.
//  Copyright (c) 2014 yao. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define STOCKS_BATCH 1000
#define NUM_STOCKS 1000000
#define DATA_SIZE 86400

#define BLOCK_NUM 32
#define THREAD_NUM 256

float *stockData;
float *d_stockData;
float *d_resultData;
float *resultData;
float *data[STOCKS_BATCH*DATA_SIZE];
size_t datablocksize;

void generateData(float *number, int size){
    for(int i = 0; i<size; i++){
        number[i] = 10.0f*((float) rand())/RAND_MAX - 5.0f;
    }
}

__global__ static void sumOfStock(float *stock, float *result){
    const int tid = threadIdx.x;
    const int bid = blockIdx.x;
    float sum;
    int i;
    
    for(int i = bid * THREAD_NUM + tid; i < DATA_SIZE; i += BLOCK_NUM * THREAD_NUM){
        sum += stock[i];
    }
    result[bid * THREAD_NUM +tid] = sum;
}
int main(){
    
    const int nStream = NUM_STOCKS/STOCKS_BATCH;
    const int streamSize = NUM_STOCKS * (DATA_SIZE/nStream);
    const int streamBytes = streamSize * sizeof(float);
    
    cudaStream_t stream[nStream];
    for(int i = 0; i<nStream; i++){
        cudaStreamCreate(&stream[i]);
    }
    
    datablocksize = DATA_SIZE * STOCKS_BATCH *sizeof(float);
    
    cudaMallocHost((void**)&stockData, datablocksize);
    cudaMalloc(void**)&d_stockData,datablocksize);
    cudaMallocHost((void**)&resultData, datablocksize);
    cudaMalloc(void**)&d_resultData,datablocksize);
    
    /////////////////////////////////////////////////////////////////////
    for(int i = 0; i<nStream; ++i){
        generateData(*data, DATA_SIZE * STOCKS_BATCH);
        stockData = *data;
        cudaMemcpyAsync(&d_stockData, &stockData,
                        streamBytes, cudaMemcpyHostToDevice,
                        stream[i]);
        sumOifStock<<<BLOCK_NUM, THREAD_NUM, 0, stream[i]>>>(d_stockData, d_resultData);
        cudaMemcpyAsync(&resultData, d_resultData,
                        streamBytes, cudaMemcpyDeviceToHost,
                        stream[i]);
    }
    
    ///////////////////////////////////////////////////////////////////////
    
    for(int i = 0; i<nStream; ++i){
        generateData(*data, DATA_SIZE * STOCKS_BATCH);
        stockData = *data;
        cudaMemcpyAsync(&d_stockData, &stockData,
                        streamBytes, cudaMemcpyHostToDevice,
                        stream[i]);
    }
    for(int i = 0; i<nStream; ++i){
        sumOifStock<<<BLOCK_NUM, THREAD_NUM, 0, stream[i]>>>(d_stockData, d_resultData);
    }
    for(int i = 0; i<nStream; ++i){
        cudaMemcpyAsync(&resultData, d_resultData,
                        streamBytes, cudaMemcpyDeviceToHost,
                        stream[i]);
    }
    }