hold off
clear all
brown = [-0.723747 0.00274924;
          -0.718756  0.00295726;
          -0.713167  0.00265532;
           -0.708611 0.00266017];

alph = 10;
dt = [0.001/alph; 0.002/alph; 0.003/alph; 0.004/alph];
        
errorbar(dt,brown(:,1),brown(:,2))
hold on
errorbar(0,-0.727389,0.0042606)

axis([-0.00002 0.0005 -0.7350 -0.7000])