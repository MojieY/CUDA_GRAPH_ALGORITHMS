//
//  graphGenerater.c
//  fw
//
//  Created by 姚墨杰 on 11/19/14.
//  Copyright (c) 2014 yao. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){
    
    int node = 800;
    FILE *fp;
    
    printf("Begin printing the matrix...\n");
    
    fp = fopen("/Users/yousumijie/Desktop/graph.txt","w");
    
    fprintf(fp, "%d\n",node);
    
    srand((unsigned)time(0));
    for(int i = 0; i<node; i++){
        for(int j = 0; j<node; j++){
            if(i == j){
                fprintf(fp, "%d ", 0);
            }
            else{
            int ran_num=rand() % 6;
                if(ran_num == 0){
                    ran_num = 999;
                }
            fprintf(fp, "%d ", ran_num);
            }
        }
        fprintf(fp, "\n");
    }
    
    fclose(fp);
    printf("Finished.\n");
    return 0;
}