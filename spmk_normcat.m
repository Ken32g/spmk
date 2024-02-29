%%
function spmk_normcat(P,DF)
%
matlabbatch{1}.spm.spatial.normalise.write.subj.def = {DF};
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {P};
% matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
%                                                           78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -120
                                                          78 76 95];                                                      
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';

spm_jobman('run', matlabbatch);

end