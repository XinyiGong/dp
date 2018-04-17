vf = [5.5/100 15.98/100 23.1/100 27.85/100 35.8/100];
ys = [1.06 1.16 1.15 1.26 1.37];
ysc = ys.*1000./1.9;
yseh = zeros(1,5);
ysel = zeros(1,5);
hd1 = zeros(1,5);
hd2 = zeros(1,5);
x1 = zeros(1,4);
x2 = zeros(1,4);
scatter(vf, ysc)
hold on
for i = 1:5
    [ ~, x1(1), x2(1), sbar1, ~] = isosc( vf(i), 375, 2280, 0.01 );
    [ ~, x1(2), x2(2), sbar2, ~] = isosc( vf(i), 300, 2280, 0.01 );
    [ ~, x1(3), x2(3), sbar3, ~] = isosc( vf(i), 375, 2280, 0.01 );
    [ ~, x1(4), x2(4), sbar4, ~] = isosc( vf(i), 300, 2280, 0.01 );
    [yseh(i) h]= max([sbar1, sbar2, sbar3, sbar4]);
    [ysel(i) l]= min([sbar1, sbar2, sbar3, sbar4]);
    hd1(i) = x2(h);
    hd2(i) = x2(l);
end
scatter(vf, yseh)
hold on
scatter(vf, ysel)
hold on