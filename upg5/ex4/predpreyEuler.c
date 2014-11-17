#include <stdio.h>
#include <stdlib.h>


int
main()
{
	double h = 0.1;
	int step = 200;
	int i;
  
	double alpha = 2;
  
	double* t = malloc(sizeof(double)*step);
	double* r = malloc(sizeof(double)*step);
	double* f = malloc(sizeof(double)*step);
	
	r[0] = 0.8;
	f[0] = 0.2;
	t[0] = 0;
	for(i=1; i<step; i++)
	{
		r[i] = r[i-1]+h*(1-f[i-1])*r[i-1];
		f[i] = f[i-1] + h*alpha*(r[i]-1)*f[i-1];
		t[i] = t[i-1]+h;
	}
	
	for(i=0; i<step; i++)
	{
		printf("%.5e %.5e %.5e\n",t[i], r[i], f[i]);
	}
	
	return;
}
