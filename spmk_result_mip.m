function spmk_result_mip(pair, tval,fmask)
colors = {
    [249 201 152]
    [245 154 144]
    [159 190 218]
    [191 30 46]
    [13 76 109]
    [187 160 203]
    };
%%
c1 = cell2mat(colors(pair(1)));
c2 = cell2mat(colors(pair(2)));
%%
mkdir temp
cd temp
copyfile('..\spmT_0001.nii', '.\t1.nii');
copyfile('..\spmT_0002.nii', '.\t2.nii');
copyfile('D:\MRI\spm12\toolbox\cat12\templates_volumes\rbrainmask.nii', '.\m.nii')
copyfile(['D:\MRIdataset\AFT\_TSPO_comp\ANOVA-3\',fmask,'.nii'], '.\fm.nii')
%%

spmk_imcal({'t1.nii' 'fm.nii'}',['i1>',num2str(tval)],'p1');
spmk_imcal({'t2.nii' 'fm.nii'}',['i1>',num2str(tval)],'p2');

spmk_imcal({'p1.nii' 'fm.nii'}','i2.*(i1>0)','r1');
spmk_imcal({'p2.nii' 'fm.nii'}','i2.*(i1>0)','r2');

%%
spmk_draw_mip('r1.nii', [0 0], [1 1 1],0,'gray', 0);
spmk_draw_mip('r2.nii', [0 0], [1 1 1],0,'gray', 0);
spmk_draw_mip('m.nii', [0 0], [1 1 1],0,'gray', 0);
%%

ress = [];
for prex = ["a" "s" "c"]
    ni = [];
    r1 = [char(prex), 'MIP_r1.nii.png'];ri1 = imread(r1);
    r2 = [char(prex), 'MIP_r2.nii.png'];ri2 = imread(r2);
    m = [char(prex), 'MIP_m.nii.png'];mi = imread(m);
%     ci = edge(mi(:,:,1),'sobel');
%     ci = repmat(ci,1,1,3);
    %
    ri1(ri1>0) =1;
    ri2(ri2>0) =1;
    
    pr1 = ri1(:,:,1);
    pr2 = ri2(:,:,1);
    pm = mi(:,:,1);
    for i =1:3
        ric = 255*ones(size(pr1));
        ric(pm ==255) =245;
        if length(unique(pr1))>1
            ric(pr1==1) = c1(i);
        end
        if length(unique(pr2))>1
            ric(pr2==1) = c2(i);
        end
        ni(:,:,i) = ric;
    end
    
    ni = uint8(ni);
    ni = imresize(ni,4,'bicubic');
    imwrite(ni, [char(prex),'res.png'])
    nisize = size(ni);
    if nisize(2)==316
        ca = ones(316, 32,3)*255;
        ni = [ca ni ca];
    end
    size(ni)
    ress = [
        ress
        ni
        ];
end
imwrite(ress, 'result.png')
copyfile('result.png', ['..\',num2str(pair(1)), num2str(pair(2)),'.png'])
cd ..
rmdir('temp','s')
clear;

end
