% clear;
% clc;
%%
% Dataset_GS_Cubep_NUS is the dataTrain extracted from Gehler-Shi, Cube+ 
% and NUS-8, which includes: groundTruth, illuminant estimation of eight 
% unitary algorithms [GW WP SOG GGW GE1 GE2 PCA LSR], RGB-uv histogram 
% feature after dimensionality reduction and angle error.
%
% Dataset__NUS8 is the dataTrain of the dataset obtained by each camera in
% NUS-8, it's the same structure as Dataset_GS_Cubep_NUS


% Optimal number of clusters
numCluster = [3 1 1 3 1 2 2 1];
% Optimal algorithm combination
combialgorithm = {[1 2 3 4 7 8],[1 2 3 4 7 8],[1 2 3 6 8],[1 2 7 8],...
    [1 2 3  6 8],[1 2 3 4 5 6 8],[1 2 7 8],[1 2 3 4]};  

Dataset__NUS8 = {'dataTrainnus1.mat','dataTrainnus2.mat','dataTrainnus3.mat',...
    'dataTrainnus4.mat','dataTrainnus5.mat','dataTrainnus6.mat','dataTrainnus7.mat',...
    'dataTrainnus8.mat'};

%% for table 2 , table 3 , table 4 and table 5
for runtimes= 1:1 
    for i = 1:8
        opt = genCNCOptions('k1',numCluster(i),'k2',1,'method','rgb','chkCutPoint',0.80,...
            'optimization',false,'NumClusters',numCluster(i)*1,'EpochNumber',90,'InitialStepSize',...
            0.01,'indMethod',combialgorithm{i},'num',1,'cluster1Feature','featureTr',...
            'cluster2Feature','adjacentAngleError','gam',100,'sig2',0.1);

        % % Select a different dataset(Gehler-Shi, Cube+, NUS-8) by modifying i(1,2,3)
        % in load(Dataset_GS_Cubep_NUS{i})
        data=load(Dataset__NUS8{i}); 
        data=data.dataTrain;
        data.selecSet=data.fold;
        result = cluster2_anfis_cc(data,opt);
        genResultXls(result,fullfile('results',[data.selecSet '.xlsx'])); 
    end
end
