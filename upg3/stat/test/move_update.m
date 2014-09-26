function [F R] = move_update(F,R)
    global n;
    Fm = zeros(n,n);
    Rm = zeros(n,n);
    for i = 1:n
      for j =  1:n
        if F(i,j) ~= 0
          switch ceil(max(rand(1)*4,1))
          case 1
            [F Fm] = move_right(F,Fm,i,j);
          case 2
            [F Fm] = move_left(F,Fm,i,j);
          case 3
            [F Fm] = move_up(F,Fm,i,j);
          otherwise
            [F Fm] = move_down(F,Fm,i,j);
          end
        end
      
        if R(i,j) ~= 0
          switch ceil(max(rand(1)*4,1))
          case 1
            [R Rm] = move_right(R,Rm,i,j);
          case 2
            [R Rm] = move_left(R,Rm,i,j);
          case 3
            [R Rm] = move_up(R,Rm,i,j);
          otherwise
            [R Rm] = move_down(R,Rm,i,j);
          end
        end
      end
    end
