f = [5.5/100;15.98/100;23.1/100;27.85/100;35.8/100];
y1 = 3;
y2 = 0.4;
exp = [1.06;1.16;1.15;1.26;1.37];
Y1 = ones(5,1)*y1;
Y2 = ones(5,1)*y2;
upper = f.*Y1 + (1-f).*Y2;
lower = 1./((f./Y1 )+ ((1-f)./Y2));
figure
scatter(f,exp/1.9)
hold on
scatter(f,upper)
hold on 
scatter(f,lower) 
