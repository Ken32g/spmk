function spmk_imcal2(P1,P2, format, outputfile)
    v1= spm_vol(P1);    i1 = spm_read_vols(v1);
    v2= spm_vol(P2);    i2 = spm_read_vols(v2);
    eval(format);
    v3 =v1;
    v3.fname = [outputfile, '.nii'];
    spm_write_vol(v3, i1);
    
end