#!/bin/bash
cd ../Langevin/
for i in 0.001 0.005 0.01 0.014 0.02; do
  ./lang L=14 N=50 T=1 deltat=$i alpha=0 read=conf/start50 nblock=20
done

