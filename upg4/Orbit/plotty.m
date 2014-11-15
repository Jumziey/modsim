close all

for i = 1:2
figure(i)
plot(stat(i,:),error(i,:))
xlabel('Evaluations')
ylabel('Error value')
end
