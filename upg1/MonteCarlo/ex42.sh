#!/bin/bash
N=200
L=28.00
alpha=0.00
dt=010
deltat=0.01
step=0.67
nblock=5
T=1.00

cd ../MonteCarlo


for T in 0.10 0.40 1.00; do
	./mcar L=28 N=200 T=$T deltat=0.01 step=0.67 read=conf/phases/mcar-0$N\_L$L\_T$T\_alpha$alpha\_dt$dt nblock=5
done
