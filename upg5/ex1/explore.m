close all; clear all;

mu1 = 5;
mu2 = 10;

MU = 1:18;
i = 1;
solver1	= 'rk2imp';
solver2 = 'bsimp';
for mu = MU
	
	s1 = load(sprintf('%s_%d',solver1,mu));;
	s2 = load(sprintf('%s_%d',solver2,mu));
	
	subplot(6,6,i)
	plot(s1(:,1),s1(:,2), 'b')
	hold on
	plot(s1(:,1),s1(:,3), 'g')
	title(sprintf('%s \\mu = %d',solver1,mu));
	subplot(6,6,i+1)
	plot(s2(:,1),s2(:,2), 'b')
	hold on
	plot(s2(:,1),s2(:,3), 'g')
	title(sprintf('%s \\mu = %d',solver2,mu));
	suplabel('Time plots');
	i = i+2;
end

%1 2 18
