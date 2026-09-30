#include <math.h>

clog(int p)
{
   int answer;
   int i;
   answer = 0;
   i = 1;
   while (i < p) {
      i *= 2;
      answer++;
   }
   return answer;
}
main ()
{
   float chi;
   float lambda;
   int n;
   int p;
   float time;

   n = 100000000;
   chi = .0000000855;
   lambda = .000250;

   for (p = 1; p <= 16; p++) {
      time = chi * (n * log(log((double)n)))/(2*p)
             + (sqrt((double)n)/log(sqrt((double)n)))*lambda*clog(p);
      printf ("%d) %6.3f\n", p, time);
   }
}
