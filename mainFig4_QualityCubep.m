%% Quality results for Cube+ dataset
% outdoor natural, outdoor artificial, indoor
% side bar indicating illum color
% (a) Input image; (b) ground truth (c) ours;
% (d)-(k) GW, GGW, WP, GE1, GE2, SOG, PCA, and LSR.

%%
clear;
clc;

%% init
data=load('dataTrainCubep.mat'); data=data.dataTrain;
result=load('resultOptimal_Cubep.mat'); result=result.result;

NoLoc=[368 660 1707 31 276 1248] + 568;
noLoc=NoLoc - 568;
N=size(noLoc,2);
QualityResults.Cubep.noLoc=noLoc;

%提取三张图像的光源估计值
for i=1:N
%     QualityResultsubep.g.Cubep.filesRaw{i,1}=data.filesTr{noLoc(1,i),1};
    QualityResults.Cubep.gtIllum(i,:)=data.gtIllumTr(noLoc(1,i),:);
    QualityResults.Cubep.ours(i,:)=result.est_ill_sort(noLoc(1,i),:);
    QualityResults.Cubep.gw(i,:)=data.gw(noLoc(1,i),:);
    QualityResults.Cubep.wp(i,:)=data.wp(noLoc(1,i),:);
%     QualityResults.Cubep.sog(i,:)=data.sog(noLoc(1,i),:);
%     QualityResults.Cubep.ge1(i,:)=data.ge1(noLoc(1,i),:);
    %QualityResults.Cubep.ge2(i,:)=data.ge2(noLoc(1,i),:);
    QualityResults.Cubep.pca(i,:)=data.pca(noLoc(1,i),:);
    %QualityResults.Cubep.ggw(i,:)=data.ggw(noLoc(1,i),:);
    QualityResults.Cubep.lsr(i,:)=data.lsr(noLoc(1,i),:);
    %QualityResults.Cubep.ANFIS(i,:)=gai567(noLoc(1,i),:);
end
%% render img to sRGB: gt;gw,wp,sog,ge1,ge2,pca,ggw,lsr
ffStr=cell(7,N);
A_sRGB=cell(7,N);
illuminant=ones(7,3,N); %
for i=1:N
    illuminant(1,:,i)=illuminant(1,:,i);
    illuminant(2,:,i)=QualityResults.Cubep.gtIllum(i,:);
    illuminant(3,:,i)=QualityResults.Cubep.ours(i,:);
    illuminant(4,:,i)=QualityResults.Cubep.gw(i,:);
    illuminant(5,:,i)=QualityResults.Cubep.wp(i,:);
%     illuminant(5,:,i)=QualityResults.Cubep.sog(i,:);
%     illuminant(6,:,i)=QualityResults.Cubep.ge1(i,:);
%     illuminant(8,:,i)=QualityResults.Cubep.ge2(i,:);
    illuminant(6,:,i)=QualityResults.Cubep.pca(i,:);
%     illuminant(10,:,i)=QualityResults.Cubep.ggw(i,:);
    illuminant(7,:,i)=QualityResults.Cubep.lsr(i,:);
    %
    ffStr{1,i}=fullfile('resultImg_Cube+/',['Cubep',num2str(noLoc(1,i)),'_1_in','.jpg']);
    ffStr{2,i}=fullfile('resultImg_Cube+/',['Cubep',num2str(noLoc(1,i)),'_2_gt','.jpg']);
    ffStr{3,i}=fullfile('resultImg_Cube+/',['Cubep',num2str(noLoc(1,i)),'_3_ours','.jpg']);
    ffStr{4,i}=fullfile('resultImg_Cube+/',['Cubep',num2str(noLoc(1,i)),'_4_gw','.jpg']);
    ffStr{5,i}=fullfile('resultImg_Cube+/',['Cubep',num2str(noLoc(1,i)),'_5_wp','.jpg']);
%     ffStr{5,i}=fullfile('resultImg','Cubep',['Cubep',num2str(noLoc(1,i)),'_5_sog','.jpg']);
%     ffStr{6,i}=fullfile('resultImg','Cubep',['Cubep',num2str(noLoc(1,i)),'_6_ge1','.jpg']);
%     ffStr{8,i}=fullfile('resultImg','Cubep',['Cubep',num2str(noLoc(1,i)),'_8_ge2','.jpg']);
    ffStr{6,i}=fullfile('resultImg_Cube+/',['Cubep',num2str(noLoc(1,i)),'_6_pca','.jpg']);
%     ffStr{10,i}=fullfile('resultImg','Cubep',['Cubep',num2str(noLoc(1,i)),'_A_ggw','.jpg']);
    ffStr{7,i}=fullfile('resultImg_Cube+/',['Cubep',num2str(noLoc(1,i)),'_7_lsr','.jpg']);
    %
    img = preprocCubepImg(NoLoc(1,i)-568);
    bright_srgb=brightsRGB(img);    
    A_sRGB{1,i} = lin2rgb(bright_srgb,'OutputType','double');
    for j=2:7
        A_sRGB{j,i}=correctColorBalance(bright_srgb,illuminant(j,:,i));
        A_sRGB{j,i} = tmpFunc_Cubep(A_sRGB{j,i});
    end
    %
    gt=illuminant(2,:,i);
    for j=1:7
        saveImgAndIllum(A_sRGB{j,i},illuminant(j,:,i),ffStr{j,i},gt,j);
    end
end
%% resulting fig
for k=1:N
    fileFolder = fullfile('resultImg_Cube+/');
    dirOutput = dir(fullfile(fileFolder,['Cubep' num2str(noLoc(1,k)) '*.jpg']));
    fileNames = string(fullfile({dirOutput.name}));
    for i=1:size(dirOutput,1)
        fileNames{i}=fullfile(fileFolder,fileNames{i});
    end
    %fileNames{i+1}=fullfile(fileFolder,'white.jpg');
    figure,montage(fileNames, 'Size', [1 7]);
    print(gcf,'-r1500','-djpeg',fullfile(fileFolder,['AAA_CP_' num2str(noLoc(1,k)) '.jpg']));
end
