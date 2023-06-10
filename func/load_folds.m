function indices = load_folds(camera)
%% Load the 3-fold cross-validation indices.
% This function loads the indices for 3-fold validation
% *Input:
%   -camera: camera name (string)
% *Output:
%   -indices: Nx1 indices that refers to the fold of each sample
%
% Copyright (c) 2019 Mahmoud Afifi, Abhijith Punnappurath, 
% Graham Finlayson, and  Michael S. Brown
% EECS, York University, Canada
% School of Computing Sciences, The University of East Anglia, UK
%
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software and associated documentation files (the
% "Software"), to deal in the Software with restriction for its use for
% research purpose only, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
%
% Please cite the following work if this program is used:
% Mahmoud Afifi, Abhijith Punnappurath, Graham Finlayson, and
% Michael S. Brown, As-projective-as-possible bias correction for
% illumination estimation algorithms, Journal of the Optical Society of
% America A (JOSA A), Vol. 36, No. 1, pp. 71-78, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
eval(sprintf('load(fullfile(''folds'',''%s_folds.mat''));',camera)); %导入folds中相应的.mat文件
% eval内的语句输出：'load(fullfile('folds','gehlershi_and_cubep_folds.mat'));'
% eval(a)相当于执行a的内容
% fullfile函数可以将多个字符串拼接成文件路径  f = fullfile(filepart1,filepart2,…,filepartN)  输出：将各个输入用"\"拼接起来  即：f =  filepart1\filepart2\…\filepartN 


