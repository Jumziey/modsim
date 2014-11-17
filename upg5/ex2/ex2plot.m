clear all
close all

c2im60jac =  41711;
c2im60eval = 375400;
c2im60time = 0.232;
matlab2im60time = 1.063997;

c2im360jac = 97065;
c2im360eval = 873586;
c2im360time = 0.588;
matlab2im360time = 1.359101;

c4im60jac =  5451;
c4im60eval = 93818;
c4im60time = 0.059;
matlab4im60time = 182;

c4im360jac = 13627;
c4im360eval = 234080;
c4im360time = 0.151;
matlab4im360time = inf; 


load chemkin2im60;
load chemkin2im360;
load chemkin4im60;
load chemkin4im360;

figure(1)
subplot(2,1,1)
plot3(chemkin2im360(:,2),chemkin2im360(:,3), chemkin2im360(:,4))
title('T = 360');
subplot(2,1,2)
plot3(chemkin2im60(:,2),chemkin2im60(:,3), chemkin2im60(:,4))
title('T = 60, second degree implicit');
suplabel('Phase plots, 2nd degree solver')

figure(2)
subplot(3,1,1)
plotyy(chemkin2im360(:,1),chemkin2im360(:,3), chemkin2im360(:,1), chemkin2im360(:,4))
legend('x3','x4')
xlabel('Time')
ylabel('Value')
title('T = 360');
subplot(3,1,2)
plotyy(chemkin2im360(:,1),chemkin2im360(:,2), chemkin2im360(:,1), chemkin2im360(:,4))
legend('x2','x4')
xlabel('Time')
ylabel('Value')
subplot(3,1,3)
plotyy(chemkin2im360(:,1),chemkin2im360(:,2), chemkin2im360(:,1), chemkin2im360(:,3))
legend('x2','x3')
xlabel('Time')
ylabel('Value')


figure(3)
subplot(2,1,1)
plot3(chemkin4im360(:,2),chemkin4im360(:,3), chemkin4im360(:,4))
title('T = 360');
subplot(2,1,2)
plot3(chemkin4im60(:,2),chemkin4im60(:,3), chemkin4im60(:,4))
title('T = 60, second degree implicit');
suplabel('Phase plots, 4th degree solver')

figure(4)
subplot(3,1,1)
plotyy(chemkin4im360(:,1),chemkin4im360(:,3), chemkin4im360(:,1), chemkin4im360(:,4))
legend('x3','x4')
xlabel('Time')
ylabel('Value')
title('T = 360');
subplot(3,1,2)
plotyy(chemkin4im360(:,1),chemkin4im360(:,2), chemkin4im360(:,1), chemkin4im360(:,4))
legend('x2','x4')
xlabel('Time')
ylabel('Value')
subplot(3,1,3)
plotyy(chemkin4im360(:,1),chemkin4im360(:,2), chemkin4im360(:,1), chemkin4im360(:,3))
legend('x2','x3')
xlabel('Time')
ylabel('Value')


