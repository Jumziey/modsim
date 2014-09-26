function dy = rabbitfox(t,y);
dy = zeros(2,1);
global a b c d

Rsat = 1;
Rgrass = 1500;



% Definition of the ODE
% y(1) = Number of rabbits
% y(2) = Number of foxes
dy(1) = a*(1-y(1)/Rgrass)*y(1) - b/(1+y(1)/Rsat)*y(2)*y(1);
dy(2) = c*y(1)*y(2) - d*y(2);
%--- End of code ---
