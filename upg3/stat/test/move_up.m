function [F Fm] = move_up(F,Fm,i,j)
  global n;
  if Fm(i,j) == 0
    if i == 1 %%Wrap around
     if (F(n,j) == 0)
       F(n,j) = F(1,j);
       Fm(n,j) = 1;
       F(1,j) = 0;
     end
    else if (F(i-1,j) == 0)
        F(i-1,j) = F(i,j);
        Fm(i-1,j) = 1;
        F(i,j) = 0;
      end
    end 
  end
end
