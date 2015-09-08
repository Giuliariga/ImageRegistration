%%This function provides to the alignment of the first wet image of the
%%stack to the dry one. First the angle of rotation is calculated thanks to line detection accomplished 
%%using the hough trasform. The user has to select a region of the chip cointaining a edge of the oxide in both images,
%%being carefull to select the same area. Then the transaltion(tx and ty) is calculated taking the distance 
%%between a point selected manually by the user in both the rotated wet image and
%%the dry one. The wet image is then translated and returned to the main
%%program

function [Ial1,theta,tx,ty,thetaDry]=regWetDry(dry,I,data1)

f = figure('Name', 'Select a region with the oxide edge');
[dryReg,dryCord]=imcrop(dry,median(double(dry(:)))*[.8, 1.2]); 
delete(f);
l = figure('Name', 'Select the same region');
[wR,wC]=imcrop(I,median(double(I(:)))*[.8 1.2]);
delete(l);
[dataReg,dataCord]=imcrop(I,[wC(1) wC(2) dryCord(3) dryCord(4)]);
[Ial1,theta,thetaDry]=houghl(dryReg,dataReg,dryCord,dataCord,data1);
%%%calulate the x y shift between the first image and the dry one
p=figure('Name', 'Select a distignuable point'); 
imshow(Ial1,median(double(Ial1(:)))*[.8, 1.2]);
h=impoint(gca);
pause(3);
pos=getPosition(h);
delete(p);
close(gcf);
k=figure('Name', 'Select the same point'); imshow(dry,median(double(dry(:)))*[.8, 1.2]);
g=impoint(gca);
pause(3);
posDry=getPosition(g);
delete(k);
close(gcf);

tx=posDry(1)-pos(1);
ty=posDry(2)-pos(2);
Ial1=imtranslate(Ial1,[ty tx]);
w=figure('Name','Dry Image');imshow(dry,median(double(dry(:)))*[.8, 1.2]);
z=figure('Name','Aligned Image');imshow(Ial1,median(double(Ial1(:)))*[.8, 1.2]);
Ial1=Ial1;

