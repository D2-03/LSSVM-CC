% clear;
% clc;
%% init

% Dataset_GS_Cubep_NUS = {'dataTrainGS.mat','dataTrainCubep.mat','dataTrainNUS.mat',};
% 
% Dataset__NUS8 = {'dataTrainnus1.mat','dataTrainnus2.mat','dataTrainnus2.mat',...
%     'dataTrainnus3.mat','dataTrainnus4.mat','dataTrainnus5.mat','dataTrainnus6.mat',...
%     'dataTrainnus7.mat','dataTrainnus8.mat'};
% 
% opt = genCNCOptions('k1',2,'k2',1,'method','rgb','chkCutPoint',0.80,'optimization', ...
%     false,'NumClusters',2,'EpochNumber',90,'InitialStepSize',0.01,'indMethod',[1 2 7 8], ...
%     'cluster1Feature','featureTr','cluster2Feature','adjacentAngleError','gam',100,'sig2',0.1);

Dataset_GS_Cubep_NUS = {'dataTrainGS.mat','dataTrainCubep.mat','dataTrainNUS.mat'};

numCluster = [2 1 3];
indMethodSelect={[1 2 3 4 5 6 7 8],...
    [1 2 3 4 5 6 7],...
    [1 2 3 4 5 6 8],...
    [1 2 3 4 5 6],...
    [1 2 3 4 7 8],...
    [1 2 3 6 7],...
    [1 2 3 6 8],...
    [1 2 3 4],...
    [1 2 5 6],...
    [1 2 7 8]};

%% for table of selecting different unitary algorithm combination
for numRun=1:1   
    for i = 1:3
        for iK1=numCluster(i)   % the number of cluster
            for iK2=1 
                for jNumClu= iK1*iK2
                    for kEpochNum=90 
                        for m_indMethod = 1:10 
                            data=load(Dataset_GS_Cubep_NUS{i});
                            data=data.dataTrain;
                            data.selecSet=data.fold;
                            disp(['for the unitary algorithm combination: ', mat2str(indMethodSelect{1,m_indMethod}), ':'])
                            opt = genCNCOptions('k1',iK1,'k2',iK2,'method','rgb','chkCutPoint',0.80,...
                                'optimization',false,'NumClusters',jNumClu,'EpochNumber',kEpochNum,'InitialStepSize',0.01,...
                                'indMethod',indMethodSelect{1,m_indMethod},'cluster1Feature','featureTr','cluster2Feature','adjacentAngleError','gam',100,'sig2',0.01);
                            %
                            result = cluster2_anfis_cc(data,opt);
                            %genResultXls(result,fullfile('results',[data.selecSet '.xlsx']));
                            genResultSelectAlgoTab(result,fullfile('results',[data.selecSet 'SelectAlgoTab.xlsx']));
                            %fprintf('\n current: iterationNum=%s;\n iDatSelected=%s,\n  iK1=%s,\n iK2=%s, \n jNumClu=%s,\n kEpochNum=%s,\n  m_indMethod=%s\n',...
                                %num2str(iDatSelected*iK1*iK2*length(m_indMethod)*length(kEpochNum)*length(jNumClu)),...
                                %num2str(iDatSelected),num2str(iK1),num2str(iK2),num2str(jNumClu),num2str(kEpochNum),num2str(m_indMethod));
                        end
                    end
                end
            end
        end
    end
end
