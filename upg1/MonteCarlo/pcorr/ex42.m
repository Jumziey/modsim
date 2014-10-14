clear all
hold off
N = 200;
L = 28.00;
Ts = [0.10 0.40 1.00];
alpha=0.00;
dt = '001';
i=0;

for T = Ts
  clear mcar;
  i = i+1;
  file = sprintf('mcar-0%d_L%.2f_T%.2f_alpha%.2f_dt%s',N,L,T,alpha,dt);
  mcar = load(file);
  subplot(3,1,i)
  bar(mcar(:,1),mcar(:,2));
  title(sprintf('T = %.1f',T));
  xlabel('r');
  ylabel('g(r)');
end
