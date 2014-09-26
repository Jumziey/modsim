% Matlab code for solving the Predator-Prey system
clear, clear global
hold off
global a b c d
% Coefficients for the equations
  a=0.4; %Rabbit growth rate
  b=0.001; %Rabbit death coefficient
  c=0.001; %Fox growth coefficient
  d=0.9; %Fox death rate
  % Variables used as input in the ODE-solver
  Ntot=1000;
  p=0.4;
  RabbitIni=(1-p)*Ntot;
  FoxIni=p*Ntot;
  options = odeset('RelTol',1e-4,'AbsTol',[1e-7 1e-7]);
  % Solve ODE system
  [T,Y] = ode45(@rabbitfox,[0 200],[RabbitIni FoxIni],options);
  % Plot
  figure(1)
  plot(T,Y(:,1),'r')
  hold on
  plot(T,Y(:,2),'--b')
  legend('Rabbits','Foxes')
  title('Predator-Prey model ODE')
  %--- End of code ---
