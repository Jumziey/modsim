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

./mcar L=$L N=$N T=1.0 deltat=$deltat step=$step nblock=$nblock
OT=$T
for i in 9 8 7 6 5 4 3 2 1; do
	T=0.$i\\0
	./mcar L=28 N=200 T=$T deltat=0.01 step=0.67 read=conf/mcar-0$N\_L$L\_T$OT\_alpha$alpha\_dt$dt nblock=5
	OT=$T
done
