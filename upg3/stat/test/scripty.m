  clear all
  hold off
  
  global n F Fm;
  n = 50;
  ts = 400; %time steps
  RS = 0.1;
  RE = 2; %Rabbit energy yeild
  FS = 0.01;
  FSE = 8;
  FBR = 0.01;
  RBR = 0.01;

  F = rand(n,n)<FS;
  F = F*FSE;
  R = rand(n,n)<RS;
  
  foxes = zeros(1,ts);
  rabbits = zeros(1,ts);
  timesteps = [1:ts];
  for t = 1:ts
    [F R] = move_update(F,R);
    for i = 1:n
      for j = 1:n
        if F(i,j) ~= 0
          if R(i,j) ~= 0
            F(i,j) = F(i,j)+RE;
            R(i,j) = 0;
          end
          F(i,j) = F(i,j)-1;
        elseif R(i,j) == 0
          if rand(1)<FBR
            F(i,j) = FSE;
          elseif rand(1) < RBR
            R(i,j) = 1;
          end
        end
      end
    end
    %pause(0.0001)
    %imagesc(F)
    foxes(t) = nnz(F);
    rabbits(t) = nnz(R);
  end
  figure(2)
  plot(timesteps, rabbits, 'r')
  hold on
  plot(timesteps, foxes, '--b')
  
       

