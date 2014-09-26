function [F Fm] = move_left(F,Fm,i,j)
  global n;
  if Fm(i,j) == 0
    if j == 1 %%Wrap around
     if (F(i,n) == 0)
       F(i,n) = F(i,j);
       Fm(i,n) = 1;
       F(i,j) = 0;
     end
    else if (F(i,j-1) == 0)
        F(i,j-1) = F(i,j);
        Fm(i,j-1) = 1;
        F(i,j) = 0;
      end
    end 
  end
end
