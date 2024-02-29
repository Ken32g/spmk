function result = spmk_rnms(P1, template, mask, fwhm)
%% spmk_rnms for PET images 
% FORMAT spmk_rnms(P1, template, mask, fwhm)
% 
% Run coregistration, normalization, mask and smooth for single subject
% Clinical toolbox is required for clinical_setorigin function
% The function does not use T1 or CT for stuctural registration and normalization but directly align to the SPM FDG template
% 
% Output files: 
% P1           - a char of filenames
% template     - a char of template for coreg, and normalization
% mask         - a char of mask file for skulltripping or ROI segmentation
% fwhm         - array for fwhm of smooth kernal
% 
% Examples:
% spmk_rnms('FDG.nii')
% spmk_rnms('FDG.nii', 'PET.nii','brainmask_mni.nii', [8 8 8])
%%
    % use default template and mask
    if nargin ==1
        template = 'D:\MRI\spm12\toolbox\OldNorm\PET.nii';
        mask = 'D:\MRI\spm12\toolbox\mrtool\template\brainmask_mni.nii';
        fwhm = [10,10,10];
    end

    % reset the origin
    clinical_setorigin(P1, 4)

    % coregistration
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {template};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = {P1};
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 1;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
    
    % normalization
    matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source = {['r',P1]};
    matlabbatch{2}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
    matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample ={['r',P1]};
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.template = {template};
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.weight = '';
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
    matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
    matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.bb = [-90, -126, -72; 90 ,90, 108]; % the chinese project
%     
%     [-78 -112 -50
%         78 76 85];
    matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.vox = [2 2 2];
    matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.interp = 1;
    matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.prefix = 'w';
    
    % mask
    matlabbatch{3}.spm.util.imcalc.input = {
        ['wr',P1];
        [mask]
        };
    matlabbatch{3}.spm.util.imcalc.output = ['mwr',P1];
    matlabbatch{3}.spm.util.imcalc.outdir = {''};
    matlabbatch{3}.spm.util.imcalc.expression = 'i1.*(i2>0.51)';
    matlabbatch{3}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{3}.spm.util.imcalc.options.mask = 0;
    matlabbatch{3}.spm.util.imcalc.options.interp = 1;
    matlabbatch{3}.spm.util.imcalc.options.dtype = 4;
    
    % smooth
    matlabbatch{4}.spm.spatial.smooth.data = {['mwr',P1]};
    matlabbatch{4}.spm.spatial.smooth.fwhm = fwhm;
    matlabbatch{4}.spm.spatial.smooth.dtype = 0;
    matlabbatch{4}.spm.spatial.smooth.im = 0;
    matlabbatch{4}.spm.spatial.smooth.prefix = 's';
    
    spm_jobman('run', matlabbatch);
    result = 1;
end
