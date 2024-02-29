function spmk_gzip(nii)
%% gzip nii files and delete nii files
    if nargin ==0
        nii_files = dir('*.nii'); 
        for m =1: numel(nii_files)
            nii_file = nii_files(m).name;
            disp([num2str(m), '/',num2str(length(nii_files))])
            gzip(nii_file);
            delete(nii_file);
        end
    else
        gzip(nii);
        delete(nii);
    end
    
    disp("done!")

end