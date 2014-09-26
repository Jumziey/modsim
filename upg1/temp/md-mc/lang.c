#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "common.h"
////#include "pcorr.h"
#include "vcorr.h"


char *progname;

#define FNAMESIZE 100

// All the values that define the model and the properties
// of the run are stored in a struct variable of type "Par".
typedef struct Par {
  int nblock, nsamp, seed, n;
  Vec L;
  double t;
  int ntherm;
  double deltat;
  double alpha, noise;
  char *readfile;
} Par;


void print_standard_error(char *str, double x, double x2, int nblock)
{
  double s;

  // Fix this (4). Calculate s = standard error.

  printf("%s%g +/- %g\n", str, x, s);
  return;
}


void set_temperature(int n, double temperature, Vec *vel)
{
  int i;
  Vec tot = {0.0, 0.0};

  for (i = 0; i < n; i++) {
    tot.x += vel[i].x = sqrt(3 * temperature) * dran_sign();
    tot.y += vel[i].y = sqrt(3 * temperature) * dran_sign();
  }

  // Avoid center of mass motion
  for (i = 0; i < n; i++) {
    vel[i].x -= tot.x / n;
    vel[i].y -= tot.y / n;
  }
}


void init_pos(int n, Vec *L, Vec *pos)
{
  int i, j;
  int m = ceil(sqrt(n));

  for (i = 0; i < n; i++) {
    int y = i / m;
    int x = i - m * y;

    pos[i].x = x * L->x / m;
    pos[i].y = y * L->y / m;
  }
}



void get_filename(Par *par, char *fname)
{
  char *f = fname;

  f += sprintf(f, "%s-", progname);	// Start with program name
  f += sprintf(f, "%4.4d", par->n);
  f += sprintf(f, "_L%4.2f", par->L.x);
  f += sprintf(f, "_T%4.2f", par->t);
  f += sprintf(f, "_alpha%4.2f", par->alpha);
  f += sprintf(f, "_dt%3.3d", (int) rint(1000.0 * par->deltat));

  if (f - fname >= FNAMESIZE) {
    fprintf(stderr, "Error: too long file name: %s...\n", fname);
    exit(EXIT_FAILURE);
  }
}

FILE *fopen_wfile(char *dir, char *wfile)
{
  char *filename;
  FILE *stream;

  filename = malloc(strlen(dir) + strlen(wfile) + 1);
  strcpy(filename, dir);
  strcat(filename, wfile);
  stream = fopen(filename, "w");
  if (!stream)
    fprintf(stderr, "*** Cannot open %s.\n", filename);

  free(filename);
  return stream;
}


int step(Par *par, Vec *pos, Vec *vel, Vec *force)
{
  forces_from_pos(par->n, &par->L, pos, force);
  if (par->alpha > 0.0)
    langevin_forces(par->n, par->noise, par->alpha, vel, force);
  vel_from_forces(par->n, par->deltat, vel, force);
  pos_from_vel(par->n, par->deltat, &par->L, pos, vel);
  return 0;
}

// Number of values measured (epot, ekin, epot+ekin)
#define NV 3
void run(Par *par)
{
  int i, itherm, nstep, istep, isamp, iblock, st;
  int nsamp = par->nsamp, nblock = par->nblock;
  char wfile[FNAMESIZE];
  Vec *pos, *vel, *force;
  double ekin, epot;
  double v0[NV], v1[NV], v2[NV];
  FILE *estream = NULL;

  // Initialize

  if (par->alpha > 0.0) {
    printf("Seed for random number generator: %d.\n", par->seed);
    init_ran(par->seed);
  }

  pos = malloc(par->n * sizeof(Vec));
  force = malloc(par->n * sizeof(Vec));
  vel = malloc(par->n * sizeof(Vec));

  // Read from file...
  if (par->readfile)
    st = read_conf(par->n, pos, vel, par->readfile);
  else {
    init_pos(par->n, &par->L, pos);
    set_temperature(par->n, par->t, vel);
  }

  // Get file name for writing to.
  get_filename(par, wfile);

  // Open file for writing energy results
  estream = fopen_wfile("efile/", wfile);
  if (!estream) return;

  measure(par->n, &par->L, pos, vel, &epot, &ekin);
  printf("Energy = %g  (%g  %g)\n", epot + ekin, epot, ekin);
  exit(0); // Fix this (2).

// Fix this (3).
  step(par, pos, vel, force);
  printf("rx ry vx vy = %g  %g  %g  %g\n", pos[0].x, pos[0].y, vel[0].x, vel[0].y);
  exit(0);

  // Run and collect values
  printf("\nSimulate %d blocks x %d samples each: ", par->nblock, par->nsamp);
  fflush(stdout);

  init_vcorr(par->n, par->deltat, 0.1, 5.0);

  // Initialize for measuring a histogram of particle distances for
  // distances up to 5.0 and bin size 0.02.
  // init_pcorr(par->n, 0.02, 5.0);

  for (i = 0; i < NV; i++) v1[i] = v2[i] = 0.0;

  nstep = rint(1.0 / par->deltat);
  for (iblock = 0; iblock < nblock; iblock++) {

    for (i = 0; i < NV; i++) v0[i] = 0.0;
    for (isamp = 0; isamp < nsamp; isamp++) {
      for (istep = 0; istep < nstep; istep++) {
	step(par, pos, vel, force);
	measure_vcorr(par->n, vel);
      }

      // measure_pcorr(par->n, &par->L, pos);

      measure(par->n, &par->L, pos, vel, &epot, &ekin);
      if (estream) fprintf(estream, "%d %g\n", isamp + nsamp * iblock, epot + ekin);
      v0[0] += epot;
      v0[1] += ekin;
      v0[2] += epot + ekin;
    }
    for (i = 0; i < NV; i++) {
      v0[i] /= nsamp;
      v1[i] += v0[i];
      v2[i] += v0[i] * v0[i];
    }

    printf("%d ", iblock + 1);	fflush(stdout);
  }
  printf("\n");

  if (estream) fclose(estream);

  for (i = 0; i < NV; i++) {
    v1[i] /= nblock;
    v2[i] /= nblock;
  }

  // Write configuration to the named file.
  write_conf(par->n, pos, vel, "conf/", wfile);

  // Write velocity correlation results to files.
  write_vcorr(par->n, wfile);
  // write_pcorr(par->n, wfile);

  // Print out some results

  printf("\n");
  print_standard_error("Potential E:  ", v1[0], v2[0], nblock);
  print_standard_error("Kinetic  E:   ", v1[1], v2[1], nblock);
  print_standard_error("Total energy: ", v1[2], v2[2], nblock);


  // From the virial theorem:  pressure = N * T + Virial / Dimensionality

  free(vel);
  free(pos);
  
}

// The arg string is used to assign values to variables in par.
// The strings look like "N=50", "T=1.5" and so on.
// Return value: 1 for success, 0 for failure.
int read_args(Par *par, char *arg)
{
  int st;
  char *s;

  s = strchr(arg, '=');

  if (!s) {
    fprintf(stderr, "Command '%s' not recognized, expected format: '<name>=<value>'.", arg);
    return 0;
  }

  *s++ = '\0';

  if (!strcmp(arg, "N")) {
    par->n = strtol(s, NULL, 0);
    return 1;
  }

  if (!strcmp(arg, "T")) {
    par->t = strtod(s, NULL);
    return 1;
  }

  if (!strcmp(arg, "deltat")) {
    par->deltat = strtod(s, NULL);
    return 1;
  }

  if (!strcmp(arg, "alpha")) {
    par->alpha = strtod(s, NULL);
    return 1;
  }

  if (!strcmp(arg, "L")) {
    par->L.x = par->L.y = strtod(s, NULL);
    return 1;
  }

  if (!strcmp(arg, "nblock")) {
    par->nblock = strtol(s, NULL, 0);
    return 1;
  }

  if (!strcmp(arg, "ntherm")) {
    par->ntherm = strtol(s, NULL, 0);
    return 1;
  }

  if (!strcmp(arg, "nsamp")) {
    par->nsamp = strtol(s, NULL, 0);
    return 1;
  }

  if (!strcmp(arg, "seed")) {
    par->seed = strtol(s, NULL, 0);
    return 1;
  }

#ifdef MC
  if (!strcmp(arg, "step")) {
    par->step = strtod(s, NULL);
    return 1;
  }
#endif

  if (!strcmp(arg, "read")) {
    par->readfile = s;
    return 1;
  }

  fprintf(stderr, "No such variable name: '%s'.\n", arg);
  return 0;
}


int main(int argc, char *argv[])
{
  int i, iarg;
  Par par;
  char *env;

  par.nblock = 2;
  par.seed = 0;
  par.ntherm = 1000;
  par.nsamp = 100;
  par.deltat = 0.01;
  par.readfile = NULL;
  par.alpha = 0.0;

  // Get the program name from the first argument (number 0).
  progname = strrchr(argv[0], '/');	// Skip the directory part (e.g. if called with "./lang").
  if (progname)				// If '/' was found, progname points to this '/'...
    progname++;				// ...now points to first char after '/'.
  else
    progname = argv[0];			// Use the whole argument as program name.

  if (argc == 1) {
    printf("Usage: %s N=50 L=14.0 T=0.1 alpha=1.0\n", argv[0]);
    printf("Optional arguments (with defaults) deltat=%g nblock=%d nsamp=%d ntherm=%d seed=%d\n",
	   par.deltat, par.nblock, par.nsamp, par.ntherm, par.seed);
    exit(EXIT_SUCCESS);
  }

  // Interpret the commands given in the argument list.
  for (iarg = 1; iarg < argc; iarg++)
    if (!read_args(&par, argv[iarg]))
      exit(EXIT_FAILURE);


  if (par.alpha > 0.0)
    printf("--- Langevin dynamics of a Lennard-Jones gas ---\n");
  else
    printf("--- Molecular dynamics of a Lennard-Jones gas ---\n");

  printf("Gas with %d particles at T = %g, Delta time = %g.\n", par.n, par.t, par.deltat);
  printf("Box with size %5.3f x %5.3f\n", par.L.x, par.L.y);


  //  if (par.alpha > 0.0)
  //    par.noise = sqrt( Fix this (5) );

  run(&par);

  exit(EXIT_SUCCESS);
}

