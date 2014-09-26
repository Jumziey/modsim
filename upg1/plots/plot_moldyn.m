clear all
hold off
N = 50;
L = 14.00;
T = 1.00;
alpha = 0.00;
alldt = char({'001' '005' '001' '014' '020'})';

cd ../Langevin/efile

i=0;
for dt = alldt
  clear a;
  i = i+1;
  file = sprintf('lang-00%d_L%.2f_T%.2f_alpha%.2f_dt%s',N,L,T,alpha,dt);
  a = load(file);
  subplot(5,1,i)
  plot(a(:,1),a(:,2));
  title(sprintf('Time Step: %s',dt));
  xlabel('Step Number');
  ylabel('Total Energy');
end

cd ../../plots
