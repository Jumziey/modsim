clear all
close all
hold off

load predprey7
load predprey3
load predprey27

figure(1)
plot(predprey3(:,1),predprey3(:,2), 'r')
hold on
plot(predprey3(:,1),predprey3(:,3), 'b')
plot(predprey3(:,1),predprey3(:,4), 'g')
ylabel('Population')
xlabel('Time')
title('Predator Prey, \gamma = 3')

figure(2)
plot(predprey7(:,1),predprey7(:,2), 'r')
hold on
plot(predprey7(:,1),predprey7(:,3), 'b')
ylabel('Population')
xlabel('Time')
title('Predator Prey, without grass, \gamma = 7')
figure(3)
plot(predprey7(:,1),predprey7(:,4), 'g')
ylabel('Grass size')
xlabel('Time')
title('Predator Prey, only grass, \gamma = 3')

figure(4)
plot(predprey27(:,1),predprey27(:,2), 'r')
hold on
plot(predprey27(:,1),predprey27(:,3), 'b')
plot(predprey27(:,1),predprey27(:,4), 'g')
ylabel('Population')
xlabel('Time')
title('Predator Prey, Bounded grass, \gamma = 7')
