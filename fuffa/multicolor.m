function [align]=multicolor(tifFile,mirFile,dryFile,color);

f = figure('Name', 'Please select a region of bare Si');
im = imread(tifFile, color);
[~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
pause(0.01); % so the window can close
close(f);
% % % % % 
out = inputdlg('Number of images in the stack file');
numIm = str2num(out{1});
%%============================================================================ mir= imread(mirFile,color);
dry= imread(dryFile,1);
mir= imread(mirFile,1);
I = imread(tifFile,color);
In = double(I)./double(mir);
sRef = imcrop(In, selfRefRegion);
data1 = In./median(sRef(:));

%%=======================================================================

f = figure('Name', 'Select a region with the oxide edge');
[dryReg,dryCord]=imcrop(dry,median(double(dry(:)))*[.8, 1.2]); 
delete(f);
l = figure('Name', 'Select the same region');
[wR,wC]=imcrop(I,median(double(I(:)))*[.8 1.2]);
delete(l);
[dataReg,dataCord]=imcrop(I,[wC(1) wC(2) dryCord(3) dryCord(4)]);
[Ial1,theta]=houghl(dryReg,dataReg,dryCord,dataCord,data1);
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

align(:,:,1)=Ial1;
%%%=======================================================================
for channel = (color+4):4:(numIm*4)
   I = imread(tifFile, channel);
   In = double(I)./double(mir);
   sRef = imcrop(In, selfRefRegion);
   data = In./median(sRef(:));
   Ial=regWet(Ial1,data);
   align(:,:,((channel-color)/4)+1)=Ial;  
end


