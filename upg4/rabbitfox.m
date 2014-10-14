function dy = rabbitfox(t,y)
dy = zeros(2,1);
global alpha
%wtf is this shit! IM SO COOL! :DDD
%y(1) = Rabbits!
%y(2) = Foxes!
dy(1) = (1-y(2))*y(1);
dy(2) = alpha*(y(1)-1)*y(2);

