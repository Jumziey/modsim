clear all
hold off
N = 50;
L = 14.00;
T = 1.00;
alphas = [0.01 0.1 1.0];
dt = '010'; 


cd ../Langevin/vcorr

i=0;
for alpha = alphas
  clear lang;
  i = i+1;
  file = sprintf('lang-00%d_L%.2f_T%.2f_alpha%.2f_dt%s',N,L,T,alpha,dt);
  lang = load(file);
  subplot(3,1,i)
  plot(lang(:,1),lang(:,2));
  title(sprintf('Alpha = %.2f',alpha));
  xlabel('Time');
  ylabel('Vcorr');
  axis([0 3 -0.5 2.5 ]);
  
end

cd ../../plots

