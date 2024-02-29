%%
function spmk_norm_tspo(probe)
if nargin==0
    probe = 'tspo'; 
end
cttag = 'CT-T';
if exist([probe ,'_wb.nii'])==0;pet_nii =[probe, '.nii'];else; pet_nii =[probe ,'_wb.nii'];end
if exist([cttag,'.nii'])==0;ct_nii = 'CT.nii';else; ct_nii =[cttag,'.nii'];end

spm_check_registration(ct_nii, pet_nii,'D:\MRI\spm12\toolbox\Clinical\scct.nii');
uiwait;
%% coregister CT and PET to CT template
% Clinical toolbox function
matlabbatch = '';
ct_template = 'D:\MRI\spm12\toolbox\Clinical\scct.nii,1';

matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {ct_template};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {ct_nii};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {pet_nii};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
spm_jobman('run', matlabbatch);

delete(ct_nii);delete(pet_nii);


matlabbatch =''
matlabbatch{1}.spm.spatial.normalise.est.subj.vol = {['r',ct_nii,',1']};
matlabbatch{1}.spm.spatial.normalise.est.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.est.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.est.eoptions.tpm = {'D:\MRI\spm12\toolbox\Clinical\TPM4mm.nii'};
matlabbatch{1}.spm.spatial.normalise.est.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.est.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.est.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.est.eoptions.samp = 3;
matlabbatch{2}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Normalise: Estimate: Deformation (Subj 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','def'));
matlabbatch{2}.spm.spatial.normalise.write.subj.resample = {'rtspo.nii,1'
    ['r',ct_nii,',1']};
matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
    78 76 85];
matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{2}.spm.spatial.normalise.write.woptions.prefix = 'w';

spm_jobman('run', matlabbatch);
%%
delete(['y_r',ct_nii]);

spm_check_registration(['wr',ct_nii],['wr',pet_nii], 'D:\MRI\spm12\toolbox\Clinical\scct.nii');

%% -Mask brain
mask_tspo ={
        ['wr',probe,'.nii']
        'D:\MRI\Clinical\ctbrainmask_shrink.nii'};
    
spmk_imcal(mask_tspo,'i1.*(i2>0)',['mwr',probe]);
%%
spm_smooth(['mwr',probe,'.nii'],['s10_mwr',probe,'.nii'],10);
end