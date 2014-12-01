#include "Graph.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_LEN 200 /* should be enough for most input files */

int main() {
    
    int node;
    int edge;
    
    FILE *in = fopen("/home/cpe810g1/MojieYao/BFSp/graph4096.txt", "r");
    FILE *out = fopen("/home/cpe810g1/MojieYao/BFSp/bfscpu/CPUresult.txt, "w");
    
    fscanf(in, "%d", &node);
    fscanf(in, "%d", &edge);
    
    GraphRef G = newGraph(node);
    ListRef L = newList();
    int s, d = 0;
    int total, num;
    int weight;
    
    int *A;
    A = (int*)malloc(sizeof(int)*node);
    
    for(int i = 0 ;i<node; i++){
        fscanf(in, "%d %d", &total, &num);
        A[i] = num;
        
    }
    
    /* Filling the graph */
    for(int s = 1; s<=node; s++){
        for(int i = 0 ;i<A[s]; i++){
            fscanf(in, "%d %d", &d, &weight);
            addEdge(G, s, d+1);
        }
        
    }
    
    printGraph(out, G);
    
    /* Finding Paths */
    
    s = 1;
    
    double start, end, lapse;
    start = clock();
    for(d = 1; d<=node; d++){
        //fprintf(out, "\n");
        
        BFS(G, s);
        
        int dist = getDist(G, d);
        
        if (dist != INF) {
            fprintf(out, "%d) cost: %d\n", d-1, dist);
            //fprintf(out, "A shortest %d-%d path is: ", s, d);
            //getPath(L, G, d);
            // printList(out, L);
        } else {
            fprintf(out, "The distance from %d to %d is infinity\n", s, d);
            fprintf(out, "No %d-%d path exists", s, d);
        }
        
        //fprintf(out, "\n");
        makeEmpty(L);
        
    }
    
    end = clock();
    lapse = (end-start)/CLOCKS_PER_SEC;
    printf("time: %f\n", lapse);
    
    fclose(in);
    fclose(out);
    freeGraph(&G);
    freeList(&L);
    
    return 0;
}