function img = proprocGehlerImg(fileNum,imageDir,dataDir)
%% black-level removal, linearization, mask
if nargin==0
    fileNum=1;
    imageDir='image\GS';
    %dataDir='D:\nutstore\我的坚果云\QLU\paper\paper_IlluminationEst\Illum_Est_Matlab\dataset';
end
if nargin==1
    imageDir='image\GS';
    %dataDir='D:\nutstore\我的坚果云\QLU\paper\paper_IlluminationEst\Illum_Est_Matlab\dataset';
end
if nargin==2
    %dataDir='D:\nutstore\我的坚果云\QLU\paper\paper_IlluminationEst\Illum_Est_Matlab\dataset';
end
%%
dataMat=load(fullfile('dataGehlerShi.mat'));
data=dataMat.dataGehlerShiCanon1D;
if fileNum>86
    fileNum = fileNum - 86;
    data=dataMat.dataGehlerShiCanon5D;
end
% nImages = length( data );
%% Read in image and normalize to [0, 1].
img = double(imread(fullfile(imageDir,data(fileNum).imageName)));
img = (double( img ) - data(fileNum).darkness_level) ...
    / (data(fileNum).saturation_level - data(fileNum).darkness_level);
img( img < 0 ) = 0;
%% Create mask for saturated pixels and colour checker.
[m, n, ~] = size( img );
mask = false( m, n );
% threshold = 0.98;
% mask( img(:,:,1) >= threshold ) = true;
% mask( img(:,:,2) >= threshold ) = true;
% mask( img(:,:,3) >= threshold ) = true;
coordinates = [data(fileNum).cc1, data(fileNum).cc2, data(fileNum).cc3, data(fileNum).cc4];
coordinates = min( coordinates, [Inf size(mask,1) Inf size(mask,2)] );
coordinates = max( coordinates, [1 1 1 1] );
mask( coordinates(1):coordinates(2), coordinates(3):coordinates(4) ) = true;
%
%% Black out saturated pixels and colour checker.
[im1,im2,im3] =imsplit(img);
im1(mask==true)=0;
im2(mask==true)=0;
im3(mask==true)=0;
img=cat(3,im1,im2,im3);
% A_sRGB = lin2rgb(img,'OutputType','double');
% figure,imshow(A_sRGB,'InitialMagnification',25);
% title('Sensor Data With sRGB Gamma Correction');


