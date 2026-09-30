int main ()
{
double a[100][100], b[100][100];
int i, j, m, p, q;
double rowterm[100], colterm[100];

p = 40;
q = 40;

omp_set_num_threads(2);

#pragma omp parallel
{
    #pragma omp sections
    {
    #pragma omp section
    for (i = 0; i < m; i++) {
       rowterm[i] = 0.0;
       for (j = 0; j < p; j++)
       rowterm[i] += a[i][2*j] * a[i][2*j+1];
    }
    #pragma omp section
    for (i = 0; i < q; i++) {
       colterm[i] = 0.0;
       for (j = 0; j < p; j++)
          colterm[i] += b[2*j][i] * b[2*j+1][i]; 
    }
    }
}
}
