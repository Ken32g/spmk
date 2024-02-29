function output_xls = spmk_extract_ROI_data(atlas_nii, contrast_niis, isxls, output_name)
%% spmk_extract_ROI_data
% 
% FOMAT ROI_data = spmk_extract_ROI_data(atlas_nii, contrast_niis, isxls)
%
% atlas_nii     -char, the atlas file path, only one atlas is allowed.
% contrast_niis -cell, containing the nii image(s) to be analyzed. Only
% cell.
% isxls         -1 or 0. Save the final xls.
% output_name   -char, output xls file name.

% Extract the mean value of ROI based on atlas.


if nargin==2
    isxls =0;
end

if nargin<2
    disp('No enough inputs. At least two args are required.')
end

% Check registration of atlas and analyzed images.
try
    spm_check_registration(atlas_nii, contrast_niis);
catch
    disp('Error. Skip registration check.')
end

% Reslice the atlas based on contrast_niis
% reslice_contrast_nii = cell2mat(contrast_niis(1,1));
% mkdir('temp')
% copyfile(atlas_nii, 'temp\atlas_temp.nii')
% copyfile(reslice_contrast_nii, 'temp\constrast_temp.nii')
% spm_reslice({
%          'temp\constrast_temp.nii'
%          'temp\atlas_temp.nii'
% })
% atlas_nii = 'temp\ratlas_temp.nii';

% Question dialog. Continue or abort subsequent analysis.
check_result = questdlg('Continue?');
switch check_result
    case 'Yes'
        
        
        Y = spm_read_vols(spm_vol(atlas_nii),1);
        Y(isnan(Y))=0;      % Replace nan to 0.
        indxs = unique(Y);  % The index of ROIs.
        roi_count = length(indxs);
        output_xls = cell(length(indxs)*length(contrast_niis)+1, 4);
        output_xls(1,1) = {'Fname'};
        output_xls(1,2) = {'ROI'};
        output_xls(1,3) = {'Mean'};
        output_xls(1,4) = {'Volume'};
        file_length = length(contrast_niis);
        
        % Get MIP image of atlas
        [atlas_z_MIP,atlas_x_MIP,atlas_y_MIP] = spmk_draw_mip(Y, [0 roi_count],[0 0 0],0,'gray',0);
        % Initialize waitbar
        bar = waitbar(0,'...');
        
        for n =1:file_length

            close all
            % Show the MIP images of atlas.
            pv = figure;
            subplot(3,4,1);imshow(atlas_x_MIP);title('Atlas');
            subplot(3,4,5);imshow(atlas_y_MIP);
            subplot(3,4,9);imshow(atlas_z_MIP);
            
            contrast_nii = cell2mat(contrast_niis(n));
            [~,contrast_nii_name,~,~] = spm_fileparts(contrast_nii);


            disp([num2str(n), '/', num2str(file_length)]);
            
            [z_contrast_mip,x_contrast_mip,y_contrast_mip] = spmk_draw_mip(contrast_nii, [0 0],[0 0 0],0,'gray',0);
            figure(pv)
            subplot(3,4,3);imshow(x_contrast_mip);title('Contrast image');
            subplot(3,4,7);imshow(y_contrast_mip);
            subplot(3,4,11);imshow(z_contrast_mip);
            for m = 1:roi_count-1
                
                indx = find(Y==m);
                [x,y,z] = ind2sub(size(Y),indx);
                
                XYZ = [x y z]';
                % Get mean value
                con_data = spm_get_data({contrast_nii}, XYZ);
                suvmean = nanmean(con_data,2);
                line = roi_count*(n-1)+m;
                output_xls(line,1) = {contrast_nii_name};
                output_xls(line,2) = {num2str(m)};
                output_xls(line,3) = {suvmean};
                output_xls(line,4) = {sum(con_data)};
                disp([atlas_nii, '-',contrast_nii, '--roi:',num2str(m),';value:',num2str(suvmean)]);
                Ym = zeros(size(Y));
                Ym(Y==m)=1;
                
                [z_indx_mip,x_indx_mip,y_indx_mip] = spmk_draw_mip(Ym, [0 1],[0 0 0],0,'gray',0);
                
                % Show the MIP images of contrast nii image.
                figure(pv)
                subplot(3,4,2);imshow(x_indx_mip);title(num2str(m));
                subplot(3,4,6);imshow(y_indx_mip);
                subplot(3,4,10);imshow(z_indx_mip);
                y_roi_contrast = y_contrast_mip;
                x_roi_contrast = x_contrast_mip;
                z_roi_contrast = z_contrast_mip;
                
                % Mask the contrast image with binary roi
                try
                    y_roi_contrast(y_indx_mip==0)=0;
                    x_roi_contrast(x_indx_mip==0)=0;
                    z_roi_contrast(z_indx_mip==0)=0;
                catch
                    disp('can not mask the contrast img using the roi')
                end
                
                subplot(3,4,4);imshow(x_roi_contrast);
                subplot(3,4,8);imshow(y_roi_contrast);
                subplot(3,4,12);imshow(z_roi_contrast);
                % Update waitbar 
                waitbar(m/roi_count, bar, ['current roi:', num2str(m),'total:',num2str(roi_count)])
                
            end
        end
        if isxls==1
            xlswrite([output_name,'.xls'],output_xls)
      
        end
        
    case 'No'
        disp('spm_check_registration failed, end. ')
    case 'Cancel'
        disp('check register. ')
end
% rmdir('temp','s')
close all
end