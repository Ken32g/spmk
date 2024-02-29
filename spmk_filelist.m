function filelist = spmk_filelist(direxp, fullpath)
%% Generate the nii file list 
% FORMAT filelist = spmk_filelist(direxp, fullpath)
% direxp   - The dir argin
% fullpath - Fullpath or nopath
if nargin ==1
    fullpath ='nopath';
end

files = dir(direxp);
filelist = cell(length(files),1);
if strcmp(fullpath,'nopath') ==1
    for m = 1:length(files)
        filelist(m,1) = {files(m).name};
    end
elseif strcmp(fullpath,'fullpath') ==1
    for m = 1:length(files)
        filelist(m,1) = {[files(m).folder, '\',files(m).name]};
    end
end
end
