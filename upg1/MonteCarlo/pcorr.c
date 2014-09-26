#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "Vec.h"
#include "pcorr.h"
//#include "common.h"

static double bsize = 0.02;
static int Rmax = 5;
static int hsize = 250;
static int calls;
double *h;

// One dimensional distance (to the closest mirror point)
double distance55(double L, double r1, double r2)
{
  double dist = r1 - r2;
  if (fabs(dist) > L / 2) {
    if (dist > 0.0)
      dist -= L;
    else 
      dist += L;
  }
  return dist;
}


// Two-dimensional distance squared.
double dist255(Vec *L, Vec *p1, Vec *p2, Vec *dist)
{
  dist->x = distance55(L->x, p1->x, p2->x);
  dist->y = distance55(L->y, p1->y, p2->y);

  return dist->x * dist->x + dist->y * dist->y;
}

void init_pcorr()
{
  h = calloc(hsize,sizeof(double));
  calls = 0;
  return;
}

void measure_pcorr(int n,Vec *L,Vec *pos)
{
  int i,j;
  Vec dist;
  double d;
  

  calls += 1;
  
  for(i=0; i<n; i++) 
    for(j=0; j<n; j++) {
      if(i!=j) {
        d = dist255(L, pos+i, pos+j, &dist);
        if(d<Rmax) {
          h[(int)nearbyint(d/bsize)] += 1;
        }
      }
    }
        
  return;
}


void write_pcorr(int n,char *wname)
{
  int i;
  FILE *stream;
  char *filename;
  double *pcorr;
  
  pcorr = calloc(hsize,sizeof(double));
  
  for(i=0; i<hsize; i++) {
    //printf("H[%d] = %.6f\n",i,h[i]);
    pcorr[i] = h[i]/i*bsize;
    //printf("pcorr[%d] = %.6f\n",i,pcorr[i]);
  }
    

  filename = malloc(strlen("pcorr/") + strlen(wname) + 1);
  strcpy(filename, "pcorr/");
  strcat(filename, wname);

  stream = fopen(filename, "w");
  if (stream == 0) {
    fprintf(stderr, "\n*** Cannot write to %s. Exiting...\n", filename);
    exit(1);
  }

  fprintf(stream, "# t pcorr\n");
  for (i = 0; i < hsize; i++)
    fprintf(stream, "%.6f  %.6f \n", i*bsize, pcorr[i]);

  fclose(stream);
  printf("Position correlations written to %s\n", filename);
  free(filename);

  free(h);
  calls = 0;
}
