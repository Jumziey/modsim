// vcorr.h

extern void init_vcorr(int n, double deltat, double tstep0, double maxt0);
extern void measure_vcorr(int n, Vec *vel);
extern void write_vcorr(int n, char *wname);
