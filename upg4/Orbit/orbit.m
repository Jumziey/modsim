function dy = orbit(t,y)
dy = zeros(4,1);
my1 = 0.012277471;
my2 = 1-my1;

D1 = ( (y(1)+my1)^2 + y(3)^2 )^(3/2);
D2 = ((y(1)-my2)^2+y(3)^2)^(3/2);

dy(1) = y(2);
dy(2) = y(1)+2*y(4)-my2*(y(1)+my1)/D1 - my1*(y(1)-my2)/D2;
dy(3) = y(4);
dy(4) = y(3) - 2*y(2) - my2*y(3)/D1 - my1*y(3)/D2;
