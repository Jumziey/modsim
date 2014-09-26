clear all
hold off
N = 200;
L = 28.00;
Ts = [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00];
alpha=0.00;
dt = '010';
i=0;
for T = Ts
  clear mcar;
  i = i+1;
  file = sprintf('mcar-0%d_L%.2f_T%.2f_alpha%.2f_dt%s',N,L,T,alpha,dt);
  mcar = load(file);
  subplot(5,2,i)
  plot(mcar(:,1),mcar(:,2), 'o');
  title(sprintf('T = %.1f',T));
  xlabel('Step Number');
  ylabel('Total Energy');
  
end
