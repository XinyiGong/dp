clear
clc
f = [5.5/100; 15.98/100; 23.1/100; 27.85/100; 35.8/100];
cld = [4.07; 1.42; 0.73; 0.53; 0.33];
exp = [1.06; 1.16; 1.15; 1.26; 1.37];

y = exp;
X1 = [ones(length(f),1) f cld.^-0.5];
X2 = [ones(length(f),1) cld.^-0.5 f.*(cld.^-0.5)];
X3 = [ones(length(f),1) cld.^-0.5];
X4 = [ones(length(f),1) f]; 
X5 = [ones(length(f),1) f f.*(cld.^-0.5)];
b1 = regress(y,X1);
b2 = regress(y,X2);
b3 = regress(y,X3);
b4 = regress(y,X4);
b5 = regress(y,X5);
yCalc1 = X1*b1;
yCalc2 = X2*b2;
yCalc3 = X3*b3;
yCalc4 = X4*b4;
yCalc5 = X5*b5;
MAE1 = mae(yCalc1-y)
MAE2 = mae(yCalc2-y)
MAE3 = mae(yCalc3-y)
MAE4 = mae(yCalc4-y)
MAE5 = mae(yCalc5-y)
ae = 0;
for i = 1:5
    ytr = y;
    Xtr = X1;
    yt = ytr(i,:);
    Xt = Xtr(i,:);
    ytr(i,:) = [];
    Xtr(i,:) = [];
    b = regress(ytr,Xtr);
    ae = ae + abs(yt - Xt*b);
end
CVmae1 = ae/5
ae = 0;
for i = 1:5
    ytr = y;
    Xtr = X2;
    yt = ytr(i,:);
    Xt = Xtr(i,:);
    ytr(i,:) = [];
    Xtr(i,:) = [];
    b = regress(ytr,Xtr);
    ae = ae + abs(yt - Xt*b);
end
CVmae2 = ae/5
ae = 0;
for i = 1:5
    ytr = y;
    Xtr = X3;
    yt = ytr(i,:);
    Xt = Xtr(i,:);
    ytr(i,:) = [];
    Xtr(i,:) = [];
    b = regress(ytr,Xtr);
    ae = ae + abs(yt - Xt*b);
end
CVmae3 = ae/5
ae = 0;
for i = 1:5
    ytr = y;
    Xtr = X4;
    yt = ytr(i,:);
    Xt = Xtr(i,:);
    ytr(i,:) = [];
    Xtr(i,:) = [];
    b = regress(ytr,Xtr);
    ae = ae + abs(yt - Xt*b);
end
CVmae4 = ae/5
ae = 0;
for i = 1:5
    ytr = y;
    Xtr = X5;
    yt = ytr(i,:);
    Xt = Xtr(i,:);
    ytr(i,:) = [];
    Xtr(i,:) = [];
    b = regress(ytr,Xtr);
    ae = ae + abs(yt - Xt*b);
end
CVmae5 = ae/5

figure
scatter(y,yCalc2)
hold on
plot(y,y)
xlabel('Experimental Indentation Yield Strength')
ylabel('Predicted Indentation Yield Strength')