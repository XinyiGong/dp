clear all

% noSet = '15';
% files2search = ['*_' noSet '.'];
files2search = ['*.vtk'];

dirName = 'C:\Users\mlatypov\Documents\_Projects\dp\mks\161107_Equi+Inclusions+PyMKS';
vtkDir = [dirName '\vtk\'];
inpDir = [dirName '\inp\'];
% inpDir = [dirName '\_set-' noSet '\'];
files = dir([vtkDir files2search]);

if exist(inpDir,'dir')== 0
    mkdir(inpDir)  
end

files2load = cell(4,1);
files2load{1} = '_27x27x27.mesh';
files2load{2} = '_tensionX-Y-Z.eqn';
files2load{3} = '_dp.mater';
files2load{4} = '_tensionX-Y-Z.load';

%% Generate mesh

fprintf('Generating mesh...\n');
[xyz, ph, dims] = vtk2mesh([vtkDir files(1).name]);  
% xyz = xyz/1.3;
% xyz = round(xyz*10.0)/10.0;
elem = meshgen(xyz,dims,inpDir);  

%% get the right order of phases
voxyz = permn([1:dims(1)-1],3);
voxyz = sortrows(voxyz,[3,2,1]);
[~,order] = sortrows(voxyz,[1,3,2]);

%% Phases
numSamples = numel(files);
for ii = 1:numSamples
    
    % get phase from current vtk file and reorder it
    [~, ph, ~] = vtk2mesh([vtkDir files(ii).name]); 
    ph = ph(order);
    
%     % force two-phase microstructure (for bimodal microstructures)
    if ~isempty(ph(ph>2))
        fprintf('Warning! More than 2 phases detected!')
    end
    
    % write current inp file
    [~,name,~] = fileparts(files(ii).name);
    msg = sprintf('Writing file %d out of %d (%s)\n', ii, numSamples, name);
    fprintf(msg);
    ph2inp([inpDir name '.inp'], ph, elem, files2load)
end