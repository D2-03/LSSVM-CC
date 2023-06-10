function ca=getAdjacentAngleError(dataTrain)
% ca=getAdjacentAngleError(dataTrain); size(ca)
%%
a = size(dataTrain.gtIllumTr,1);
ca=zeros(a,28);
for num=1:a
    e=zeros(8,3);
    for i=1:8
        e(i,:)=dataTrain.illSet8Tr_nor{num,1}(i,:);
    end
    ca_row=[];
    for i=1:7
        for j=i+1:8
            ca_row=[ca_row colorangle(e(i,:),e(j,:))];
        end
    end
    ca(num,:)=ca_row;
end
