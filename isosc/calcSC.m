% vol fraction and its errors
volfr = [5.5; 15.98; 23.1; 27.85; 35.8]/100;
frerr = [0.7;  1.44;  0.9;  1.77;  1.6]/100;

% measured YS and its errors
ysexp = [1.06; 1.16; 1.15; 1.26; 1.37];
yserr = [0.09; 0.10; 0.05; 0.06; 0.04];

% strain rate sensitivity
m = 1.0/100;

% allocate arrays
sbarLow = zeros(size(volfr));
sbarLowNeg = zeros(size(volfr));
sbarLowPos = zeros(size(volfr));

sbarHigh = zeros(size(volfr));
sbarHighNeg = zeros(size(volfr));
sbarHighPos = zeros(size(volfr));

% lower bound
s1 = 0.2;  % matrix
s2 = 1.33; % reinforcement

for ii = 1:numel(volfr)
    [~, ~, ~, sbarLow(ii),    ~ ] = isosc( volfr(ii), s1, s2, m  );
    [~, ~, ~, sbarLowNeg(ii), ~ ] = isosc( (volfr(ii)-frerr(ii)), s1, s2, m  );
    [~, ~, ~, sbarLowPos(ii), ~ ] = isosc( (volfr(ii)+frerr(ii)), s1, s2, m  );
end

% upper bound
s1 = 0.275; 
s2 = 2.1; 

for ii = 1:numel(volfr)
    [~, ~, ~, sbarHigh(ii),    ~ ] = isosc( volfr(ii), s1, s2, m  );
    [~, ~, ~, sbarHighNeg(ii), ~ ] = isosc( (volfr(ii)-frerr(ii)), s1, s2, m  );
    [~, ~, ~, sbarHighPos(ii), ~ ] = isosc( (volfr(ii)+frerr(ii)), s1, s2, m  );
end

figure; errorbar(volfr,sbarLow,sbarLow-sbarLowNeg,sbarLowPos-sbarLow,'go');
hold on
errorbar(volfr,sbarHigh,sbarHigh-sbarHighNeg,sbarHighPos-sbarHigh,'ro');
hold on
errorbar(volfr,ysexp,yserr,yserr,'o');
ylim([0,1.6])
