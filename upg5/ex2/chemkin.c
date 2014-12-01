#include <stdio.h>
#include <time.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv2.h>
#include <math.h>
     
typedef struct chemkin_params{
  double alpha; 
  double beta;
  double gamma;
  int   count;
  int   jac_count;
} chemkin_params;


int chemkin (double t, const double x[], double dxdt[], void * params){
  // make local variables
  chemkin_params    * p  = (chemkin_params *)params;
  double alpha   = p->alpha; 
  double beta    = p->beta;
  double gamma   = p->gamma;
  
  ++p->count;
  dxdt[0] = alpha*(x[1]+x[0]*(1-beta*x[0]-x[1]));
  dxdt[1] = (1/alpha)*(x[2]-(1+x[0])*x[1]);
  dxdt[2] = gamma*(x[0]-x[2]);
  return GSL_SUCCESS;
}

int
jac_chemkin (double t, const double x[], double *dfdy, 
     double dfdt[], void *params)
{
  chemkin_params  * p = (chemkin_params *)params;
  double alpha   = p->alpha; 
  double beta    = p->beta;
  double gamma   = p->gamma;

  gsl_matrix_view dfdy_mat = gsl_matrix_view_array (dfdy, 3, 3);
  gsl_matrix * m = &dfdy_mat.matrix; 

  ++ p->jac_count; 
  
  gsl_matrix_set(m, 0, 0, alpha-2*alpha*beta*x[0]-(alpha*x[1]));
  gsl_matrix_set(m, 0, 1, alpha-(alpha*x[0]));
  gsl_matrix_set(m, 0, 2, 0);
  
  gsl_matrix_set(m, 1, 0, -x[1]/alpha);
  gsl_matrix_set(m, 1, 1, -x[0]/alpha-1/alpha);
  gsl_matrix_set(m, 1, 2, 1/alpha);
  
  gsl_matrix_set(m, 2, 0, gamma);
  gsl_matrix_set(m, 2, 1 ,0);
  gsl_matrix_set(m, 2, 2, -gamma);
  
  dfdt[0] = 0.0;
  dfdt[1] = 0.0;
  dfdt[2] = 0.0;
  return GSL_SUCCESS;
}

int
main () {
  double alpha = 77.27;
  double beta = 8.375;
  double gamma = 1.161;
  beta = pow(beta,-6);
  
  FILE *ofp;
  char str[80];
	double tot_t;
	clock_t start_t, end_t;
  // you can use any stepper here
  const gsl_odeiv2_step_type * T = gsl_odeiv2_step_rk4imp;
  gsl_odeiv2_step * s    = gsl_odeiv2_step_alloc(T, 3);
  gsl_odeiv2_control * c = gsl_odeiv2_control_y_new(1e-6, 0.0);
  gsl_odeiv2_evolve * e  = gsl_odeiv2_evolve_alloc(3);
  chemkin_params pars = {alpha,beta,gamma,0,0};     /* the parameters */
  gsl_odeiv2_system sys = {chemkin, jac_chemkin, 3, &pars};

  gsl_odeiv2_driver * d = gsl_odeiv2_driver_alloc_y_new(&sys, T, 1e-6, 1e-6, 1e-6 );
  gsl_odeiv2_step_set_driver(s, d);
     
  double t = 0.0, t1 = 360.0;
  double h = 1e-6;
  double x[3] = { 1.0, 2.0, 3.0 };
  
  double t2 = t;
  double interval = 0.01;
  
  sprintf(str,"rk4imp_time=%.f",t1);
	ofp = fopen(str,"w");
		
	start_t = clock();
  while (t < t1)
  {
    int status = gsl_odeiv2_evolve_apply (e, c, s, &sys, &t, t1, &h, x);
    
    if (status != GSL_SUCCESS)
      break;
    if(t > t2+interval) {
      fprintf(ofp,"%.5e %.5e %.5e %.5e\n", t, x[0], x[1], x[2]);
      t2 = t;
    }
  }
  end_t = clock();
	tot_t = (double)(end_t-start_t)/CLOCKS_PER_SEC;
  
  gsl_odeiv2_evolve_free (e);
  gsl_odeiv2_control_free (c);
  gsl_odeiv2_step_free (s);
 	printf("%%%s\n",str);
	printf("%%\tNumber of Jacobian evaluations = %d\n"
     "%%\tNumber of Function evaluations = %d\n"
     "%%\tTime elapsed: %f sec\n", pars.jac_count,pars.count,tot_t);
  return 0;

}
