function [sliceX, sliceY, sliceZ] = slice(ms,m,vizFlag)
    % domain size
    dsize = size(ms);
    % dimensions of the domain
    if numel(dsize) == 3  
        dims = dsize;
        ims = ms;
    elseif numel(dsize) == 4  
        dims = dsize(2:4);
        ims = zeros(dims);
        ims(:,:,:) = ms(:,:,:,:);
    else
        fprintf('Error! Wrong dimensions\n')
        return
    end

    mid = zeros(size(dims));
    for ii=1:numel(dims)
        mid(ii) = fix(dims(ii)/2+1);
    end

    sliceX(:,:) = ims(mid(1),:,:)*m;
    sliceY(:,:) = ims(:,mid(2),:)*m;
    sliceZ(:,:) = ims(:,:,mid(3))*m;

    if vizFlag
        figure; 
        subplot(1,3,1); imagesc(sliceX); axis equal; axis off;
        subplot(1,3,2); imagesc(sliceY); axis equal; axis off;
        subplot(1,3,3); imagesc(sliceZ); axis equal; axis off; 
    end
    
end