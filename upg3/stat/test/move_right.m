function [F Fm] = move_left(F,Fm,i,j)
  global n;
  if Fm(i,j) == 0
    if j == n %%Wrap around
     if (F(i,1) == 0)
       F(i,1) = F(i,j);
       Fm(i,1) = 1;
       F(i,j) = 0;
     end
    else if (F(i,j+1) == 0)
        F(i,j+1) = F(i,j);
        Fm(i,j+1) = 1;
        F(i,j) = 0;
      end
    end 
  end
end
