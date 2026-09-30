main ()
{
   int n, p;
   for (n = 1; n < 20; n++)
      for (p = 1; p <= n; p++)
         if (((p-1)*((n+p-1)/p)) == n)
            printf ("n = %d and p = %d\n", n, p);
}
