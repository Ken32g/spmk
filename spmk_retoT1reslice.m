function spmk_retoT1reslice(reg_source, other_img, res_ref, reg_ref, interp)
% registrate reg_source 
matlabbatch ='';
mkdir temp
copyfile(reg_source, './temp')
copyfile(other_img, './temp')
copyfile('T1.nii', './temp')
cd temp
if nargin ==1
    disp('err, at leat 2 inputs')
end
if nargin ==2
    res_ref = other_img;
    reg_ref = 'T1.nii';
    interp = 1;
end
if nargin ==3
    res_ref = other_img;
    interp = 1;
end

matlabbatch{1}.spm.spatial.coreg.write.ref = {res_ref};
matlabbatch{1}.spm.spatial.coreg.write.source = {reg_ref};
matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r_temp_';

matlabbatch{2}.spm.spatial.coreg.estwrite.ref = {[ 'r_temp_',reg_ref]};    
matlabbatch{2}.spm.spatial.coreg.estwrite.source = {reg_source};
matlabbatch{2}.spm.spatial.coreg.estwrite.other = {other_img};
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.interp = interp;
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
spm_jobman('run', matlabbatch);
cd .. 
copyfile(['./temp/r', other_img], './')
rmdir('temp', 's')
end