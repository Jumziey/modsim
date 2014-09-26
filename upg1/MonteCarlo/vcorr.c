#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "Vec.h"
#include "vcorr.h"

static int maxt = 0, time = 0, itime = 0, iskip;
static double tstep;
static Vec **v;
static double *vcorr;

void init_vcorr(int n, double deltat, double tstep0, double maxt0)
{
  int i;

  iskip = floor(1.00001* tstep0 / deltat);
  tstep = iskip * deltat;	// To take care of possible rounding in floor().
  maxt = rint(maxt0 / tstep);

  v = malloc(n * sizeof(Vec *));
  for (i = 0; i < n; i++)
    v[i] = malloc(maxt * sizeof(Vec));

  vcorr = calloc(maxt, sizeof(double));

  itime = 0;
}

void measure_vcorr(int n, Vec *vel)
{
  int i, timec;		// Cyclic time: 0...maxt-1, 0...maxt-1,...
  int tdiff, t2;
  static int skipcount = 0;

  if (!maxt) return;	// Check for initialization.

  // Only measure every iskip call.
  if (skipcount++ < iskip) return;

  skipcount = 0;

  timec = itime % maxt;

  for (i = 0; i < n; i++) {
    v[i][timec].x = vel[i].x;
    v[i][timec].y = vel[i].y;
  }

  if (itime >= maxt) {	// Enough values to start measure?

    for (tdiff = 0; tdiff < maxt; tdiff++) {
      int t2 = (itime - tdiff) % maxt;
      for (i = 0; i < n; i++)
	vcorr[tdiff] += v[i][timec].x * v[i][t2].x + v[i][timec].y * v[i][t2].y;
    }
  }

  itime++;
  return;
}


void write_vcorr(int n, char *wname)
{
  int i;
  FILE *stream;
  char *filename;

  if (!maxt) return;

  filename = malloc(strlen("vcorr/") + strlen(wname) + 1);
  strcpy(filename, "vcorr/");
  strcat(filename, wname);

  stream = fopen(filename, "w");
  if (stream == 0) {
    fprintf(stderr, "\n*** Cannot write to %s. Exiting...\n", filename);
    exit(1);
  }

  fprintf(stream, "# t vcorr\n");
  for (i = 0; i < maxt; i++)
    fprintf(stream, "%g  %g  %d\n", i * tstep,
	    vcorr[i] / (itime - maxt) / n, itime-maxt);

  fclose(stream);
  printf("Velocity correlations written to %s\n", filename);
  free(filename);

  for (i = 0; i < n; i++)
    free(v[i]);
  free(v);
  maxt = 0;
}
