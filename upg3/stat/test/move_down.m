function [F Fm] = move_down(F,Fm,i,j)
  global n;
  if Fm(i,j) == 0
    if i == n %%Wrap around
     if (F(1,j) == 0)
       F(1,j) = F(n,j);
       Fm(1,j) = 1;
       F(n,j) = 0;
     end
    else if (F(i+1,j) == 0)
        F(i+1,j) = F(i,j);
        Fm(i+1,j) = 1;
        F(i,j) = 0;
      end
    end 
  end
end
