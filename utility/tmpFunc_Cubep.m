function nl_srgb = tmpFunc_Cubep(lin_rgb)

%% （4） 色彩空间转换（Color Space Conversion）
sRGB2XYZ = [0.4124564 0.3575761 0.1804375;0.2126729 0.7151522 0.0721750;0.0193339 0.1191920 0.9503041]; % standard
%XYZ2Cam = [7171 -1986 -648;-8085 15555 2718;-2170 2512 7457]/10000; % see adobe_coeff in dcraw.c
%XYZ2Cam = [6992,-1668,-806;-8138,15748,2543;-874,850,7897]/10000; % see adobe_coeff in dcraw.c------Nikon D40
%  XYZ2Cam = [6806,-179,-1020;-8097,16415,1687;-3267,4236,7690]/10000; % canon eos 1d
XYZ2Cam = [6941,-1164,-857;-3825,11597,2534;-416,1540,6039]/10000;% canon eos 550d
% XYZ2Cam = [7557,-2522,-739;-4679,12949,1894;-840,1777,5311]/10000;% Samsung NX2000
%XYZ2Cam = [5859,-211,-930;-8255,16017,2353;-1732,1887,7448]/10000;% Canon EOS-1Ds Mark III
%XYZ2Cam = [6347,-479,-972;-8297,15954,2480;-1968,2131,7649]/10000;% Canon EOS 5D

%XYZ2Cam = [5991,-1456,-455;-4764,12135,2980;-707,1425,6701 ]/10000; %ILCE 6400 see dcraw.c------Sony ILCE-6;
sRGB2Cam = XYZ2Cam * sRGB2XYZ;
sRGB2Cam = sRGB2Cam./ repmat(sum(sRGB2Cam,2),1,3); % normalize to 1
Cam2sRGB =  (sRGB2Cam)^-1;
lin_srgb = apply_cmatrix(lin_rgb, Cam2sRGB);
lin_srgb = max(0,min(lin_srgb,1)); % Always keep in 0-1

% lin_srgb =lin_rgb;
%% （5）亮度校正与伽马校正（Brightness and Gamma Correction）
%经验公式，图像的平均亮度是像素最大值的四分之一较合适
grayim = rgb2gray(lin_srgb); % Consider only gray channel
grayscale = 0.25/mean(grayim(:));
bright_srgb = min(1,lin_srgb * grayscale);

%bright_srgb=lin_srgb;
%伽马校正 2.2
nl_srgb = bright_srgb.^(1/2.2);