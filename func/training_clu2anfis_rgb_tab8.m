function model = training_clu2anfis_rgb(data_train,opt)
%%
% data_train.filesTr = dataTrain.filesTr(1:568,:);
% data_train.cmTr = dataTrain.cmTr(1:568,:);
% data_train.featureTr = dataTrain.featureTr(1:568,:);
% data_train.illSetTr = dataTrain.illSetTr(1:568,:);
% data_train.illSet8Tr_nor = dataTrain.illSet8Tr_nor(1:568,:);
% data_train.gtIllumTr = dataTrain.gtIllumTr(1:568,:);
% data_train.idxNo = dataTrain.idxNo(1:568,:);
% data_train.adjacentAngleError= dataTrain.adjacentAngleError(1:568,:);
% data_train.colorangle = dataTrain.colorangle(1:568,:);
% model = training_clu2anfiscc(data_train,2,3);
%%
if nargin<2
    opt=genCNCOptions();
end
k1=opt.k1;
k2=opt.k2;
gam = opt.gam;
sig2 = opt.sig2;
%% cluster the data_train into k1*k2 regions
dataCluSquare = twostepcluster(data_train,opt);
model.modelNumberK1=k1;
model.modelNumberK2=k2;
model.dataCluSquare=dataCluSquare;

%% trainning anfis model
%%
warning off;
tic;
for iRegion=1:k1
    for iCluster=1:k2
        %% input Location
        if opt.indMethod==0
            region1AE=dataCluSquare.colorangle{iRegion, iCluster};
            aemax=max(region1AE,[],2);%size(aemax);
            norRegion1AE=region1AE./aemax;
            sumNAE=sum(norRegion1AE); % size(sumNAE);
            indMethod=find(sumNAE<=min(sumNAE(sumNAE>median(sumNAE))));
        else
            indMethod=opt.indMethod;
        end
        inputLocation=sort([indMethod*2-1 indMethod*2]);
        
        nImgInSubsub=size(dataCluSquare.illSet8Tr_nor{iRegion, iCluster},1);
        IF=zeros(nImgInSubsub,16);
        for i=1:nImgInSubsub
            IFmatrix_i=dataCluSquare.illSet8Tr_nor{iRegion, iCluster}{i, 1};
            IF(i,:)=reshape(IFmatrix_i(:,1:2)',1,[]);
        end
        %
        GTmatrix=dataCluSquare.gtIllumTr{iRegion, iCluster};
        
        %% trainging data; checking data
        nImgInSubsub_8per = fix(nImgInSubsub*opt.chkCutPoint); %0.85
        nImgInSubsub_2per = fix(1);
        datin=IF(nImgInSubsub_2per:nImgInSubsub_8per,inputLocation);
        datout=GTmatrix(nImgInSubsub_2per:nImgInSubsub_8per,:);
        chkdatin=IF(nImgInSubsub_8per+1:nImgInSubsub,inputLocation);  %用来验证的数据
        chkdatout=GTmatrix(nImgInSubsub_8per+1:nImgInSubsub,:);    %此处为验证集的真实值，用来和估计值做对比
        
        %% Model building
        type = 'function estimation';
        kernel = 'RBF_kernel';
        %proprecess='proprecess';
        %参数寻优
        modell = initlssvm(datin,datout,type,gam,sig2,kernel);  
%         costfun = 'crossvalidatelssvm';  %使用交叉验证进行寻优
%         costfun_args = {10,'mse'};
%         optfun = 'gridsearch';  %'simplex' 通过在参数空间穷尽对比得到最好的参数.'gridsearch'
%         modell = tunelssvm(modell,optfun,costfun,costfun_args);
        modell = trainlssvm(modell); %训练模型
        chkdatoutpre = simlssvm(modell,chkdatin); %输入预测数据进行预测
        
        
        
        gt=chkdatout;
        preRGB=chkdatoutpre;
        preRGBNor=preRGB./[sum(preRGB')]';
        angle_gt_pre=zeros(size(gt,1),1);
        clear colorangle;
        for i=1:size(gt,1)
            angle_gt_pre(i,1) = colorangle(gt(i,:), preRGBNor(i,:));
        end
        
        [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]=...
            calculateExtendedAngularStatistics(gt, preRGBNor);
        %% all LSSVM model
        model.model{iRegion,iCluster}=modell;       
        model.trainingsample{iRegion,iCluster}=[datin datout];       
        model.modelgt{iRegion,iCluster}=gt;
        model.modelpreRGBNor{iRegion,iCluster}=preRGBNor;        
        model.sampleNumerEachRegion{iRegion,iCluster}=nImgInSubsub;       
        model.selectMethod{iRegion,iCluster}=indMethod;
        model.inputlocation{iRegion,iCluster}=inputLocation;        
        model.statisticMetrics{iRegion,iCluster}=...
            [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle];
        toc
    end
end
%%
gtChk=[];
preRGBNorChk=[];
for iRegion=1:k1
    for iCluster=1:k2
        gtChk=[gtChk;model.modelgt{iRegion,iCluster}];
        preRGBNorChk=[preRGBNorChk;model.modelpreRGBNor{iRegion,iCluster}];
    end
end
[minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]= ...
    calculateExtendedAngularStatistics(gtChk, preRGBNorChk);
model.ChkMetrics = [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle];
