#include <math.h>

int main (int argc, char *argv[])
{
double a[100000];
int i, j;

printf ("Setting number of threads to %d\n", atoi(argv[1]));
omp_set_num_threads(atoi(argv[1]));
for (j = 0; j < 100; j++) {
#pragma omp parallel for schedule(static,2000)
for (i = 0; i < 100000; i++) {
   if (i < 10000) {
      a[i] = (sin(i) + cos(i))*(sin(i) + cos(i));                               
   } else {                                                                     
      a[i] = 0.0;                                                               
   }
}
}
}
