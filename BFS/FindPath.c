#include "Graph.h"
#define MAX_LEN 200 /* should be enough for most input files */

int main() {
    
    int node;
    int edge;
    
    FILE *in = fopen("/Users/yousumijie/Desktop/sample.txt", "r");
    FILE *out = fopen("/Users/yousumijie/Desktop/CPUresult.txt", "w");
    
    fscanf(in, "%d", &node);
    fscanf(in, "%d", &edge);
    
    GraphRef G = newGraph(node);
    ListRef L = newList();
    int s, d;
    
    /* Filling the graph */
    for(int i = 0 ;i<edge; i++){
        fscanf(in, "%d %d", &s, &d);
        addEdge(G, s, d);
    }
    
    printGraph(out, G);
    
    /* Finding Paths */
    
    for(s = 1; s<node; s++){
        for(d = 1; d<node; d++){
                fprintf(out, "\n");
        
        BFS(G, s);
        int dist = getDist(G, d);
        
        if (dist != INF) {
            fprintf(out, "The distance from %d to %d is %d\n", s, d, dist);
            fprintf(out, "A shortest %d-%d path is: ", s, d);
            getPath(L, G, d);
            printList(out, L);
        } else {
            fprintf(out, "The distance from %d to %d is infinity\n", s, d);
            fprintf(out, "No %d-%d path exists", s, d);
        }
        
        fprintf(out, "\n");
        makeEmpty(L);
        }
    }
    
    fclose(in);
    fclose(out);
    freeGraph(&G);
    freeList(&L);
    
    return 0;
}