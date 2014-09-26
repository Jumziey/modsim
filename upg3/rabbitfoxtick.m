function dy = rabbitfox(t,y);
dy = zeros(2,1);
global a b c d e f g


% Definition of the ODE
% y(1) = Number of rabbits
% y(2) = Number of foxes
dy(1) = a*y(1) - b*y(2)*y(1);
dy(2) = c*y(1)*y(2) - g*y(2)*y(3)/(1+t) - d*y(2);
dy(3) = e*y(3)*y(2) - f*y(3);
%--- End of code ---
