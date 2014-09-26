#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "ran.h"
#include "Vec.h"

#define CUT 4

// In common.c:
extern double pair_interaction(double r2);
extern void one_force(Vec *f, double r2, Vec *dist);
extern double one_virial(double r2);
extern double inrange(double r, double max);
extern double distance(double L, double r1, double r2);
extern double dist2(Vec *L, Vec *p1, Vec *p2, Vec *dist);

extern void langevin_forces(int n, double noise, double alpha, Vec *vel, Vec *force);
extern void forces_from_pos(int n, Vec *L, Vec *pos, Vec *force);
extern void vel_from_forces(int n, double deltat, Vec *vel, Vec *force);
extern void pos_from_vel(int n, double deltat, Vec *L, Vec *pos, Vec *vel);

extern void measure(int n, Vec *L, Vec *pos, double *epot);

void pos_from_monte_carlo(int n,double step, Vec *L, double t, double noise, double alpha, double deltat, Vec* pos, Vec* force);
// In interaction.c:

// In conf.c:
extern int read_conf(int n0, Vec *pos, Vec *vel, char *fname);
extern int write_conf(int n, Vec *pos, Vec *vel, char *dir, char *fname);
