clear all;
hold off;
close all;
global alpha
alpha = 8;

ts = 0;
te = 20;
tsmooth = 200;
t = [0 20];
rs = 0.8;
fs = 0.2;
odes = {@ode45 @ode23s @ode15s};


for i = 1:size(odes,2);
  figure(i);
  ode = odes{i};
  opts = odeset('Stats','on');
  sol = ode(@rabbitfox, t, [rs;fs],opts);
  subplot(3,2,1);
  plot(sol.x,sol.y);
  title('Non Deval - Prey v Predators');
  xlabel('Timestep')
  ylabel('Relative quantity')
  hold on
  plot(sol.x(1:end-1),diff(sol.x), 'r')
  legend('Prey','Predators', 'Timestep size');

	mint(i) = min(diff(sol.x)); %Finding the smallest time step used
	maxt(i) = max(diff(sol.x)); %Finding the largest time step used

  subplot(3,2,2);
  plot(sol.y(1,:),sol.y(2,:))
  title('Non Deval - Phase Plot');
  xlabel('Prey')
  ylabel('Predators')
  axis equal

  t = linspace(ts,te,tsmooth);
  sol.y = deval(sol,t);

  subplot(3,2,3);
  plot(t,sol.y);
  title('Prey v Predators');
  legend('Prey','Predators');
  xlabel('Timestep')
  ylabel('Relative quantity')
  subplot(3,2,4);
  plot(sol.y(1,:),sol.y(2,:))
  title('Phase Plot');
  xlabel('Prey')
  ylabel('Predators')
  axis equal

  %Lyapunov
  subplot(3,2,5)
  H = alpha*sol.y(1,:)+sol.y(2,:)-log(sol.y(1,:).^alpha .* sol.y(2,:));
  plot(t,H);
  title('Lyapunov Function')
  xlabel('Timestep')
  ylabel('Lyapunov constant')
  
	disp(sprintf('%s lyapunov drift: %f',char(odes{i}),max(H)-min(H)))
  subplot(3,2,6)
  im = imread('cat.bmp');
  image(im);
  axis equal
  axis off
  
  suptitle(char(odes{i}))
end

Smallest_timestep = min(mint)
Biggest_timestep = max(maxt)
