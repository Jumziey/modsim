% Matlab code for solving the Predator-Prey system
clear, clear global
hold off
global a b c d e f g
% Coefficients for the equations
  a=0.4; %Rabbit growth rate
  b=0.001; %Rabbit death coefficient
  c=0.001; %Fox growth coefficient
  d=0.9; %Fox death rate 
  e =  0.002; %Tick growth rate
  f =  0.4; %Tick Death rate
  g = 0.001 
  % Variables used as input in the ODE-solver
  n = 1;
  for i = 1:n
    e = 0.001*i;
    %c = 0.0001*i
    %d = 0.1*(9+i)
    Ntot=1000;
    p=0.4;
    RabbitIni=(1-p)*Ntot;
    FoxIni=p*Ntot;
    TickIni = FoxIni;
    options = odeset('RelTol',1e-4,'AbsTol',[1e-7 1e-7 1e-7]);
    % Solve ODE system
    [T,Y] = ode45(@rabbitfoxtick,[0 200],[RabbitIni FoxIni TickIni],options);
    % Plot
    subplot(ceil(sqrt(n)),ceil(sqrt(n)), i)
    plot(T,Y(:,1),'r')
    hold on
    plot(T,Y(:,2),'--b')
    plot(T,Y(:,3),'g')
    %legend('Rabbits','Foxes', 'Ticks')
    %title('Predator-Prey model ODE + ticks!')
  %--- End of code ---
end
