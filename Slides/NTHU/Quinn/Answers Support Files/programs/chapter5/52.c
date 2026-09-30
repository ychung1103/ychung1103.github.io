scheme1 (int n, int p)
{
   int i, r;
   r = n % p;
   printf ("Scheme 1 for n = %d and p = %d: (", n, p);
   for (i = 0; i < r; i++)
      printf ("%d ", (n + p-1)/p);
   for (i = r; i < p; i++)
      printf ("%d ", n/p);
   printf (")\n");
}

scheme2 (int n, int p)
{
   int i;
   printf ("Scheme 2 for n = %d and p = %d: (", n, p);
   for (i = 0; i < p; i++)
      printf ("%d ", (i+1)*n/p-i*n/p);
   printf (")\n");
}

main ()
{
   scheme1 (15, 4);
   scheme2 (15, 4);
   scheme1 (15, 6);
   scheme2 (15, 6);
   scheme1 (16, 5);
   scheme2 (16, 5);
   scheme1 (18, 4);
   scheme2 (18, 4);
   scheme1 (20, 6);
   scheme2 (20, 6);
   scheme1 (23, 7);
   scheme2 (23, 7);
   scheme1 (14, 4);
   scheme2 (14, 4);
}
