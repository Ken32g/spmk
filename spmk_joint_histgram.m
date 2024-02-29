function spmk_joint_histgram(P1,P2)
    % Show the joint histogram of two images
    if nargin ==0
        P1 = spm_select(1,'image','Select image 1')
        P2 = spm_select(1,'image','Select image 2')
    end
    y1 = spm_read_vols(spm_vol(P1));
    y2 = spm_read_vols(spm_vol(P2));
    a1 = round(mat2gray(y1(:))*255);
    a2 = round(mat2gray(y2(:))*255);
    jhg = zeros(256,256);
    for i=1:numel(a1)
        jhg(a1(i)+1,a2(i)+1) =jhg(a1(i)+1,a2(i)+1) +1;
    end
                
    imshow(imresize(mat2gray(jhg)*255,6,'nearest'));
end