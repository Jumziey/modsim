function [t, y, sol] = vdpintrol ()
% usage: vdpintro ()
%
% intro
ee = 1;
vdp = @(t,y) [y(2); ee*(1 - y(1)^2) * y(2) - y(1)];
opts = odeset('Stats', 'on');
[x, y] = ode45(vdp,[0 20],[2; 0]);
% this returns a column major matrix y, and column vector x
% because the initial conditions are a column vector [2; 0];

figure(1);
plot(x, y(:, 1), x, y(:, 2));
title('trajectories');

% phase plot
figure(2);
plot(y(:, 1), y(:, 2));
title('Phase plot');

% compute the step size as for each step
s = diff(x);

% now, do this
sol=ode45(vdp,[0 20],[2; 0], opts);
% sol is a structure with much information.
% sol.x is a row vector
% sol.y is a row major matrix

% simple time plot
figure(3);
plot(sol.x,sol.y(1,:), sol.x, sol.y(2,:));
title('trajectories');

% phase plot
figure(4);
plot(sol.y(1, :), sol.y(2, :));
title('Phase plot');

% Display the stats about the integration: number of steps, successful
% ones, rejected ones, number of function evaluation, etc.
disp(sol.stats);

% compute the step size as for each step
s = diff(sol.x);
% sol contains info that can be used to get continuous output
% that should be better for plotting when using a higher order methods
% because they take large steps and give funny looking trajectories.

% Get 100 equally spaced samples on the time interval
t = linspace(0,20, 400);
% this returns a row vector

% get the corresponding states
yy = deval(sol, t);

% plot the results again
figure(5);
plot(t, yy(1, :), t, yy(2,:));
title('trajectories');
figure(6);
plot(yy(1, :), yy(2, :));
title('deval phase plot');
% this should be smoother
end
