function spmk_lesionnum(L, pixThreld, output)
    V = spm_vol(L);
    Y = spm_read_vols(V);

    CC = bwconncomp(Y);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    ll=1;
    
    for j =1:length(numPixels)
        if numPixels(j)<pixThreld
            Y(CC.PixelIdxList{j}) = 0;
        else
            Y(CC.PixelIdxList{j}) = ll;
            ll =ll+1;
        end
               
    end
    

    V2 = V;
    V2.dt = [2 0];
    V2.fname = output;
    spm_write_vol(V2,Y);
end