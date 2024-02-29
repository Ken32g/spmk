function spmk_pet_ttest(ttest_path, group1, group2, cov)
%% The t-test for PET images between two groups with the default PET parameters
% ttest_path: the folder for desgin matrix and the output nifti files.
% group1: group1, 1 * n cell.
% group2: group2, 1 * n cell.

%
matlabbatch{1}.spm.stats.factorial_design.dir = {ttest_path};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = group1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = group2;
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
if nargin ==4
    matlabbatch{1}.spm.stats.factorial_design.cov(1).c = cov.agearray;
    matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'age';
    matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;

    matlabbatch{1}.spm.stats.factorial_design.cov(2).c = cov.sexarray;
    matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'sex';
    matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
end
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tmr.rthresh = 0.8;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 3;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_yes.gmscv = 50;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 2;

matlabbatch{2}.spm.stats.fmri_est.spmmat = {[ttest_path,'SPM.mat']};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run',matlabbatch);

% 
% matlabbatch ='';
% matlabbatch{1}.spm.stats.con.spmmat ={[ttest_path,'SPM.mat']};
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'pthc';
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'hcpt';
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights =  [-1 1];
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
% matlabbatch{1}.spm.stats.con.delete = 0;
% spm_jobman('run',matlabbatch);

%
try 
    matlabbatch ='';
    matlabbatch{1}.spm.stats.results.spmmat ={[ttest_path,'SPM.mat']};
    matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = Inf;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
    matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.export{1}.ps = true;
    spm_jobman('run',matlabbatch);
catch 
    disp('can not run spm_result')
end
end