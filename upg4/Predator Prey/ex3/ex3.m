clear all
close all

%Want time step 0.043 (smallest required by other solvers) wanna go 
dt = 0.012;
time = 20;
N = 1:dt:time;
iter = size(N,2);
alpha = 8;

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
legend('Prey','Predators')

subplot(3,1,2)
plot(X(2,:),X(1,:))
xlabel('Predators')
ylabel('Prey')
axis equal

subplot(3,1,3)
H = alpha*X(1,:)+X(2,:)-log(X(1,:).^alpha .* X(2,:));
plot(N,H)
xlabel('Time')
ylabel('Lyapunov Constant')
suptitle('Symplectic Euler A')
disp(sprintf('Lyapunov Drift for Sympletic Euler A: %f',max(H)-min(H))) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = zeros(2,iter);
x = [0.8; 0.1];
X(:,1) = x;
for i=2:iter
	x(2) = x(2)+alpha*dt*(x(1)-1)*x(2);
	x(1) = x(1)+dt*(1-x(2))*x(1);
	X(:,i) = x;
end

figure(2);
subplot(3,1,1)
plot(N,X(1,:))
hold on
plot(N,X(2,:))
xlabel('Time')
ylabel('Population')
legend('Prey','Predators')

subplot(3,1,2)
plot(X(2,:),X(1,:))
xlabel('Predators')
ylabel('Prey')
axis equal

subplot(3,1,3)
H = alpha*X(1,:)+X(2,:)-log(X(1,:).^alpha .* X(2,:));
plot(N,H)
xlabel('Time')
ylabel('Lyapunov Constant')
suptitle('Symplectic Euler B')
disp(sprintf('Lyapunov Drift for Sympletic Euler B: %f',max(H)-min(H))) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = zeros(2,iter);
x = [0.8; 0.1];
X(:,1) = x;
for i=2:iter
	x1 = x(1);
	x2 = x(2);
	x(1) = x1+dt*(1-x2)*x1;
	x(2) = x2+alpha*dt*(x1-1)*x2;
	X(:,i) = x;
end

figure(3);
subplot(3,1,1)
plot(N,X(1,:))
hold on
plot(N,X(2,:))
xlabel('Time')
ylabel('Population')
legend('Prey','Predators')

subplot(3,1,2)
plot(X(2,:),X(1,:))
xlabel('Predators')
ylabel('Prey')
axis equal

subplot(3,1,3)
H = alpha*X(1,:)+X(2,:)-log(X(1,:).^alpha .* X(2,:));
plot(N,H)
xlabel('Time')
ylabel('Lyapunov Constant')
suptitle('Explicit Euler')
disp(sprintf('Lyapunov Drift for Explicit Euler: %f',max(H)-min(H))) 

disp('0.235 is the timestep for which the explicit euler A has a lyapounuv constant that drifts less then ode45')

