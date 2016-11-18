clear all; clc;
load('tps.mat')
load('calibration_c05.mat') 

prefix = 'chi_2_c05_pc08';
y = chi_2_c05';

outFileName = [prefix '.out'];

numPCs = 8;
minOrder = 0;
maxOrder = 3;
normRule = 'none';
msgFreq = 1000; 
outFreq = 5*msgFreq;

[pc,~,~] = PCAConstruct(tps,numPCs);

x = pc;

power = permn(minOrder:maxOrder,numPCs);

% pv = power(:,1:(end-1));
% ord = power(:,end); 
% ind1 = ord == max(pv,[],2);
ind = ~all(power == 0,2);
% 
% power = power(ind1&ind2,:);
power = power(ind,:);
numCmb = size(power,1);

fprintf('Number of combinations: %d\n', numCmb)

mae   = zeros(numCmb,2);
rSqr  = zeros(numCmb,2);
nCoef = zeros(numCmb,1);

outFile = fopen(outFileName,'wt');
fmt = [repmat('%d, ',1,(numPCs-1)) '%d\n'];
filler = [repmat('-',1,46) '\n'];

kk = 0;
tic 
for ii = 1:numCmb
    model = MultiPolyRegress(x,y,maxOrder,power(ii,:),normRule);
    mae(ii,1)  = model.MAE;
    mae(ii,2)  = model.CVMAE;
    rSqr(ii,1) = model.RSquare;
    rSqr(ii,2) = model.CVRSquare;
    nCoef(ii)  = numel(model.Coefficients);
    if mod(ii,msgFreq)*mod(ii,numCmb) == 0
        fprintf('Done with %d combinations out of %d\n', ii,numCmb); 
        if mod(ii,outFreq)*mod(ii,numCmb) == 0
            irange = (kk+1):ii;
            maeBoth = sqrt(mae(irange,2).^2 + mae(irange,1).^2);

            [minMae,indMinMae]     = min(mae(irange,1));
            [minCvMae,indCvMinMae] = min(mae(irange,2));
            [min2Mae,ind2Mae]      = min(maeBoth);
            [maxRsq,indMaxRsq]     = max(rSqr(irange,1));
            [maxCvRsq,indMaxCvRsq] = max(rSqr(irange,2));

            fprintf(outFile,'***Results for range %d:%d\n', kk,ii);

            fprintf(outFile,['Min   MAE: %.04f at ' fmt],minMae,power(indMinMae,:));
            fprintf(outFile,['Max   Rsq: %.04f at ' fmt],maxRsq,power(indMaxRsq,:));
            fprintf(outFile,filler);            
            fprintf(outFile,['Min CVMAE: %.04f at ' fmt],minCvMae,power(indCvMinMae,:));
            fprintf(outFile,['Max CVRsq: %.04f at ' fmt],maxCvRsq,power(indMaxCvRsq,:));
            fprintf(outFile,filler);
            fprintf(outFile,['Min  MAE2: %.04f at ' fmt],min2Mae,power(ind2Mae,:));          
            fprintf(outFile,['*Latest combination: ' fmt], power(ii,:));
            fprintf(outFile,'\n');
            
            fprintf('Results are written for range %d:%d\n', kk,ii);
            kk = ii;
        end
    end
end
toc

maeBoth = sqrt(mae(:,2).^2 + mae(:,1).^2);

[minMae,indMinMae]     = min(mae(:,1));
[minCvMae,indCvMinMae] = min(mae(:,2));
[min2Mae,ind2Mae]      = min(maeBoth);
[maxRsq,indMaxRsq]     = max(rSqr(:,1));
[maxCvRsq,indMaxCvRsq] = max(rSqr(:,2));

fprintf(outFile,'***Absolute extremes\n');

fprintf(outFile,['Min   MAE: %.04f at ' fmt],minMae,power(indMinMae,:));
fprintf(outFile,['Max   Rsq: %.04f at ' fmt],maxRsq,power(indMaxRsq,:));
fprintf(outFile,filler);            
fprintf(outFile,['Min CVMAE: %.04f at ' fmt],minCvMae,power(indCvMinMae,:));
fprintf(outFile,['Max CVRsq: %.04f at ' fmt],maxCvRsq,power(indMaxCvRsq,:));
fprintf(outFile,filler);
fprintf(outFile,['Min  MAE2: %.04f at ' fmt],min2Mae,power(ind2Mae,:));          
fprintf(outFile,'\n\n');

fclose(outFile);

save([prefix '.mat'],'mae','rSqr','nCoef')
