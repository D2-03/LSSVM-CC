%%
clear;
clc;

%% init
data=load('dataTrainGS.mat'); data=data.dataTrain;
result=load('resultOptimal_GS.mat'); result=result.result;

noLoc=[109 245 180 139 74];
N=size(noLoc,2); % 3
QualityResults.GehlerShi.noLoc=noLoc;
%
for i=1:N
%     QualityResults.GehlerShi.filesRaw{i,1}=data.filesTr{noLoc(1,i),1};
    QualityResults.GehlerShi.gtIllum(i,:)=data.gtIllumTr(noLoc(1,i),:);
    QualityResults.GehlerShi.ours(i,:)=result.est_ill_sort(noLoc(1,i),:);
    QualityResults.GehlerShi.gw(i,:)=data.gw(noLoc(1,i),:);
    QualityResults.GehlerShi.wp(i,:)=data.wp(noLoc(1,i),:);
%     QualityResults.GehlerShi.sog(i,:)=data.sog(noLoc(1,i),:);
%     QualityResults.GehlerShi.ge1(i,:)=data.ge1(noLoc(1,i),:);
%     QualityResults.GehlerShi.ge2(i,:)=data.ge2(noLoc(1,i),:);
    QualityResults.GehlerShi.pca(i,:)=data.pca(noLoc(1,i),:);
%     QualityResults.GehlerShi.ggw(i,:)=data.ggw(noLoc(1,i),:);
    QualityResults.GehlerShi.lsr(i,:)=data.lsr(noLoc(1,i),:);
end
%% render img to sRGB color space for: gt;gw,wp,sog,ge1,ge2,pca,ggw,lsr
ffStr=cell(7,N);
A_sRGB=cell(7,N);
illuminant=ones(7,3,N); %
for i=1:N
    illuminant(1,:,i)=illuminant(1,:,i);
    illuminant(2,:,i)=QualityResults.GehlerShi.gtIllum(i,:);
    illuminant(3,:,i)=QualityResults.GehlerShi.ours(i,:);
    illuminant(4,:,i)=QualityResults.GehlerShi.gw(i,:);
    illuminant(5,:,i)=QualityResults.GehlerShi.wp(i,:);
%     illuminant(5,:,i)=QualityResults.GehlerShi.sog(i,:);
%     illuminant(6,:,i)=QualityResults.GehlerShi.ge1(i,:);
%     illuminant(8,:,i)=QualityResults.GehlerShi.ge2(i,:);
    illuminant(6,:,i)=QualityResults.GehlerShi.pca(i,:);
%     illuminant(10,:,i)=QualityResults.GehlerShi.ggw(i,:);
    illuminant(7,:,i)=QualityResults.GehlerShi.lsr(i,:);
    
    ffStr{1,i}=fullfile('resultImg_GS/',['Gehlershi',num2str(noLoc(1,i)),'_1_in','.jpg']);
    ffStr{2,i}=fullfile('resultImg_GS/',['Gehlershi',num2str(noLoc(1,i)),'_2_gt','.jpg']);
    ffStr{3,i}=fullfile('resultImg_GS/',['Gehlershi',num2str(noLoc(1,i)),'_3_ours','.jpg']);
    ffStr{4,i}=fullfile('resultImg_GS/',['Gehlershi',num2str(noLoc(1,i)),'_4_gw','.jpg']);
    ffStr{5,i}=fullfile('resultImg_GS/',['Gehlershi',num2str(noLoc(1,i)),'_5_wp','.jpg']);
%     ffStr{5,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(noLoc(1,i)),'_5_sog','.jpg']);
%     ffStr{6,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(noLoc(1,i)),'_6_ge1','.jpg']);
%     ffStr{8,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(noLoc(1,i)),'_8_ge2','.jpg']);
    ffStr{6,i}=fullfile('resultImg_GS/',['Gehlershi',num2str(noLoc(1,i)),'_6_pca','.jpg']);
%     ffStr{10,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(noLoc(1,i)),'_A_ggw','.jpg']);
    ffStr{7,i}=fullfile('resultImg_GS/',['Gehlershi',num2str(noLoc(1,i)),'_7_lsr','.jpg']);
    
    img = proprocGehlerImg(noLoc(1,i));
    bright_srgb=brightsRGB(img);    
    A_sRGB{1,i} = lin2rgb(bright_srgb,'OutputType','double');
    for j=2:7
        A_sRGB{j,i}=correctColorBalance(bright_srgb,illuminant(j,:,i));
        A_sRGB{j,i} = tmpFunc_GS(noLoc(1,i),A_sRGB{j,i});
    end
    %
    gt=illuminant(2,:,i);
    for j=1:7
        saveImgAndIllum(A_sRGB{j,i},illuminant(j,:,i),ffStr{j,i},gt,j);
    end
end
%% resulting fig 
for k=1:N
    fileFolder = fullfile('resultImg_GS/');
    dirOutput = dir(fullfile(fileFolder,['Gehlershi' num2str(noLoc(1,k)) '*.jpg']));
    fileNames = string(fullfile({dirOutput.name}));
    for i=1:size(dirOutput,1)
        fileNames{i}=fullfile(fileFolder,fileNames{i});
    end
    %fileNames{i+1}=fullfile(fileFolder,'white.jpg');
    figure,montage(fileNames, 'Size', [1 7]);
    print(gcf,'-r1500','-djpeg',fullfile(fileFolder,['AAA_GS_' num2str(noLoc(1,k)) '.jpg']));
end
