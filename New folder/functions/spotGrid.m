 function [annBlueVal,spotblueval]= spotGrid(dry,filt,center,rad,spotRect,spotR,n,thetaDry)
%%% if is the first time the function is called, detect false positive
%%% spots detected, otherwise directly analyze the spots values.
if n==1
    
rep=length(rad);
region=imcrop(dry,spotRect);
row=inputdlg('How many row of spots are on the chip?');
row=str2num(row{1});
col=inputdlg('how many column of spots are on the chip?');
col=str2num(col{1});

radAv=mean(rad);
%% save in posDry the coordinates of the first row spots
 
for z=1:(col+1) 
     if z==col+1
      p=figure('Name','Select the center of the first spot of the second row')
     else
      p=figure('Name', 'Select the center of each spot of the first row'); 
     end 
    imshow(spotR,median(double(spotR(:)))*[0.8 1.2]);
    g=impoint(gca);
    pause(3);
    posDry(z,:)=getPosition(g);
    delete(p);
    close(gcf);
end
% 
% %% distance in heights between spot of the same column
p1=posDry(1,:);
p2=posDry(col+1,:);
distx=p2(1)-p1(1);
disty=p2(2)-p1(2);
% 
% %% create the grid
% 
for i=1:col
    %% coordinates of the spots on the other rows
    totx(i,:)=posDry(i,1)'+[0:distx:distx*(col-1)];
    toty(i,:)=posDry(i,2)'+[0:disty:disty*(col-1)];
end

totx=totx';
toty=toty';
coord.x=round(totx);
coord.y=round(toty);
cInt=round(center);
% 
% %% show the grid (center of the estimated position of the spots).
figure;imshow(spotR,median(double(spotR(:)))*[0.8 1.2]);
hold on
plot(totx,toty,'o');

%%%========================================================================
ind.x=zeros(row,col);
ind.y=zeros(row,col);

range=round(mean(rad)*1.5);

for z=1:length(center);  
     xC=cInt(z,1);
     yC=cInt(z,2);
         for r=1:row
            for c=1:col
                x=coord.x(r,c);
                y=coord.y(r,c);
                if (xC<x+range&&xC>x-range&&yC<y+range&&yC>y-range)==1
                   flag(r,c,z)=1;
                else
                    flag(r,c,z)=0;
                end
           end
         end 
       if (find(flag(:,:,z)==1))~=0
           log(z)=1;
       else
           log(z)=0;
       end

end

%% Delete "false positives", spots detected where there's no actual spot.
idxF=find(log==0);
centerOld=center;
center(idxF,:)=[];
radOld=rad;
rad(idxF,:)=[];
end


for  k=1:length(rad)
     c = spotRect(1);
     r = spotRect(2);
     roOuter=rad*2;
     center(:,1)=center(:,1)+spotRect(1);
     center(:,2)=center(:,2)+spotRect(2);
        
     [rr,cc]= meshgrid(1:size(col,1), 1:size(col,2));
     Rs = (rr - center(2)).^2 + (cc - center(1)).^2 < (rad).^2;
     Ran = ( (rr - center(2)).^2 + (cc - center(1)).^2 > (rad).^2 ) &...
            ( (rr - center(2)).^2 + (cc - center(1)).^2 < (roOuter).^2 );
     
     Rs=Rs';
     Ran=Ran';
   	 temp= col.*Rs;
  	 Vs = temp( temp ~= 0);
     spotblueval = median(Vs);
     figure(n);
     imshow(temp);
     temp2 = col.*Ran;
     Van = temp2( temp2~= 0);
   	 annBlueVal= median(Van);
     figure(n+1);
     imshow(temp2);
     
end
 end