clear all
close all
y0(1) = 0.994;
y0(2) = 0;
y0(3) = 0;
y0(4) = -2.0015751063;
x = [0 17.0652166];
xsmooth = 1000;

hold on
odes = {@ode23s @ode45};
for i = 1:size(odes,2);
  figure(i);
  for j = 1:3
    tol = 10^(-(3*j));
    ode = odes{i};
    opts = odeset('Stats','on', 'AbsTol', tol, 'RelTol', tol, 'MaxStep', x(2)/6000, 'InitialStep', x(2)/6000);
    sol = ode(@orbit, x, y0,opts);
    xline = linspace(x(1),x(2),xsmooth);
    sol.y = deval(sol,xline);
    subplot(2,2,j)
    plot(sol.y(1,:),sol.y(3,:))
    axis equal
    error(i,j) = norm(sol.y(:,1)-sol.y(:,end));
    stat{i,j} = sol.stats;
    
    title(sprintf('FIXED STEPS tol = 10^{-%d} - Error: %f',j*3,error))
  end
end

  

stat = [ 6010 6361 17307;
          6000 6016 6103;]
