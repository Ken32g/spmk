function spmk_retoT1(source, ref, otherimg, interp)

if nargin ==1
    ref = 'T1.nii';
    otherimg = {''};
    interp = 1;
end
if nargin ==2
    otherimg = {''};
    interp = 1;
end

matlabbatch ='';
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {ref};    
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {source};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = otherimg;
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = interp;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
spm_jobman('run', matlabbatch);
end
%%
