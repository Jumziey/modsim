clear all
close all

i= 1;
for h = 0.1:0.1:0.3;
	p = load(sprintf('eulA_h=%1.2f',h))

	figure(i)
	plot(p(:,1),p(:,2))
	hold on
	plot(p(:,1),p(:,3), 'r')
	legend('Prey','Predators')

	xlabel('Time')
	ylabel('Population')

	figure(i+1)
	plot(p(:,2),p(:,3))
	xlabel('Prey population')
	ylabel('Predator population')
	i = i+2
end
