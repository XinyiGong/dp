function plotms(ms,volfr,numClasses)

    % close all
    % 

    % msEqu = ms_all(1:114,:,:,:);
    % msSph = ms_all(115:228,:,:,:);
    % msDsk = ms_all(229:342,:,:,:);
    % msNdl = ms_all(343:end,:,:,:);
    % 
    % ms = msEqu;
    vfr = volfr;
    % ms = msPy_randMs;
    % numClasses = 7;
    % vfr = 0.05:0.05:0.95;
    numSamples = size(ms,1);

    msize = size(ms);
    dims = msize(2:4);
    mid = zeros(size(dims));
    for ii=1:numel(dims)
        mid(ii) = fix(dims(ii)/2+1);
    end
    numSamplesClass = numSamples/numClasses;
    % vfr = ones(numSamplesClass);
    %% colors

    peakBlue = [0 184 255]/255;
    peakGreen = [0 230 101]/255;
    peakRed = [255 0 69]/255;
    peakGrey = [74 74 74]/255;
    peakOrange = [238 129 38]/255;
    white = [1 1 1];
    cmp = makeColorMap(peakGrey, white);

    %% slices normal to X

    % slicesX = zeros(dims(2),dims(3),1,numSamples);
    % count = 1;
    % for jj = 0:numClasses-1
    %     for ii = 0:(numSamplesClass-1)
    %         ind = ii*numClasses+1+jj;
    %         slicesX(:,:,1,count) = ms(ind,mid(1),:,:)*vfr(ii+1);
    %         count = count + 1;
    %     end
    % end

    slicesX = zeros(dims(2),dims(3),1,numSamples);
    count = 1;
    for ii = 0:(numSamplesClass-1)
        for jj = 0:numClasses-1
            ind = ii*numClasses+1+jj;
            slicesX(:,:,1,count) = ms(ind,mid(1),:,:);
            count = count + 1;
        end
    end

    %% slices normal to Y

    slicesY = zeros(dims(1),dims(3),1,numSamples);
    count = 1;
    for jj = 0:numClasses-1
        for ii = 0:(numSamplesClass-1)
            ind = ii*numClasses+1+jj;
            slicesY(:,:,1,count) = ms(ind,:,mid(2),:)*vfr(count);
            count = count + 1;
        end
    end

    %% slices normal to Z

    slicesZ = zeros(dims(1),dims(2),1,numSamples);
    count = 1;
    for jj = 0:numClasses-1
        for ii = 0:(numSamplesClass-1)
            ind = ii*numClasses+1+jj;
            slicesZ(:,:,1,count) = ms(ind,:,:,mid(3))*vfr(count);
            count = count + 1;
        end
    end

    %% plot

    figure; 
    montage(slicesX,'Size',[numClasses,numSamplesClass])
    colormap(cmp)
    % 
    % figure; 
    % montage(slicesY,'Size',[numClasses,numSamplesClass])
    % colormap(cmp)
    % 
    % figure; 
    % montage(slicesZ,'Size',[numClasses,numSamplesClass])
    % colormap(cmp)

    % numDigits = fix(log10(numSamples))+1;
    % 
    % fmt = ['%0' int2str(numDigits) 'd'];
    % 
    % % slices = reshape(ms(:,:,:,mid(3)),[dims(1),dims(2),1,size(ms,1)]);
    % 
    % vfr = 0.05:0.05:0.95;
    % slices = zeros(dims(1),dims(2),1,190);
    % for jj = 1:190
    %     slices(:,:,1,jj) = ms(jj,:,:,mid(3));
    % end
    % 
    % figure; montage(slices,'Size',[10,19])
    % 
    % % for jj = 0:9
    % %     for ii = 1:19
    % %         slices(:,:,jj+1,ii) = ms(count,:,:,mid(3))*vfr(ii);
    % %         count = count + 1;
    % % %         newms(count,:,:,mid(3))*vfr(ii)
    % %     end
    % %     montage(slices(:,:,jj+1,:),'Size',[1,19])
    % %     export_fig(sprintf('row_%02d',jj+1),'r300')
    % % end
    % for ii = 1:numSamples
    %     
    %     slices = ms
    % %     jj = 0;
    % %     sliceZ = zerom;
    % %     while isequal(sliceZ,zerom) == 1
    % %         sliceZ(:,:) = ms(ii,:,:,mid(3)+jj);
    % %         jj = jj+1;
    % %     end 
    % %     imagesc(sliceZ); 
    % %     axis image;
    % %     set(gca,'visible','off');
    % %     fname = ['sliceZ_' sprintf(fmt,ii)];
    % %     export_fig(fname) 
    % end
    % 

end