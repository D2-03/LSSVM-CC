# LSSVM-CC
LSSVM-CC: Ensemble Algorithm of Color Constancy Using Least Square Support Vector Machine
- Wang Xingguang,01/06/2023
```
%% setting
clear;
clc;
    
%%
addpath('.\utility');
addpath('.\func');
    
%% dataTrain
data=load('dataTrain.mat');
disp('Load data from dataTrain.mat');
data=data.dataTrain;
    
%% the tables and figures in the paper
mainTab23_GSCubep
mainTab4_DiffClusNum
mainTab5_SelectAlgo
mainFig3_QualityGehlerShi
mainFig4_QualityCubep
mainFig5_QualityNUS
```
