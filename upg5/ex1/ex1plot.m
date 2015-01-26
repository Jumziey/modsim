close all; clear all;


MU = [1 2 18];
i = 1;
solver1	= 'rk2imp';
solver2 = 'bsimp';
interMeth = 'pchip';
interRes = 0.0001;
for mu = MU
	
	s1 = load(sprintf('%s_%d',solver1,mu));;
	s2 = load(sprintf('%s_%d',solver2,mu));
	
	%X and Y vs Time
	figure(1)
	subplot(3,2,i)
	plot(s1(:,1),s1(:,2), 'b')
	hold on
	plot(s1(:,1),s1(:,3), 'g')
	title(sprintf('%s \\mu = %d',solver1,mu));
	subplot(3,2,i+1)
	plot(s2(:,1),s2(:,2), 'b')
	hold on
	plot(s2(:,1),s2(:,3), 'g')
	title(sprintf('%s \\mu = %d',solver2,mu));
	
	%Phase Plot
	figure(2)
	subplot(3,2,i)
	plot(s1(:,2),s1(:,3))
	title(sprintf('%s \\mu = %d',solver1,mu));
	subplot(3,2,i+1)
	plot(s2(:,2),s2(:,3))
	title(sprintf('%s \\mu = %d',solver2,mu));
	
	%Time step plot
	figure(3)
	subplot(3,2,i)
	plot(s1(1:end-1,1),diff(s1(:,1)), 'g.')
	hold on
	plot(s1(1:end-1,1),diff(s1(:,1)))
	title(sprintf('%s \\mu = %d',solver1,mu));
	subplot(3,2,i+1)
	plot(s2(1:end-1,1),diff(s2(:,1)),'g.')
	hold on;
	plot(s2(1:end-1,1),diff(s2(:,1)))
	title(sprintf('%s \\mu = %d',solver2,mu));
	
	%X and Y vs Time - Interpolated
	figure(4)
	subplot(3,2,i)
	s1q1t = (min(s1):interRes:max(s1))';
	s1q1x = interp1(s1(:,1), s1(:,2), s1q1t, interMeth);
	s1q1y = interp1(s1(:,1), s1(:,3), s1q1t, interMeth);
	plot(s1q1t,s1q1x, 'b')
	hold on
	s2q1t = (min(s2):interRes:max(s2))';
	s2q1x = interp1(s2(:,1), s2(:,2), s2q1t, interMeth);
	s2q1y = interp1(s2(:,1), s2(:,3), s2q1t, interMeth);
	plot(s1q1t,s1q1y, 'g')
	title(sprintf('%s \\mu = %d',solver1,mu));
	subplot(3,2,i+1)
	plot(s2q1t,s2q1x, 'b')
	hold on
	plot(s2q1t,s2q1y, 'g')
	title(sprintf('%s \\mu = %d',solver2,mu));
	
	%Phase plot - Interpolated
	figure(5)
	subplot(3,2,i)
	plot(s1q1x,s1q1y)
	title(sprintf('%s \\mu = %d',solver1,mu));
	subplot(3,2,i+1)
	plot(s2q1x,s2q1y)
	title(sprintf('%s \\mu = %d',solver2,mu));
	
	
	i = i+2;
end

%1 2 18


%bsimp_1
%	Number of Jacobian evaluations = 154
%	Number of Function evaluations = 16759
%	Time elapsed: 0.002933 sec
%bsimp_2
%	Number of Jacobian evaluations = 216
%	Number of Function evaluations = 22879
%	Time elapsed: 0.003929 sec
%bsimp_18
%	Number of Jacobian evaluations = 178
%	Number of Function evaluations = 17425
%	Time elapsed: 0.003024 sec

%rk2imp_1
%	Number of Jacobian evaluations = 8444
%	Number of Function evaluations = 76778
%	Time elapsed: 0.027880 sec
%rk2imp_2
%	Number of Jacobian evaluations = 10990
%	Number of Function evaluations = 99246
%	Time elapsed: 0.036355 sec
%rk2imp_18
%	Number of Jacobian evaluations = 7683
%	Number of Function evaluations = 69355
%	Time elapsed: 0.026242 sec

