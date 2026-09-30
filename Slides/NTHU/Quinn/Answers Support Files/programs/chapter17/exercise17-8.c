#include <stdlib.h>
#include <stdio.h>

int main (int argc, char *argv[])
{
   int            count;          /* Points inside unit circle */
   int            i;
   int            local_count;    /* This thread's subtotal */
   int            samples;        /* Points to generate */
   unsigned short xi[3];          /* Random number seed */
   double         x, y;           /* Coordinates of point */

   samples = atoi(argv[1]);
   omp_set_num_threads (atoi(argv[2]));
   count = 0;
#pragma omp parallel private(xi,x,y,local_count)
   {
   local_count = 0;
   xi[0] = 1;
   xi[1] = 1;
   xi[2] = omp_get_thread_num();
#pragma omp for
   for (i = 0; i < samples; i++) {
      x = erand48(xi);
      y = erand48(xi);
      if (x*x + y*y <= 1.0) local_count++;
   }
#pragma omp critical
   count += local_count;
   }
   printf ("Estimate of pi: %7.5f\n", 4.0*count/samples);
}
