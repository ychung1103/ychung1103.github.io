#include <stdlib.h>
#include <math.h>
#include <stdio.h>

int active = 0;
double g2;
unsigned short xi[3];

double box_muller (void)
{
   double g1;
   double v1, v2, r, f;

   if (active) {
      active = 0;
      return g2;
   } else {
      do {
         v1 = 2.0 * erand48(xi) - 1.0;
         v2 = 2.0 * erand48(xi) - 1.0;
         r = v1 * v1 + v2 * v2;
      } while ((r <= 0.0) || (r >= 1.0));
      f = sqrt(-2.0 * log(r)/r);
      g2 = f * v2;
      active = 1;
      return f * v1;
   }
}

int main ()
{
   int i, j;
   int index;
   double r;
   int hist[40];
   for (i = 0; i < 40; i++) hist[i] = 0;
   xi[0] = 0;
   xi[1] = 1;
   xi[2] = 2;
   for (i = 0; i < 10000; i++) {
       r = box_muller();
      printf ("%6.3f\n", r);
      if (r >= 2.0) r = 1.99;
      if (r <= -2.0) r = -1.99;
      index = (int)(((r + 2.0))/0.1);
      hist[index]++;
   }
   for (i = 0; i < 40; i++){
      for (j = 0; j < hist[i]/10; j++) printf (".");
      printf ("\n");
   }
}
