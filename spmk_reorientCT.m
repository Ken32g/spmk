function spmk_reorientCT(f)
t = spm_vol('T1.nii');

a = spm_vol(f);

b= a;
disp(b.mat(3,4))
b.mat(3,4)=-150;
b.mat(3,4)=-150-(-26.9000);
% b.mat =t.mat
b.fname=['r',f];
spm_write_vol(b, spm_read_vols(a));
end
