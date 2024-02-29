function [zgray, xgray, ygray] = spmk_draw_mip(P, thresh, saveimg, preview, color, sc_filter)
%% drawMIP
% convert Nifti file to a maximum intensity projection png image
% FORMAT [zgray, xgray, ygray] = spmk_draw_mip(img, g_thr, save_img, preview, iscolor, isfilter)
% P1           - a char or cell array of filenames
% thresh       - the min and max of SUV, default 1-12 (SUV)
% isSave       - is save mip img, for axis, conoral and saggital views. Defaults to [1 1 1]
% preview      - show the preview window
%                   1   -figure windows(default); 
%                   0   -no figure windows
% color        - char. colormap, jet or gray
%
% Examples:
% draw mip of axis, conoral and sagittal images with the threshold from 0 to 1 without small cluster filter, without a preview window
% spmk_draw_mip('lesion.nii', [0 1], [1 1 1], 0,'gray',0); 
%
% draw mip of sagittal image with the threshold from 0 to max with a small cluster filter, and show result in a preview window
% spmk_draw_mip('lesion.nii', [0 0], [0 0 1], 1,'jet',100); 
%
% draw mip as default settings 
% spmk_draw_mip('lesion.nii') 

%%
if nargin==1
    thresh = [1 12];
    saveimg =[1 1 1];
    preview=0;
    color = 'jet';
    sc_filter = 0;
    
elseif nargin==2
    saveimg =[1 1 1];
    preview=0;
    color = 'jet';
    sc_filter = 0;
    
elseif nargin == 0
    P = spm_select();
    spmk_draw_mip(P);
end

% load nii_file_name or spm loaded volume
if ischar(P)
    f=spm_vol(P);
    Y=spm_read_vols(f);
    output_name = P;
else
    Y = P;
    output_name = 'output';
end

% small cluster filter
if sc_filter>0
    Y = spmk_small_cluster(Y, sc_filter);
end

% set thresh according to the max value
if thresh ==[0 0]
%     Ymax = max(max(max(Y)));
%     thresh = [0 Ymax+4];


    NY = Y(Y~=0);
    NY = NY(:);
    Ymed = median(NY);
    Yrpct = prctile(NY, 99.5);
    delt = -Ymed + Yrpct;
    Ymin = Ymed-delt;
%     if Ymin<0
%         Ymin = 0;
%     end
%     thresh = [Ymin Ymed+delt];
    thresh = [prctile(NY, 1) prctile(NY, 99)];
end

Y =smooth3(Y,'box',3);

% get 2d MIP image of 3 projection directions 
zgray = mat2gray(max(Y, [], 3),thresh);
xgray = mat2gray(rot90(permute(max(Y, [], 2),[1,3,2])),thresh);
ygray = mat2gray(rot90(permute(max(Y, [], 1),[2,3,1])),thresh);

% figure plot 
if preview==1
    figure
    subplot(1,3,1);imshow(zgray);
    subplot(1,3,2);imshow(xgray);
    subplot(1,3,3);imshow(ygray);
end

if saveimg(1)==1
    save_mip(zgray,color, ['aMIP_',output_name]);
end
if saveimg(2)==1
    save_mip(xgray,color, ['cMIP_',output_name]);
end
if saveimg(3)==1
    save_mip(ygray,color, ['sMIP_',output_name]);
end

end

function save_mip(v, iscolor, file_name_pre)
if strcmp(iscolor, 'jet') == 1
    colored_im = ind2rgb(gray2ind(v, 255), jet(255));
elseif strcmp(iscolor, 'gray') == 1
    colored_im = ind2rgb(gray2ind(v, 255), gray(255));
end
imwrite(colored_im, [file_name_pre '.png']);
end