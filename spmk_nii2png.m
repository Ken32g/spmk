function spmk_nii2png(P, thickness, outputdir)
%% spmk_nii2png
% convert Nifti file to png image
% FORMAT spmk_nii2png(niidir, thickness, outputdir)
% 
    if nargin == 0, P = '_FLAIR.nii'; thickness=1;end
    if nargin < 3, thickness=1; end
    if nargin < 2, outputdir = P; end
    
    [pthf, namf, ~] = fileparts(P);
    p = spm_read_vols(spm_vol(P));
    g = [];
    l = size(p);
%     p =permute(p, [3 2 1]);
    for i=1:thickness:l(3)
        g=[g,mat2gray(rot90(p(:,:,i)))];
    end
    imwrite(g, [cd,'\',namf,'_', num2str(l(1)),'_', num2str(l(2)),'.png'])
end