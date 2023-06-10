% function saveImgAndIllum(A_sRGB,illuminant,imgFullfile,gt,bShowInfo)
% %%
% % illuminant=QualityResults.GehlerShi.gtIllum(i,:);
% % imgFullfile=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(i),'_gt','.jpg']);
% strLabel={'a) input','b) gt','c) ours: ','d) GW: ','e) WP: ','f)PCA: ','g) LSR: '};
% % if bShowInfo>2
% %     dot = colorangle(illuminant,gt);
% % end
% figure,
% %set(gca,'looseInset',[0 0 0 0])
% %set(gca,'LooseInset',get(gca,'TightInset'))
% 
% imshow(A_sRGB,'border','tight');
% % text(276,1620,num2str(dot),'horiz','center','color','m','FontSize',60,'FontName','FixedWidth');
% if bShowInfo>2
%     dot = colorangle(illuminant,gt);
%     dott = roundn(dot,-2);
%     text(700,700,num2str(dott),'horiz','center','color','r','FontSize',100,'FontName','FixedWidth');
% 
%     %colormap(illuminant);colorbar; set(colorbar,'Ticks',[]);
%     %title(['\fontsize{20}', strLabel{bShowInfo}, '\gamma = ',num2str(colorangle(illuminant,gt)),'\circ']);
% %else
%     %colormap(gt);colorbar; set(colorbar,'Ticks',[]);
%     
%     %title(['\fontsize{20}',strLabel{bShowInfo}]);
% end
% savefigure2img(imgFullfile);
% close




function saveImgAndIllum(A_sRGB,illuminant,imgFullfile,gt,bShowInfo)
%%
% illuminant=QualityResults.GehlerShi.gtIllum(i,:);
% imgFullfile=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(i),'_gt','.jpg']);
strLabel={'a) input','b) gt','c) ours: ','d) GW: ','e) WP: ','f)PCA: ','g) LSR: '};
figure,
imshow(A_sRGB);
if bShowInfo>2
    colormap(illuminant);colorbar; set(colorbar,'Ticks',[]);
    title(['\fontsize{32}', strLabel{bShowInfo}, '\gamma = ',num2str(colorangle(illuminant,gt)),'\circ']);
else
    colormap(gt);colorbar; set(colorbar,'Ticks',[]);
    
    title(['\fontsize{32}',strLabel{bShowInfo}]);
end
savefigure2img(imgFullfile);
close