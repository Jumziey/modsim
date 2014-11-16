#include <stdio.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv2.h>
     
typedef struct vdp_params{
  double mu; 
  int   count;
  int   jac_count;
} vdp_params;


int vdp (double t, const double y[], double dydt[], void * params){
  // make local variables
  vdp_params    * p  = (vdp_params *)params;
  ++p->count;
  dydt[0]  = y[1];
  dydt[1] = -y[0] - p->mu*y[1]*(y[0]*y[0] - 1);
  return GSL_SUCCESS;
}

int
jac_vdp (double t, const double y[], double *dfdy, 
     double dfdt[], void *params)
{
  vdp_params  * p = (vdp_params *)params;
  double mu   = p->mu; 

  gsl_matrix_view dfdy_mat = gsl_matrix_view_array (dfdy, 2, 2);
  gsl_matrix * m = &dfdy_mat.matrix; 

  ++ p->jac_count; 
  gsl_matrix_set (m, 0, 0, 0.0);
  gsl_matrix_set (m, 0, 1, 1.0);
  gsl_matrix_set (m, 1, 0, -2.0*mu*y[0]*y[1] - 1.0);
  gsl_matrix_set (m, 1, 1, -mu*(y[0]*y[0] - 1.0));
  dfdt[0] = 0.0;
  dfdt[1] = 0.0;
  return GSL_SUCCESS;
}

int
main () {
  // you can use any stepper here
  const gsl_odeiv2_step_type * T = gsl_odeiv2_step_rk4imp;
  gsl_odeiv2_step * s    = gsl_odeiv2_step_alloc (T, 2);
  gsl_odeiv2_control * c = gsl_odeiv2_control_y_new (1e-6, 0.0);
  gsl_odeiv2_evolve * e  = gsl_odeiv2_evolve_alloc (2);
  vdp_params pars = {10, 0, 0};     /* the parameters */
  gsl_odeiv2_system sys = {vdp, jac_vdp, 2, &pars};

  gsl_odeiv2_driver * d = gsl_odeiv2_driver_alloc_y_new(&sys, T, 1e-6, 1e-6, 1e-6 );
  gsl_odeiv2_step_set_driver(s, d);
     
  double t = 0.0, t1 = 100.0;
  double h = 1e-6;
  double y[2] = { 1.0, 0.0 };
  
  while (t < t1)
  {
    int status = gsl_odeiv2_evolve_apply (e, c, s, &sys, &t, t1, &h, y);
    
    if (status != GSL_SUCCESS)
      break;
    
    printf ("%.5e %.5e %.5e\n", t, y[0], y[1]);
  }
  
  gsl_odeiv2_evolve_free (e);
  gsl_odeiv2_control_free (c);
  gsl_odeiv2_step_free (s);
  printf("Number of Jacobian evaluations = %d\n"
         "Number of Function evaluations = %d\n", pars.jac_count,
  pars.count);
  return 0;

}
