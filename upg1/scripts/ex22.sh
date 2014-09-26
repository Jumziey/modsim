#!/bin/bash
cd ../Langevin/
for i in 0.01 0.1 1.0;
do
  ./lang L=14 N=50 T=1 deltat=0.01 alpha=$i read=conf/start50 nblock=20
done
