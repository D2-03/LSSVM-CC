function est_ill = testing_clu2anfis_rgb (data_test, model,opt)
%%
if nargin<2
    opt=genCNCOptions();
end
%% init
featureTr = data_test.featureTr;
illSet8Tr_nor = data_test.illSet8Tr_nor;
gtIllumTr = data_test.gtIllumTr;
adjacentAngleError= data_test.adjacentAngleError;
% tt1 = data_test.tt1;
% tt2 = data_test.tt2;
N = size(featureTr,1);
%% locate the position of (iRegion,jCluster)
ijDataTest = zeros(N,2);
for i=1:N
    featureFirst = data_test.(opt.cluster1Feature)(i,:);
    featureSecond = data_test.(opt.cluster2Feature)(i,:);
    [iClus,jClus] = locateRegionIJ(featureFirst,featureSecond,model);
    ijDataTest(i,1)=iClus;
    ijDataTest(i,2)=jClus;
end
%% datin
IF=zeros(N,16);
for i=1:N
    IFmatrix_i =illSet8Tr_nor{i, 1};
    IF(i,:)=reshape(IFmatrix_i(:,1:2)',1,[]);
    datin(i,:) = IF(i,model.inputlocation{ijDataTest(i,1),ijDataTest(i,2)});
end
%% predict
est_ill = zeros(N,3);
for i=1:N
    est_ill(i,:) = simlssvm(model.model{ijDataTest(i,1),ijDataTest(i,2)},datin(i,:));
end
est_ill = est_ill./repmat(sum(est_ill, 2), 1, 3);

%%
% [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]= ...
%     calculateExtendedAngularStatistics(data_test.gtIllumTr(468:568,:), est_ill(468:568,:));
% displayCalculatedAngularErrorStatistics(minAngle, meanAngle,...
%     medianAngle, trimeanAngle, best25, worst25, average, maxAngle);
    
