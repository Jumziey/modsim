load rk2im_10
load rk2im_5
load rk4im_10
load rk4im_5


subplot(2,2,1)
plot(rk2im_10(:,1),rk2im_10(:,2), 'b')
hold on
plot(rk2im_10(:,1),rk2im_10(:,3), 'g')
title('rk2im \mu = 10');
subplot(2,2,2)
plot(rk2im_5(:,1),rk2im_5(:,2), 'b')
hold on
plot(rk2im_5(:,1),rk2im_5(:,3), 'g')
title('rk2im \mu = 5');
subplot(2,2,3)
plot(rk4im_10(:,1),rk4im_10(:,2), 'b')
hold on
plot(rk4im_10(:,1),rk4im_10(:,3), 'g')
title('rk4im \mu = 10');
subplot(2,2,4)
plot(rk4im_5(:,1),rk4im_5(:,2), 'b')
hold on
plot(rk4im_5(:,1),rk4im_5(:,3), 'g')
title('rk4im \mu = 5');

suplabel('Time plots');

figure(2)
subplot(2,2,1)
plot(rk2im_10(:,2),rk2im_10(:,3))
title('rk2im \mu = 10');
subplot(2,2,2)
plot(rk2im_5(:,2),rk2im_5(:,3))
title('rk2im \mu = 5');
subplot(2,2,3)
plot(rk4im_10(:,2),rk4im_10(:,3))
title('rk4im \mu = 10');
subplot(2,2,4)
plot(rk4im_5(:,2),rk4im_5(:,3))
title('rk4im \mu = 5');

suplabel('Phase plots')
