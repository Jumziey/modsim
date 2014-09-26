#include <stdio.h>
#include <string.h>
#include "common.h"

int read_conf(int n0, Vec *pos, Vec *vel, char *fname)
{
  FILE *stream;
  int i, n, num;

  stream = fopen(fname, "r");
  if (!stream) {
    fprintf(stderr, "Cannot open %s.\n", fname);
    perror(NULL);
    return 0;
  }

  num = fscanf(stream, "%d", &n);
  if (num < 1) {
    fprintf(stderr, "Could not read number of particles from file %s\n", fname);
    perror(NULL);
    return 0;
  }

  if (n != n0) {
    fprintf(stderr, "%d particles in %s; %d particles expected.\n", n, fname, n0);
    fclose(stderr);
    return 0;
  }

  printf("Read from %s with data for %d particles.\n", fname, n);

  for (i = 0; i < n; i++) {
    num = fscanf(stream, "%lf %lf %lf %lf\n", &pos[i].x, &pos[i].y, &vel[i].x, &vel[i].y);
    if (num < 4) {
      fprintf(stderr, "Only %d values for particle %d.\n", num, i);
      fclose(stream);
      return 0;
    }
  }

  return n;
}

#define FNAMESIZE 100
int write_conf(int n, Vec *pos, Vec *vel, char *dir, char *name)
{
  FILE *stream;
  int i;
  char fname[FNAMESIZE];

  if (strlen(dir) + strlen(name) > FNAMESIZE) {
    fprintf(stderr, "Too long file name: %s%s.\n", dir, name);
    return 0;
  }
  strcpy(fname, dir);
  strcat(fname, name);

  stream = fopen(fname, "w");
  if (!stream) {
    fprintf(stderr, "Cannot open %s for write.\n", fname);
    return 0;
  }

  fprintf(stream, "%d\n", n);
  for (i = 0; i < n; i++) {
    if (vel)
      fprintf(stream, "%g  %g  %g  %g\n", pos[i].x, pos[i].y, vel[i].x, vel[i].y);
    else
      fprintf(stream, "%g  %g\n", pos[i].x, pos[i].y);
  }
  fclose(stream);

  printf("Configuration with %d particles written to %s.\n", n, fname);
  return 1;
}
