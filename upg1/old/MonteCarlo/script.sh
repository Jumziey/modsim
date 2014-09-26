#!/bin/bash
for i in `seq 1 9`;
do
  ./mcar L=14 N=50 T=1 read=conf/start50 alpha=0.01 step=0.$i
done
