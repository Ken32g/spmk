function spmk_dcm2suv(dcmpath)
addpath D:\MRI\spm12\toolbox\RESTplus\preprocessing
system(['D:\MRI\MRIcron\Resources\dcm2niix.exe ',dcmpath]);
if isdir(dcmpath)==1
    mkdir temp
    dcms = dir(dcmpath);
    dcms = dcms(3:end);
    for m=1:length(dcms)
        copyfile([dcmpath, '\',dcms(m).name], ['temp\',num2str(m)])
    end
    
    nii_file = dir([dcmpath,'\*','nii'])
    y = spm_vol([dcmpath]);
    v = spm_read_vols(y);
% 
% header = dicominfo(dcm);
% %     delta_time = (str2double(header.AcquisitionTime) - str2double(header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartDatetime)) / 100; % [min]
% RescaleSlope = header.RescaleSlope;
% %     RescaleSlope =1
% weight = header.PatientWeight;
% tot_dose = header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose;
% half_life = header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife; % [second]
% 
% acq_time = datetime(header.AcquisitionTime(1:6),'InputFormat','HHmmss');
% inj_time = datetime(header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartDatetime(9:14),'InputFormat','HHmmss');
% delta_time = seconds(diff([inj_time acq_time]));% [second]
% 
% corrected_dose =tot_dose  * 2^(- delta_time  / half_life); % [Bq]
% SUV_factor = (RescaleSlope^-1 * weight * 1000)/ (corrected_dose);
% % [g/Bq] = [] * [Kg]* 1000[g/kg] / [Bq]
% 
% % Create SUV image
% disp(SUV_factor);
% PET_SUV = v  * double(SUV_factor)  ; %[g/ml] = [Bq/ml] * [g/Bq]
% ys=y;
% ys.fname = ['SUV_',y.fname];
% spm_write_vol(ys, PET_SUV)
    
end

end
