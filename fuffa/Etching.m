% % analyze changes caused be increase temperature

% %  clear all
% %  
% %Get the measurement image file info
[stackfile, stackfolder] = uigetfile('*.*', 'Select the TIFF image stack (lowest Temp)');
tifFile= [stackfolder filesep stackfile];
% 
%Get the mirror image file info
 [file, folder] = uigetfile('*.*', 'Select the mirror file');
 mirFile= [folder filesep file];
% % % 
% %Get the hyperstack image file info
 [hfile, hfolder] = uigetfile('*.*', 'Select the TIFF file(highest Temp)');
 hFile= [hfolder filesep hfile];
% %==============================================================================
out = inputdlg('Choose the color to analyze(1=blue,2=green,3=orange,4=red)');
color = str2num(out{1});
% %==============================================================================
% 
% % load the first image to get the self-reference region
f = figure('Name', 'Please select a region of bare Si');
im = imread(tifFile, color);
[~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
pause(0.01); % so the window can close
close(f);
% % % % % 
out = inputdlg('Number of images in the stack file');
numIm = str2num(out{1});
% % % % % % % %   
% % % % % % %%Load first image and normalize. Load dry chip image and normalize
 mir= imread(mirFile,color);
I = imread(tifFile,color);
In = double(I)./double(mir);
sRef = imcrop(In, selfRefRegion);
data1 = In./median(sRef(:));
% %===========================================================================

 align(:,:,1)=data1;
for channel = (color+4):4:(numIm*4)
   I = imread(hFile, channel);
   In = double(I)./double(mir);
   sRef = imcrop(In, selfRefRegion);
   data = In./median(sRef(:));
   Ial=data;
   [Ial,delta,angle]=regWet(data,data1);  
   align(:,:,((channel-color)/4)+1)=Ial;  
end

% % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 dataOr=data1; 
% % % % % dataFilt= imfilter(dataOr,F_mean);

 numSpots = 2;
%   

% % % 
 for n = 1:numSpots
	g = figure;     
    g= figure('Name', 'Select first a region of oxide and then a region of the background');
    [spotR, spotRect(n,:)] = imcrop(data1, median(double(data1(:)))*[.8, 1.2]); 
	pause(0.05);
 	close(g);
 end
% % % 
  for channel=1:numIm
   %crop the circle and the annulus
      col=align(:,:,channel);
      %col= imfilter(col,F_mean);
      spotO=imcrop(col,spotRect(1,:));
     % figure; imshow(spotO);
      spotB=imcrop(col,spotRect(2,:));
      figure; imshow(spotB);
      oxidebluVal(channel)=median(spotO(:));
      backbluVal(channel)=median(spotB(:));
 end
% %==================================================================

  O=oxidebluVal;
  filename=('OrangeOx');
  xlswrite(filename,O);
  
  B=backbluVal;
  filename=('OrangeB');
  xlswrite(filename,B);
