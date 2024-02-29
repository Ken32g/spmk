function spmk_gml(Pl, Ps, SC_thr)
%% Generate gray matter lesion segment 
% FORMAT spmk_gml(lesionBW, catseg, sc_filter)
% Pl        - Whole brain lesion segment nii file 
% Ps        - Tissue probability mapping derived from cat12, Default p0T1.nii.
% SC_thr    - Small cluster filter. Lesions larger than the threshold will
%             be removed

if nargin==2
    SC_thr = 100;
end

if nargin<2
    fprintf('insufficient inputs.\n');
end
    Vl = spm_vol(Pl);
    Yl = spm_read_vols(Vl);
    
    Vs = spm_vol(Ps);
    Ys = spm_read_vols(Vs);
    
    CC = bwconncomp(Yl);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    for j =1:length(numPixels)
        mean_tissue_prob = nanmean(Ys(CC.PixelIdxList{j}));
        
        if numPixels(j)>SC_thr || (mean_tissue_prob < 1.9 || mean_tissue_prob > 2.1)
            Yl(CC.PixelIdxList{j}) = Yl(CC.PixelIdxList{j})*0;
            
        end
        
    end
    Vo = Vl;
    Vo.fname = 'lesion_gm.nii';
    spm_write_vol(Vo,Yl)
end
