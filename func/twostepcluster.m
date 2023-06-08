function dataCluSquare = twostepcluster(data_train,opt)
%% 聚类后再聚类
% ex:
% data_train.filesTr = dataTrain.filesTr(1:568,:);
% data_train.cmTr = dataTrain.cmTr(1:568,:);
% data_train.featureTr = dataTrain.featureTr(1:568,:);
% data_train.feat4Cheng = dataTrain.feat4Cheng(1:568,:);
% data_train.illSetTr = dataTrain.illSetTr(1:568,:);
% data_train.illSet8Tr_nor = dataTrain.illSet8Tr_nor(1:568,:);
% data_train.gtIllumTr = dataTrain.gtIllumTr(1:568,:);
% data_train.idxNo = dataTrain.idxNo(1:568,:);
% data_train.adjacentAngleError= dataTrain.adjacentAngleError(1:568,:);
% data_train.colorangle = dataTrain.colorangle(1:568,:);
% dataCluSquare=twostepcluster(data_train,opt);
%%
if nargin<2
    opt=genCNCOptions();
end
k1=opt.k1;
k2=opt.k2;
%%
featureTr = data_train.featureTr;
%tt1 = data_train.tt1;
%tt2 = data_train.tt2;
illSet8Tr_nor = data_train.illSet8Tr_nor;
gtIllumTr = data_train.gtIllumTr;
adjacentAngleError= data_train.adjacentAngleError;
%% 根据cm分成k1组;同时files,lgt,cm都对应分组
tic
minN=0;
while minN<30*k2
    [idx1, C1] = kmeans(data_train.(opt.cluster1Feature),k1,'Distance','sqeuclidean','MaxIter',10000); %kmean clustering
    [N,~] = histcounts(idx1);
    minN=min(N);
end
%
Subset.featureTr=cell(k1,1);
Subset.illSet8Tr_nor=cell(k1,1);
Subset.gtIllumTr=cell(k1,1);
Subset.adjacentAngleError=cell(k1,1);
%Subset.tt1=cell(k1,1);
%Subset.tt2=cell(k1,1);
for i=1:k1
    Subset.featureTr{i}=featureTr(idx1==i,:);
    Subset.illSet8Tr_nor{i}=illSet8Tr_nor(idx1==i);
    Subset.gtIllumTr{i}=gtIllumTr(idx1==i,:);
    Subset.adjacentAngleError{i}=adjacentAngleError(idx1==i,:);
%     Subset.tt1{i}=tt1(idx1==i,:);
%     Subset.tt2{i}=tt2(idx1==i,:);
end
toc
%% 每feature组再分成k2组；同时files,lgt,cm都对应分组
tic
idx2=cell(k1,1);
C2=cell(k1,1);
for i=1:k1
    %if k2>size(data,1),error('error: k2 is too big.'); end
    minN=0;
    while minN<20
        data=Subset.(opt.cluster2Feature){i};
        [idx, C] = kmeans(data,k2,'Distance','sqeuclidean','MaxIter',10000); %kmean clustering
        [N,~] = histcounts(idx);
        minN=min(N);
    end
    idx2{i}=idx;
    C2{i}=C;
end
%
SubSubset.featureTr=cell(k1,k2);
SubSubset.illSet8Tr_nor=cell(k1,k2);
SubSubset.gtIllumTr = cell(k1,k2);
SubSubset.adjacentAngleError=cell(k1,k2);
% SubSubset.tt1=cell(k1,k2);
% SubSubset.tt2=cell(k1,k2);
for i=1:k1
    for j=1:k2
        data=Subset.featureTr{i};  SubSubset.featureTr{i,j}=data(idx2{i}==j,:);
        data=Subset.illSet8Tr_nor{i};    SubSubset.illSet8Tr_nor{i,j}=data(idx2{i}==j);
        data=Subset.gtIllumTr{i};  SubSubset.gtIllumTr{i,j}=data(idx2{i}==j,:);
        data=Subset.adjacentAngleError{i};  SubSubset.adjacentAngleError{i,j}=data(idx2{i}==j,:);
%         data=Subset.tt1{i};  SubSubset.tt1{i,j}=data(idx2{i}==j,:);
%         data=Subset.tt2{i};  SubSubset.tt2{i,j}=data(idx2{i}==j,:);
    end
end
toc
%%
dataCluSquare.k1 = k1;
dataCluSquare.k2 = k2;
dataCluSquare.idx1 = idx1;
dataCluSquare.C1 = C1;
dataCluSquare.idx2 = idx2;
dataCluSquare.C2 = C2;
dataCluSquare.featureTr = SubSubset.featureTr;
dataCluSquare.illSet8Tr_nor = SubSubset.illSet8Tr_nor;
dataCluSquare.gtIllumTr = SubSubset.gtIllumTr;
% dataCluSquare.tt1 = SubSubset.tt1;
% dataCluSquare.tt2 = SubSubset.tt2;
dataCluSquare.Subset = Subset;