%%%%
%%%Image rotation 
%%%I want to rotate Im to be the same as dry
function [Imrot,angle]=rotation(dry,Im);
pi=-2:0.1:2;
row=length(Im(:,1));
col=length(Im(1,:));
dry=double(dry);
Im=double(Im);
Imrot=zeros(row,col,length(pi));
for i=1:length(pi)
    rot=imrotate(Im,pi(i),'crop');
    Irot(:,:,i)=rot; 
    err(:,:,i)=sqrt((rot-dry).^2);
    error=err(:,:,i);
    errc(i)=sum(error(:));
end
index=find(errc==min(errc));
angle=pi(index);
Imrot=imrotate(Im,pi(index),'crop');


 