#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "Vec.h"
#include "vcorr.h"

static double bsize = 0.02;
static int Rmax = 5;
static int hsize = 250;
static int calls,np;
static double *h;

void init_pcorr(int n)
{
  h = calloc(hsize,sizeof(double));
  np = n;
  calls = 0;
  return;
}

void measure_pcorr(Vec *L,Vec *pos)
{
  int i,j;
  Vec *dist;
  
  calls += 1;
  
  for(i=0; i<np; i++) 
    for(j=0; j<np; j++) 
      dist = sqrt(dist2(L, pos+i, pos+j, dist));
      if(dist<Rmax)
        h[rint(dist/bsize)] += 1/(np*np);
  return;
}


void write_pcorr(char *wname)
{
  int i;
  FILE *stream;
  char *filename;
  double *pcorr;
  
  pcorr = calloc(hsize,sizeof(double));
  
  for(i=0; i<hsize; i++) {
    h[i] /=calls;
    pcorr[i] = h[i]/((i*bsize)*bsize*2*3.14);
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
  for (i = 0; i < maxt; i++)
    fprintf(stream, "%g  %g  %d\n", i*bsize, pcorr[i]);

  fclose(stream);
  printf("Position correlations written to %s\n", filename);
  free(filename);

  free(h);
  calls = 0;
  np = 0;
}
