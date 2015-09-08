clear all

% Get the measurement image file info
[stackfile, stackfolder] = uigetfile('*.*', 'Select the TIFF image stack (multicolor)');
tifFile= [stackfolder filesep stackfile];

% Get the mirror image file info
[file, folder] = uigetfile('*.*', 'Select the mirror file (TIFF image stack also)');
mirFile= [folder filesep file];

f = figure('Name', 'Please select a region of bare Si');
im = imread(tifFile,1);
[~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
pause(0.01); % so the window can close
close(f);

out = inputdlg('Number of images in the stack file');
numIm = str2num(out{1});
%%%============================================================================ 
%%% normalize the first image of the stack
mir= imread(mirFile,1);
I = imread(tifFile,1);
In = double(I)./double(mir);
sRef = imcrop(In, selfRefRegion);
data1 = In./median(sRef(:));
align(:,:,1)=data1;

% %%%=======================================================================
for channel = 2:numIm
   I = imread(tifFile, channel);
   In = double(I)./double(mir);
   sRef = imcrop(In, selfRefRegion);
   data = In./median(sRef(:));
   [Ial,delta(channel,:),angle(channel)]=regWet(Ial1,data);
   align(:,:,channel)=Ial;  
end

