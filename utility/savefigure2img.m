function savefigure2img(imgname)
%% 获取figure界面
frame = getframe(gcf);
%% 转为图像
im = frame2im(frame);
%% 保存
imwrite(im,imgname);
end