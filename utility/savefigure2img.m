function savefigure2img(imgname)
%% ��ȡfigure����
frame = getframe(gcf);
%% תΪͼ��
im = frame2im(frame);
%% ����
imwrite(im,imgname);
end