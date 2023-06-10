function img = preproNUSImage(num,darkness_level)
%%
load('data\Canon1DsMkIII_gt.mat')
imagename = {'Canon1DsMkIII_0056.PNG','Canon1DsMkIII_0063.PNG','Canon1DsMkIII_0067.PNG','Canon1DsMkIII_0122.PNG'};
image = [56 63 67 122];
noLoc = image(num);

infileName = imagename{num};
img=imread(infileName);
maskOut = 1;
blackLevel=darkness_level;
saturationLevel=saturation_level;
img = (double(img) - blackLevel)/ (double(saturationLevel) - blackLevel);
img(img<0)=0;
m=zeros(size(img, 1), size(img, 2));

for ch=1:3
    m=m+double(img(:, :, ch)>=saturationLevel-blackLevel);
end

m=m>0;

CC_coords_roi = CC_coords(noLoc,:);

if (maskOut~=0)
    m(CC_coords_roi(1):CC_coords_roi(2),CC_coords_roi(3):CC_coords_roi(4))=1;
end

for ch=1:3
    channel=img(:, :, ch);
    channel(m)=0;
    img(:, :, ch)=channel;
end

end

