/*
 *   Hyperquicksort
 *
 *   Written by Michael J. Quinn
 * 
 *   Last modified: 30 July 2003
 *    
 *   This program is used to find the answer to Exercise 14-3a.
 */

#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

#define BLOCK_LOW(id,p,n)  ((id)*(n)/(p))
#define BLOCK_HIGH(id,p,n) (BLOCK_LOW((id)+1,p,n)-1)
#define BLOCK_SIZE(id,p,n) (BLOCK_HIGH(id,p,n)-BLOCK_LOW(id,p,n)+1)

unsigned short xi[3];

/* Quicksort-related functions from Baase and van Gelder */

int extendLargeRegion (float *e, float pivot, int lowVac, int high)
{
   int highVac, curr;

   highVac = lowVac;
   curr = high;
   while (curr > lowVac) {
      if (e[curr] < pivot) {
         e[lowVac] = e[curr];
         highVac = curr;
         break;
      }
      curr--;
   }
   return highVac;
}

int extendSmallRegion (float *e, float pivot, int low, int highVac)
{
   int lowVac, curr;
   lowVac = highVac;
   curr = low;
   while (curr < highVac) {
      if (e[curr] >= pivot) {
         e[highVac] = e[curr];
         lowVac = curr;
         break;
      }
      curr++;
   }
   return lowVac;
}

int partition (float *e, float pivot, int first, int last)
{
   int low, high;
   int highVac, lowVac;

   low = first;
   high = last;
   while (low < high) {
      highVac = extendLargeRegion(e, pivot, low, high);
      lowVac = extendSmallRegion(e, pivot, low+1, highVac);
      low = lowVac;
      high = highVac - 1;
   }
   return low;
}

void quicksort (float *e, int first, int last)
{
   float pivot;
   int splitPoint;

   if (first < last) {
      pivot = e[first];
      splitPoint = partition (e, pivot, first, last);
      e[splitPoint] = pivot;
      quicksort (e, first, splitPoint-1);
      quicksort (e, splitPoint+1, last);
   }
}

void print_array (float *a, int n) {
   int i;

   for (i = 0; i < n; i++)
      printf ("%6.3f\n", a[i]);
   printf ("\n");
}

int find_median (float *a, int high, float median) {
   int i;
   i = 0;
   while ((i < high) && (a[i] <= median)) i++;
   return i;
}

int main (int argc, char *argv[])
{
   float *a;
   int els_received;
   int global_high;
   int high;
   int i, j, k, l;
   int id;
   int it;
   int mask;
   float median;
   int my_median;
   int n;
   int p;
   int partner;
   int plenty;
   MPI_Status s;
   int sent_els;
   int share;
   int size;
   int total;
   int zzz;
   int global_total;

   MPI_Init (&argc, &argv);
   MPI_Comm_size (MPI_COMM_WORLD, &p);
   MPI_Comm_rank (MPI_COMM_WORLD, &id);

   if (argc != 2) {
      if (!id) printf ("Command line: %s <n>\n", argv[0]);
      exit (-1);
   }
   n = atoi(argv[1]);
/*
   printf ("Process %d says n = %d\n", id, n);
*/

   if (p == 1) plenty = n;
   else plenty = (3 * n) / (2 * p);

   a = malloc (plenty * sizeof(float));
   if (a == NULL) {
      printf ("malloc failed for process %d\n", id);
      MPI_Abort(MPI_COMM_WORLD, 1);
   }

   share = BLOCK_SIZE(id,p,n);
   MPI_Reduce (&share, &total, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
   /*
   if (!id) {
      printf ("There are %d unsorted elements\n", total);
   }
   */
   xi[0] = xi[1] = xi[2] = id * id + 13;

   global_total = 0;
   for (zzz = 0; zzz < 10; zzz++) {
   for (i = 0; i < share; i++) a[i] = erand48(xi);

   quicksort (a, 0, share-1);

   i = p;
   it = 0;
   while (i > 1) {
      i /= 2;
      it++;
   }

/*
   printf ("Process %d sez we're doing %d iterations\n", p, it);
   fflush (stdout);
*/

   mask = p-1;
   size = p;
   high = share-1;
   for (i = 0; i < it; i++) {
/*
      printf ("Process %d: Iteration %d, Mask %d, Size %d\n", 
         id, i, mask, size);
      fflush (stdout);
*/
      if ((id & mask) == 0) {
/*
         printf ("On iteration %d Process %d is a root\n", it, id);
*/
         median = a[high/2];
         for (j = 1; j < size; j++)
            MPI_Send (&median, 1, MPI_FLOAT, id+j, 9, MPI_COMM_WORLD);
      } else {
/*
         printf ("On iteration %d process %d is a receiver\n", i, id);
*/
         MPI_Recv (&median, 1, MPI_FLOAT, MPI_ANY_SOURCE, 9,
            MPI_COMM_WORLD, &s);
      }
      partner = id ^ (1 << (it-1-i));
/*
      printf ("In iteration %d the partner of %d is %d\n", i, id, partner);
*/
      my_median = find_median (a, high, median);
      if (id < partner) {
         sent_els = high - my_median + 1;
/*
printf ("Process %d will send %d floats to process %d\n", id, sent_els,
partner);
fflush (stdout);
*/
         MPI_Send ((void *) &(a[my_median]), sent_els, MPI_FLOAT, partner,
            0, MPI_COMM_WORLD);
/*
printf ("Process %d done with send and will try to receive\n", id);
fflush (stdout);
*/
         MPI_Recv ((void *) &(a[my_median]), 100000000, MPI_FLOAT, partner,
            0, MPI_COMM_WORLD, &s);
         MPI_Get_elements (&s, MPI_FLOAT, &els_received);
/*
printf ("Process %d received %d float from process %d\n", id, els_received,
partner);
*/
         high = my_median - 1 + els_received;
/*
printf ("Process %d will sort\n", id);
*/
         quicksort (a, 0, high);
      } else {
         sent_els = my_median;
/*
printf ("Process %d will send %d floats to process %d\n", id, sent_els,
partner);
*/
         MPI_Send (&a[0], sent_els, MPI_FLOAT, partner, 0, MPI_COMM_WORLD);
         for (k = 0, l = my_median; l <= high;)
            a[k++] = a[l++];
         MPI_Recv (&a[k], 100000000, MPI_FLOAT, partner, 0,
            MPI_COMM_WORLD, &s);
         MPI_Get_elements (&s, MPI_FLOAT, &els_received);
/*
printf ("Process %d received %d floats from process %d\n", id, els_received,
partner);
*/
         high = k + els_received - 1;
/*
printf ("Process %d will sort\n", id);
*/
         quicksort (a, 0, high);
      }
      size = size / 2;
      mask = mask ^ (1 << (it-1-i));
   }
/*
printf ("Process %d has %d elements\n", id, high);
*/
   MPI_Reduce (&high, &total, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
   /*
   if (!id) {
      printf ("There are %d sorted elements\n", total+p);
   }
   */
   MPI_Reduce (&high, &global_high, 1, MPI_INT, MPI_MAX, 0, MPI_COMM_WORLD);
   global_total += global_high;
   }
   global_high = global_total / 10;
   if (!id) {
      printf ("Largest partition has size %d", global_high+1);
      printf ("%6.3f\n", (float) (global_high+1) /
                         (float) BLOCK_SIZE(p-1,p,n));
   }
   MPI_Finalize();
   return 0;
}
