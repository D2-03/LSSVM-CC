clear;
clc;
%%
for i = 1:8
    eval(['load',' ','NUS',num2str(i),'GT','.mat'])
end

gtIllumTr = [NUS1GT;NUS2GT;NUS3GT;NUS4GT;NUS5GT;NUS6GT;NUS7GT;NUS8GT];

%%
gtIllumTr = gtIllumTr./sum(gtIllumTr,2);

%%
save gtIllumTr gtIllumTr

%%
althorithm = {'GW','WP','SOG','GE1','GE2','GGW','PCA','LSR'};
for i = 1:8
    eval(['load',' ','NUS',althorithm{i},'.mat'])
end
%%
illSet8Tr_nor = cell(1736,1);
illset = zeros(8,3);
for i = 1:1736
    illset(1,:) = NUSGW(i,:);
    illset(2,:) = NUSWP(i,:);
    illset(3,:) = NUSSOG(i,:);
    illset(4,:) = NUSGE1(i,:);
    illset(5,:) = NUSGE2(i,:);
    illset(6,:) = NUSPCA(i,:);
    illset(7,:) = NUSGGW(i,:);
    illset(8,:) = NUSLSR(i,:);
    illSet8Tr_nor{i,1} = illset;
end
