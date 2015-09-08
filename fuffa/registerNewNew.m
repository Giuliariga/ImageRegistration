%%%%%alignment of first image with dry image

function [Imrot]=registerNew(dryRegion,dataRegion,dryC,dataC,data1);
dryRegion=imadjust(dryReg);
dataRegion=imadjust(dataReg,[0.9 1],[]);
%%%make Binary
[m,n]=size(dataRegion);
%thresholding data (automatic thresholding doesn't work
for i=1:m
    for j=1:n
        if dataRegion<0.30
             dataRegb(i,j)=0;
         else
            dataRegb(i,j)=1;
        end 
        if dryRegion(a,b)<9000
            dryRegb(a,b)=0;
        else
            dryRegb(a,b)=1;
        end 
    end
end

imshowpair(dataRegb,dryRegb,'montage');
%rotate
for i=1:length(pi)
    rot=imrotate(dataRegb,pi(i),'crop');
    Irot(:,:,i)=rot; 
     %%%translate end calculate error
    [optimizer, metric] = imregconfig('monomodal');
    [error(i),dispx(i),dispy(i),DataAl]=imregisterMod(dataRegb,dryRegb,'translation',optimizer,metric);
end
minIndx=find(error==min(error));
teta=pi(i);
dx=dispx(i);
dy=dispy(i);

%
%%don't think it's correct, need to try
Imrot=imrotate(data1,teta,'crop');
dxtot=dx+abs(dryC(4)-dataC(4));
dytot=dy+abs(dryC(3)-dataC(3));
Imrot=imtranslate(Imrot,[dxtot,dytot]);
