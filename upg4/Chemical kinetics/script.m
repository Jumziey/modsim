clear all
close all

global  alpha
global beta
global gamma
alpha = 77.27;
beta = 8.375*10^(-6);
gamma = 1.161;

t = [0 ;360];
tsmooth = 80000;
x0 = [1 ;2; 3];
chemkin = @(t,x) [alpha*(x(2)+x(1)*(1-beta*x(1)-x(2)));
                (1/alpha)*(x(3)-(1+x(1))*x(2));
                gamma*(x(1)-x(3));];
%chemJac = @(t,x) [alpha*(1-2*beta*x(1)-x(2)) alpha*(1-x(1)) 0;
%                -x(2)/alpha (1/alpha)*(-1-x(1)) 1/alpha;
%                gamma 0 -gamma];
chemJac = @(t,x) [alpha-2*alpha*beta*x(1)-alpha*x(2) alpha-alpha*x(1) 0;
                  -x(2)/alpha -1/alpha-x(1)/alpha 1/alpha;
                  gamma 0 -gamma];
               
odes = {@ode15s @ode23s @ode45};
for i = 1:size(odes,2);
  tic
  figure(i)
  ode = odes{i};
  opts = odeset('Stats','on', 'Jacobian', chemJac);
  sol = ode(chemkin, t, x0,opts);
  tline = linspace(t(1),t(2),tsmooth);
  sol.y = deval(sol,tline);
  plot3(sol.y(1,:),sol.y(2,:),sol.y(3,:));
  title(sprintf('%s Phase Plot',char(odes{i})));
  soln(i).y = sol.y;
  soln(i).x = sol.x;
  soln(i).stats = sol.stats;
  toc
end

j = i;
for i= 1:size(odes,2);
  figure(i+j)

  subplot(3,1,1)
  title(sprintf('%s',char(odes{i})))
  plotyy(tline,soln(i).y(1,:),tline,soln(i).y(2,:));
  title(sprintf('%s',char(odes{i})))
  legend('x1','x2')
  subplot(3,1,2)
  plotyy(tline,soln(i).y(1,:),tline,soln(i).y(3,:));
  legend('x1','x3')
  subplot(3,1,3)
  plotyy(tline,soln(i).y(2,:),tline,soln(i).y(3,:));
  legend('x2','x3')
end
disp('')
k = i+j;
for i = 1:size(odes,2)
  figure(i+k)
  hold on;
  tp = linspace(t(1),t(2),size(soln(i).x,2));
  subplot(3,1,1)
  plotyy(tp(2:end),diff(soln(i).x),tline,soln(i).y(1,:))
  legend('Time step', 'x1')
  subplot(3,1,2)
  plotyy(tp(2:end),diff(soln(i).x),tline,soln(i).y(2,:))
  legend('Time step', 'x2')
  subplot(3,1,3)
  plotyy(tp(2:end),diff(soln(i).x),tline,soln(i).y(3,:))
  legend('Time step', 'x3')
  disp(sprintf('%s - stats',char(odes{i})))
  soln(i).stats
  disp('')
end
