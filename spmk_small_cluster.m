function Y = spmk_small_cluster(Y, sc_filter, erode_vol)

if nargin ==1
    sc_filter = 50;
    erode_vol = 0;
end
if nargin ==2
    erode_vol = 0;
end

if ischar(Y)
    try
        Vi = spm_vol(Y);
        Yi = spm_read_vols(Vi);
        Yo = spmk_small_cluster(Yi, sc_filter, erode_vol);
        Vo = Vi;
        Vo.fname = 'output.nii';
        spm_write_vol(Vo, Yo);
        fprintf('small cluster removal done!\n')
    catch
        fprintf('input file format is not supported.\n')
    end

else

    pixThreld =sc_filter;
    if erode_vol >0
        se = strel('cube',erode_vol);
        Y = imerode(Y ,se);
    end
    CC = bwconncomp(Y);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    for j =1:length(numPixels)
        if numPixels(j)<pixThreld
            Y(CC.PixelIdxList{j}) = Y(CC.PixelIdxList{j})*0;
        end
               
    end
end

end
