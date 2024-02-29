function spmk_get_coord(P)
%% spmk_get_coord
% FORMAT [zgray, xgray, ygray] = spmk_draw_mip(img, g_thr, save_img, preview, iscolor, isfilter)

%%

% small cluster filter
if sc_filter>0
    pixThreld =sc_filter;
    CC = bwconncomp(Y);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    for j =1:length(numPixels)
        if numPixels(j)<pixThreld
            Y(CC.PixelIdxList{j}) = Y(CC.PixelIdxList{j})*0;
        end
    end
    
end
end