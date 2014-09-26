#include "common.h"

#define ICUT6 (1.0 / (CUT * CUT * CUT * CUT * CUT * CUT))

// *** pair_interaction ***
// Lennard-Jones interaction
// Input: distance squared between two particles
// Return value: interaction energy
double pair_interaction(double r2)
{
  double ir2, ir6;

  if (r2 > CUT * CUT)
    return 0.0;

  ir2 = 1.0 / r2;
  ir6 = ir2 * ir2 * ir2;

  return 4 * (ir6 * (ir6 - 1.0) - ICUT6 * (ICUT6 - 1.0));
}


// Input:  r2 = distance squared between two particles.
//         dist = vector with distances
// Output: force = vector with the force
void one_force(Vec *f, double r2, Vec *dist)
{
  double r = sqrt(r2);
  double ir2 = 1.0 / r2;
  double ir6 = ir2 * ir2 * ir2;
  double F;
  
  // can't i bake away 48 24 to 2 and 1?
  F = (1/r)*(48*ir6*ir6-24*ir6);
  f->x = (dist->x/r)*F;
  f->y = (dist->y/r)*F;
}


double one_virial(double r2)
{
  double ir2, ir6;

  if (r2 > CUT * CUT)
    return 0.0;

  ir2 = 1.0 / r2;
  ir6 = ir2 * ir2 * ir2;

  return ir6 * (48.0 * ir6 - 24.0);
}

// Function 'inrange' helps to implement periodic bc:s.
// Input: r, which has to be in the interval [-max, 2 max)
// Return value: r, in the interval [0,max).
double inrange(double r, double max)
{    
  if (r < 0.0)
    r += max;
  else
    if (r > max)
      r -= max;
  return r;
}

// One dimensional distance (to the closest mirror point)
double distance(double L, double r1, double r2)
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
double dist2(Vec *L, Vec *p1, Vec *p2, Vec *dist)
{
  dist->x = distance(L->x, p1->x, p2->x);
  dist->y = distance(L->y, p1->y, p2->y);

  return dist->x * dist->x + dist->y * dist->y;
}

void forces_from_pos(int n, Vec *L, Vec *pos, Vec *force)
{
  int i, j;
  double r2;
  Vec f, dist;

  for (i = 0; i < n; i++)
    force[i].x = force[i].y = 0.0;

  for (i = 0; i < n - 1; i++) {
    for (j = i+1; j < n; j++) {

      r2 = dist2(L, &pos[i], &pos[j], &dist);
      if (r2 < CUT * CUT) {
	one_force(&f, r2, &dist);

	force[i].x += f.x;
	force[i].y += f.y;

	force[j].x -= f.x;
	force[j].y -= f.y;
      }
    }
  }
}

// This function takes care of the Langevin terms:
// -alpha * velocity + noise
void langevin_forces(int n, double noise, double alpha, Vec *vel, Vec *force)
{
  int i;
   
  for(i=0; i<n; i++) {
    force[i].x += -1*alpha*vel[i].x + noise*dran_sign()*sqrt(3);
    force[i].y += -1*alpha*vel[i].y + noise*dran_sign()*sqrt(3);
    //printf("force.x: %.3f\n", force[i].x);
    //printf("force.y: %.3f\n", force[i].y);
  }
  // Fix this (5). Use function dran_sign which returns a value between -1 and 1.
}

void pos_from_monte_carlo(int n,double step, Vec *L, double t, double noise, double alpha, double deltat, Vec* pos, Vec* force)
{
  int i,j;
  Vec spos,dist;
  double Ur,Ui;
  double chProb,Udiff;
  
  for(i=0; i<n; i++) {
    spos.x = pos[i].x + dran_sign()*step;
    spos.y = pos[i].y + dran_sign()*step;
    Ur = Ui = 0.0;
    for(j=0; j<n; j++) {
      Ur += pair_interaction(dist2(L, pos+i, pos+j, &dist));
      Ui += pair_interaction(dist2(L, &spos, pos+j, &dist));
    }
    Udiff = Ui-Ur;
    chProb = fmin(1,exp(-Udiff/t));
    if(dran() < chProb) {
      pos[i].x = spos.x;
      pos[i].y = spos.x;
    }
  }
    
}

void vel_from_forces(int n, double deltat, Vec *vel, Vec *force)
{
  int i;
  for(i=0; i<n; i++) {
    vel[i].x = vel[i].x + force[i].x*deltat;
    vel[i].y = vel[i].y + force[i].y*deltat;
  }
  // Fix this (2).
}

void pos_from_vel(int n, double deltat, Vec *L, Vec *pos, Vec *vel)
{
  int i;

  for (i = 0; i < n; i++) {
    pos[i].x = inrange(pos[i].x + deltat * vel[i].x, L->x);
    pos[i].y = inrange(pos[i].y + deltat * vel[i].y, L->y);
  }
}



// Measure potential energy.
void measure(int n, Vec *L, Vec *pos, double *epot)
{
  int i, j;
  Vec dist;

  *epot = 0.0;
  // Potential energy
  for (i = 0; i < n-1; i++) {
    for (j = i + 1; j < n; j++) {
    	*epot += pair_interaction(dist2(L, pos+i, pos+j, &dist));
    }
  }
  *epot /= n;
  return;
}
