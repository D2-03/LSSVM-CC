function ijDataTest = ijOfDataTest (data_test, model,opt)
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


    
