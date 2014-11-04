clear all
close all

%Want time step 0.043 (smallest required by other solvers) wanna go 
dt = 0.235;
time = 20*40;
N = 1:dt:time;
iter = size(N,2);
global alpha
alpha = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = zeros(2,iter);
x = [0.8; 0.1];
X(:,1) = x;
for i=2:iter
	x(1) = x(1)+dt*(1-x(2))*x(1);
	x(2) = x(2)+alpha*dt*(x(1)-1)*x(2);
	X(:,i) = x;
end

figure(1);
subplot(3,1,1)
plot(N,X(1,:))
hold on
plot(N,X(2,:))
xlabel('Time')
ylabel('Population')
legend('Rabbits','Foxes')

subplot(3,1,2)
plot(X(2,:),X(1,:))
xlabel('Foxes')
ylabel('Rabbits')
axis equal

subplot(3,1,3)
H = alpha*X(1,:)+X(2,:)-log(X(1,:).^alpha .* X(2,:));
plot(N,H)
xlabel('Time')
ylabel('Lyapunov Constant')
suptitle('Symplectic Euler A')
disp(sprintf('Lyapunov Drift for Sympletic Euler A: %f',max(H)-min(H))) 


tsmooth = time*10;
t = [0 time];
rs = 0.8;
fs = 0.1;
odes = {@ode45 @ode23s @ode15s};

figure(2);
opts = odeset('Stats','on');
sol = ode45(@rabbitfox, t, [rs;fs],opts);
subplot(3,1,1);

	t = linspace(0,time,tsmooth);
  sol.y = deval(sol,t);

plot(t,sol.y);
title('Rabbit v Foxes');
legend('Rabbits','Foxes');
xlabel('Timestep')
ylabel('Relative quantity')
subplot(3,1,2);
plot(sol.y(1,:),sol.y(2,:))
title('Phase Plot');
xlabel('Rabbits')
ylabel('Foxes')
axis equal

%Lyapunov
subplot(3,1,3)
H = alpha*sol.y(1,:)+sol.y(2,:)-log(sol.y(1,:).^alpha .* sol.y(2,:));
plot(t,H);
title('Lyapunov Function')
xlabel('Timestep')
ylabel('Lyapunov constant')
disp(sprintf('ode45 lyapunov drift: %f',max(H)-min(H)))





