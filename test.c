#include <stdlib.h>

int main() {
int *p;
for(int i =0 ; i<16*1024*1024;i++) {
    int inc=1024*sizeof(char);
    p=(int*) calloc(1,inc);
    if(!p) break;
    }
}