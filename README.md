# LSSVM-CC
LSSVM-CC: Ensemble Algorithm of Color Constancy Using Least Square Support Vector Machine
- Wang Xingguang,01/06/2023
- The LSSVM toolbox developed by Prof. Suyan Qu and Dr. Jianhua Zhang was used in the implementation of our proposed algorithm. We would like to express our gratitude for their excellent work in developing this valuable tool for researchers. LSSVM toolkit download and user's Guide can be found at https://www.esat.kuleuven.be/sista/lssvmlab/. We undertake not to use the toolbox for any commercial purposes.
```
%% setting
clear;
clc;
    
%%
addpath('.\utility');
addpath('.\func');
    
% Dataset_GS_Cubep_NUS is the dataTrain extracted from Gehler-Shi, Cube+ 
% and NUS-8, which includes: groundTruth, illuminant estimation of eight 
% unitary algorithms [GW WP SOG GGW GE1 GE2 PCA LSR], RGB-uv histogram 
% feature after dimensionality reduction and angle error.
%
% Dataset__NUS8 is the dataTrain of the dataset obtained by each camera in
% NUS-8, it's the same structure as Dataset_GS_Cubep_NUS

% Dataset_GS_Cubep_NUS = {'dataTrainGS.mat','dataTrainCubep.mat','dataTrainNUS.mat',};
% 
% Dataset__NUS8 = {'dataTrainnus1.mat','dataTrainnus2.mat','dataTrainnus2.mat',...
%     'dataTrainnus3.mat','dataTrainnus4.mat','dataTrainnus5.mat','dataTrainnus6.mat',...
%     'dataTrainnus7.mat','dataTrainnus8.mat'};
% 
% opt = genCNCOptions('k1',2,'k2',1,'method','rgb','chkCutPoint',0.80,'optimization',false,...
%     'NumClusters',2,'EpochNumber',90,'InitialStepSize',0.01,'indMethod',[1 2 7 8],'num',1,...
%     'cluster1Feature','featureTr','cluster2Feature','adjacentAngleError','gam',100,'sig2',0.1);

    
%% the tables and figures in the paper
mainTab2_GS_Cubep_NUS
mainTab45__NUS1_8   
mainTab6_SelectAlgo    
mainTab7_DiffClusNum
mainTab8_DiffArgument
mainFig3_QualityGehlerShi
mainFig4_QualityCubep
mainFig5_QualityNUS
```
