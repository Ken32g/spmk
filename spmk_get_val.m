function [TC, Nvolx,Vmax] = spmk_get_val(ImgFiles, MaskFile, ExtractType)

    % Format w_ExtractROITC(ImgFiles, MaskFile, ExtractType, OutputFile)
    % Input:
    %       ImgFiles       - ImgFiles, 3D Files' Cell or 4D file
    %       MaskFile       - The absolute path of mask file
    %       AnonyFlag      - 1, Single label in mask; 2, Multi label in mask
    %       OutputDir      - The directory of Output File
    %___________________________________________________________________
    % Written by Xindi Wang
    % State Key Laboratory of Cognitive Neuroscience and Learning & IDG/McGovern Institute for Brain Research, Beijing Normal University

    %Load 4D Volume
    [Data, VoxelSize, FileList, Header] = y_ReadAll(ImgFiles);
    [n1, n2, n3, n4] = size(Data);
    Data2D = reshape(Data, [prod([n1, n2, n3]), n4]);
    Data2D = Data2D';

    %Load Mask
    Mask = y_ReadRPI(MaskFile);
    % Mask=fix(Mask); % Fix to Int

    if ExtractType == 1
        Mask = logical(Mask);
    end

    Label = unique(Mask);
    Label(Label == 0) = [];

    if isempty(Label)
        error('No ROI in mask! Please check mask file first');
    end

    if numel(Label) == 1 && Label(1) == 1
        fprintf('\tExtracting TC from mask\n');
        BW = (Mask == Label);
        TC = double(mean(Data2D(:, BW(:)), 2, 'omitnan'));
        Vmax = double(max(max(Data2D(:, BW(:)))));
        Nvolx = sum(BW(:));
        return;
    end

    TC = zeros(n4 + 1, numel(Label));
    Vmax = zeros(n4 + 1, numel(Label));
    Nvolx = zeros(n4 + 1, numel(Label));
    for i = 1:numel(Label)
        lab = Label(i);
        fprintf('\tLabel-->%d: Extracting TC from ROI\n', lab);
        TC(1, i) = lab;
        BW = (Mask == lab);
        TC(2:end, i) = double(mean(Data2D(:, BW(:)), 2));
        Vmax(2:end, i) = double(max(max(Data2D(:, BW(:)), 2)));
        Nvolx(2:end, i) = sum(BW(:));
    end
end
