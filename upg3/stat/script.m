

function script()
  global n F R;
  n = 10;
  ts = 400; %time steps
  RS = 0.3;
  FS = 0.1;
  FSE = 5;
  FBR = 0.001;
  RBR = 0.01;

  F = rand(n,n)<FS;
  F = F*FSE;
  R = (rand(n,n)<RS)*2; %needs time two for pcolor
  size(F)
  %pcolor(F)
  F
  for i = 2:n-1
      for j= 1:n
        
          if F(i,j) ~= 0
           
            move_up(i,j);
          end
      end
  end
  pause
  %pcolor(F)
  F

  
end

%   for i = 1:n
%     for j = 1:n
%       
%       if F(i,j) ~= 0
%         switch(ceil(rand(1)*4))
%           case 1
%             move_up(F,i,j)
%           case 2
%             %move_down(F,i,j)
%           case 3
%             %move_right(F,i,j)
%           otherwise
%             %move left(F,i,j)
%         end
%       end
%     end
%   end
% end

function move_down(i,j)
  global n F;
  if i == 1 %%Wrap around
    if F(n,j) == 0
      F(n,j) = F(i,j);
      F(i,j) = 0;
    end
  else
    if F(i-1,j) == 0
      F(i-1,j) = F(i,j);
      F(i,j) = 0;
    end
  end 
end

function move_up(i,j)
  global n F;
  if F(i+1,j) == 0
    F(i+1,j) = F(i,j);
    F(i,j) = 0;
  end
end


