main ()
{
   int n, p;
   for (n = 1; n < 20; n++)
      for (p = 2; p <= n; p++)
         if ((((p+1)/2)*((n+p-1)/p)) >= n)
            printf ("n = %d and p = %d\n", n, p);
}
