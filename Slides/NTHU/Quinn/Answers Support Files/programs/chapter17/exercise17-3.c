int main (int argc, char *argv[])
{
double area, pi, subarea, x;
int i, n;

printf ("Setting number of threads to %d\n", atoi(argv[1]));
omp_set_num_threads(atoi(argv[1]));
n = 100000;
area = 0.0;
#pragma omp parallel private(x, subarea)
{
subarea = 0.0;
#pragma omp for
for (i = 0; i < n; i++) {
   x = (i+0.5)/n;
   subarea += 4.0/(1.0 + x*x);
}
printf ("Thread %d has subarea %6.5f\n", omp_get_thread_num(), subarea);
#pragma omp critical
area += subarea;
}
pi = area / n;
printf ("pi is %6.5f\n", pi);
}
