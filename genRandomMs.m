function ms = genRandomMs(num,dims)
    volfr = 0.05:0.05:0.95;
    % get number of voxels
    noPt = prod(dims);
    ms = zeros([num*numel(volfr),dims]);
    for jj = 1:numel(volfr)
        for ii = 1:num
            ph = ones(noPt,1);
            rind = randperm(noPt,ceil(volfr(jj)*noPt));
            ph(rind) = 2;
            ind = (jj-1)*num+ii;
            ms(ind,:,:,:) = reshape(ph,dims);
        end
    end