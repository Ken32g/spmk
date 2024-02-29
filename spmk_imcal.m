%%
function spmk_imcal(inputfile, format, outputfile)

% Perform algebraic functions on images
% FORMAT Vo = spm_imcalc(Vi, Vo, f [,flags [,extra_vars...]])
% Vi            - struct array (from spm_vol) of images to work on
%                 or a char array of input image filenames
% Vo (input)    - struct array (from spm_vol) containing information on
%                 output image
%                 ( pinfo field is computed for the resultant image data, )
%                 ( and can be omitted from Vo on input.  See spm_vol     )
%                 or output image filename
% f             - MATLAB expression to be evaluated
% flags         - cell array of flags: {dmtx,mask,interp,dtype,descrip}
%                 or structure with these fieldnames
%      dmtx     - read images into data matrix?
%                 [defaults (missing or empty) to 0 - no]
%      mask     - implicit zero mask?
%                 [defaults (missing or empty) to 0 - no]
%                  ( negative value implies NaNs should be zeroed )
%      interp   - interpolation hold (see spm_slice_vol)
%                 [defaults (missing or empty) to 0 - nearest neighbour]
%      dtype    - data type for output image (see spm_type)
%                 [defaults (missing or empty) to 4 - 16 bit signed shorts]
%      descrip  - content of the 'descrip' field of the NIfTI header
%                 [defaults (missing or empty) to 'spm - algebra']
% extra_vars... - additional variables which can be used in expression
%
% Vo (output)   - spm_vol structure of output image volume after
%                 modifications for writing
%______________________________________________

    matlabbatch ='';
    matlabbatch{1}.spm.util.imcalc.input = inputfile;
    matlabbatch{1}.spm.util.imcalc.output = outputfile;
    matlabbatch{1}.spm.util.imcalc.outdir = {''};
    matlabbatch{1}.spm.util.imcalc.expression = format;
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run', matlabbatch);
end