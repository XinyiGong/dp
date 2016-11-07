function [ms, tps, volfr] = vtk2tps(dirName, dims, pcity, vizFlag)
    
    % find the mid of the microstructure
    mid = zeros(size(dims));
    for ii=1:numel(dims)
        mid(ii) = fix(dims(ii)/2+1);
    end
    
    % find the files
    files = dir([dirName '*.vtk']);
    numSamples = numel(files);
    
    % allocate arrays and start the loop
    tps = zeros(numSamples, prod(dims));
    ms = zeros([numSamples, dims]);
    for ii = 1:numSamples
        
        % read data from current vtk file
        file = files(ii).name;
        data = readVtk([dirName file]); 
        msg = sprintf('Reading file %d out of %d (%s)\n', ii, numSamples, file);
        fprintf(msg);
        
        % digest phase IDs
        ph = data.Phases - 1; 
        if ~isempty(ph(ph>=2))
            ph(ph>=2) = 1; 
            fprintf('WARNING: ph>2 found, 2-phase composite forced\n');
        end
        if ~isempty(ph(ph<0))
            ph(ph<0) = 0; 
            fprintf('WARNING: ph<0 found, 2-phase composite forced\n');
        end
        ph = reshape(ph(2:end),dims);
        
        if numel(dims) == 3
            ms(ii,:,:,:) = ph;      
        elseif numel(dims) == 2
            ms(ii,:,:) = ph; 
        end
                
%         get two-point stats
        itps = TwoPoint('auto',mid(1),pcity,ph);
        tps(ii,:) = itps(:);
    end
    
    cntr = fix(size(tps,2)/2) + 1;
    volfr = tps(:,cntr);

    % visualize slices of the last sample
    if vizFlag
        
        sliceX(:,:) = itps(mid(1),:,:);
        sliceY(:,:) = itps(:,mid(2),:);
        sliceZ(:,:) = itps(:,:,mid(3));
        figure; 
        subplot(1,3,1); imagesc(sliceX); axis equal; axis off;
        subplot(1,3,2); imagesc(sliceY); axis equal; axis off;
        subplot(1,3,3); imagesc(sliceZ); axis equal; axis off; 
    end

end