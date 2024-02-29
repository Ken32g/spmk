function spmk_transf_suv(suvType, injectDose,isDel)
%% get suv from dicom
% FORMAT spmk_get_suv(nii_file)

if nargin ==0
    isDel=0;
    injectDose=0;
    suvType = 1;
end
if nargin ==1
    isDel=0;
    injectDose=0;
    suvType = 1;
end
% If template Nii does not exist, generate a nii file first.
if isempty(dir('*.nii'))
    system(['D:\MRI\MRIcron\Resources\dcm2niix.exe ',pwd]);
end
nii_files = dir('*.nii');
nii_file = nii_files(1).name;
% read nii file
v_raw = spm_vol(nii_file);
y = spm_read_vols(v_raw);

dcms = dir('*.dcm');
if isempty(dcms)
    dcms = dir('00*');
end

% check if the nifti dim equals to the file counts 
if v_raw.dim(3)~=length(dcms)
    disp('wrong dim')
    return
end

% main loop
for m =1:length(dcms)
    dcm = dcms(m).name;
    header = dicominfo(dcm);
    x = double(dicomread(dcm));
    RescaleSlope = header.RescaleSlope;
    if suvType==1
        weight = header.PatientWeight;
    elseif suvType==2
        weight =1;
    end
    if injectDose>0
        tot_dose = injectDose;
    else
        tot_dose = header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose;
    end
    half_life = header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife; % [second]
    
    acq_time = datetime(header.AcquisitionTime(1:6),'InputFormat','HHmmss');
    inj_time = datetime(header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartDatetime(9:14),'InputFormat','HHmmss');
    delta_time = seconds(diff([inj_time acq_time]));% [second]
    
    corrected_dose =tot_dose  * 2^(- delta_time  / half_life); % [Bq]
    SUV_coef = RescaleSlope * weight * 1000/ corrected_dose;
    fprintf([num2str(m), 'weight:', num2str(weight),'\n']);
    fprintf([num2str(m), 'tot_dose:', num2str(tot_dose),'\n']);
    
    
    % [g/Bq] = [] * [Kg]* 1000[g/kg] / [Bq]
    
    %     delta_time = (str2double(header.AcquisitionTime) - str2double(header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartDatetime)) / 100; % [min]
%     y(:,:,m) =x * SUV_coef;
%     dm =  y(:,:,m) -rot90(x,3);
    imshow(mat2gray([y(:,:,m)/10e6
        rot90(x,3) * SUV_coef
         ])    )
%     imshow()
    y(:,:,m) =rot90(x,3) * SUV_coef; 
    
end
  
    % Create SUV image
    v_out=v_raw;
    if suvType==1
        v_out.fname = ['SUV_',v_raw.fname];
    elseif suvType==2
        v_out.fname = ['IDCC_',v_raw.fname];
    end
    
%     v_out.dt = [64 0];
%     v_out.dim
    spm_write_vol(v_out, y)
    if isDel==1
    delete(nii_file)
    end
    % open the file
%     winopen(v_out.fname)
end
