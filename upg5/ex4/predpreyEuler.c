#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int
main()
{
	double hs = 0.1;
	int step = 200;
	int i;
	char str[100];
  
	double alpha = 2;
	
  double* t = malloc(sizeof(double)*step);
	double* r = malloc(sizeof(double)*step);
	double* f = malloc(sizeof(double)*step);
		
  for(j=1;j<200;j++)
  {
  	h = hs*j;
  	sprintf(str,"eulA_h=%.2f",h);
		ofp = fopen(str,"w");
	
		r[0] = 1;
		f[0] = 0.1;
		t[0] = 0;
		for(i=1; i<step; i++)
		{
			r[i] = r[i-1]+h*(1-f[i-1])*r[i-1];
			f[i] = f[i-1] + h*alpha*(r[i]-1)*f[i-1];
			t[i] = t[i-1]+h;
		}
	
		for(i=0; i<step; i++)
		{
			fprintf(ofp,"%.5e %.5e %.5e\n",t[i], r[i], f[i]);
		}
		fclose(ofp);
	}
	
	return;
}
