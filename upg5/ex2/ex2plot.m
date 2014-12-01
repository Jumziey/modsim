clear all
close all


solver1 = 'rk2imp';
solver2 = 'rk4imp';

i=0;
for t = [60 360]
	s1 = load(sprintf('%s_time=%d',solver1,t));
	s2 = load(sprintf('%s_time=%d',solver2,t));
	
	figure(i+1)
	subplot(3,1,1)
	plotyy(s1(:,1),s1(:,2),s1(:,1),s1(:,3))
	legend('x1','x2');
	title(sprintf('%s t = %d',solver1,t));
	subplot(3,1,2)
	plotyy(s1(:,1),s1(:,2),s1(:,1),s1(:,4))
	legend('x1','x3');
	subplot(3,1,3)
	plotyy(s1(:,1),s1(:,3),s1(:,1),s1(:,4))
	legend('x2','x3');
	
	figure(i+2)
	subplot(3,1,1)
	plotyy(s2(:,1),s2(:,2),s2(:,1),s2(:,3))
	legend('x1','x2');
	title(sprintf('%s t = %d',solver2,t));
	subplot(3,1,2)
	plotyy(s2(:,1),s2(:,2),s2(:,1),s2(:,4))
	legend('x1','x3');
	subplot(3,1,3)
	plotyy(s2(:,1),s2(:,3),s2(:,1),s2(:,4))
	legend('x2','x3');
	
	
	figure(i+3)
	subplot(2,1,1)
	plot3(s1(:,2),s1(:,3),s1(:,4))
	title(sprintf('%s t = %d',solver1,t));
	subplot(2,1,2)
	plot3(s2(:,2),s2(:,3),s2(:,4))
	title(sprintf('%s t = %d',solver2,t));
	
	figure(i+4)
	subplot(2,1,1)
	plot(s1(1:end-1,1),diff(s1(:,1)))
	title(sprintf('%s t = %d',solver1,t));
	%axis([0 t -1 1])
	subplot(2,1,2)
	plot(s2(1:end-1,1),diff(s2(:,1)))
	title(sprintf('%s t = %d',solver2,t));
	%axis([0 t -2 2])
	
	i = i+4;
end



%rk4imp_time=60
%	Number of Jacobian evaluations = 5451
%	Number of Function evaluations = 93818
%	Time elapsed: 0.027522 sec
%rk2imp_time=60
%	Number of Jacobian evaluations = 41711
%	Number of Function evaluations = 375400
%	Time elapsed: 0.109494 sec

%rk2imp_time=360
%	Number of Jacobian evaluations = 97065
%	Number of Function evaluations = 873586
%	Time elapsed: 0.284457 sec
%rk4imp_time=360
%	Number of Jacobian evaluations = 13627
%	Number of Function evaluations = 234080
%	Time elapsed: 0.071636 sec


