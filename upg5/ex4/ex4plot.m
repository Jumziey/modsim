clear all
close all

load predpreyEulerData
p = predpreyEulerData;

figure(1)
plot(p(:,1),p(:,2))
hold on
plot(p(:,1),p(:,3), 'r')
legend('Prey','Predators')

xlabel('Time')
ylabel('Population')

figure(2)
plot(p(:,2),p(:,3))
xlabel('Prey population')
ylabel('Predator population')

