function spmk_rep_header(ref, target)
%% replace the header
    a = spm_vol(ref);
    b = spm_vol(target);
    c = spm_read_vols(b);
    b.mat =a.mat;
    b.fname = 'output.nii';
    spm_write_vol(b,c);
end