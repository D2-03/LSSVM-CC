function [n0Vec,ncVecGSCubep,vgVec] = getColorNumOfGSCubep()
% load('dataTrain.mat')
% [n0Vec,ncVecGSCubep,vg] = getColorNumOfGSCubep();
% dataTrain.n0Vec=n0Vec;
% dataTrain.nc=ncVecGSCubep;
% dataTrain.vg=vg;
% save dataTrain dataTrain
% N=579; 
% N=5

in_image_dir = fullfile('D:\NUS8\dataset-nus\preNUS');
imds = imageDatastore(in_image_dir);
files = imds.Files;
N = length(files);
n0Vec=zeros(1,N);
ncVecGSCubep=zeros(1,N);
vgVec=zeros(1,N);


tic
for i = 1:N
    infileName = files{i};
    image = imread(infileName);
    img = double(image);

    %fn=dataTrain.filesTr{i,1};
%     if i<=568
%         img = proprocGehlerImg(i);
%     else
%         img=preprocCubepImg(i-568);
%     end


    
    n0=size(unique(reshape(img, [], 3), 'rows'), 1);
    n0Vec(i)=n0;
    
    ddd=fix(img*64/255);
    fff=unique(reshape(ddd, [], 3), 'rows');
    nc = size(fff, 1);
    ncVecGSCubep(i)= nc;
    
    dt = delaunayTriangulation(fff);
    [~, vg] = convexHull(dt);
    vgVec(i)=vg;
    
    display(['Now:', num2str(i),'/',num2str(N),', n0=',num2str(n0),', nc=',num2str(nc),', vg=',num2str(vg)]);
    toc
end

