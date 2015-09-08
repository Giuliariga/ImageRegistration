% [file, folder] = uigetfile('*.*', 'Select the tiff file (TIFF image stack also)');
% tifFile= [folder filesep file];
% % % % % 
% % % % % % %%get the dried chip image
% [file, folder] = uigetfile('*.*', 'Select the dry chip file (TIFF image stack also)');
% dryFile= [folder filesep file];
% 
% [file, folder] = uigetfile('*.*', 'Select the mirror file (TIFF image stack also)');
%  mirFile= [folder filesep file];
% % % % % 
% 
% mir=imread(mirFile,1);
% dry= imread(dryFile,1);
% I = imread(tifFile,1);
% f = figure('Name', 'Please select a region of bare Si');
% im = imread(tifFile, 1);
% [~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
% pause(0.01); % so the window can close
% close(f);
% In = double(I)./double(mir);
% sRef = imcrop(In, selfRefRegion);
% data1 = In./median(sRef(:));

[dryReg,dryCord]=imcrop(dry,median(double(dry(:)))*[.8, 1.2]); 
[wR,wC]=imcrop(data1,median(double(data1(:)))*[.8 1.2]);
[dataReg,dataCord]=imcrop(data1,[wC(1) wC(2) dryCord(3) dryCord(4)]);



%figure(2); imshow(dry,median(double(dry(:)))*[.8, 1.2]);