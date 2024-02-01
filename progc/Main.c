#include "Header.h"

int main(int argc, char *argv[]){
    
    printf("Execution du C...\n");
    
    if(strcmp(argv[1], "-t") == 0){

        Tri_t();
    }
    else if(strcmp(argv[1], "-s") == 0){

        Tri_s();
        
    }
    
    return 0;
}
