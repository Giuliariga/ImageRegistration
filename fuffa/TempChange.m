% % %analyze changes caused be increase temperature
 
% clear all
%  
%Get the measurement image file info
% [stackfile, stackfolder] = uigetfile('*.*', 'Select the TIFF image stack (multicolor)');
% tifFile= [stackfolder filesep stackfile];
% 
% %Get the mirror image file info
% [file, folder] = uigetfile('*.*', 'Select the mirror file (TIFF image stack also)');
% mirFile= [folder filesep file];
% 
% 
% % % %load the first image to get the self-reference region
% f = figure('Name', 'Please select a region of bare Si');
% im = imread(tifFile, 1);
% [~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
% pause(0.01); % so the window can close
% close(f);
% % % 
out = inputdlg('Number of images in the stack file');
numIm = str2num(out{1});
% % % % % % %   
% % % % %%Load first image and normalize. Load dry chip image and normalize
mir= imread(mirFile,1);
I = imread(tifFile,1);
In = double(I)./double(mir);
sRef = imcrop(In, selfRefRegion);
data1 = In./median(sRef(:));
% %========================

align(:,:,1)=data1;
for channel = 2:numIm
   I = imread(tifFile, channel);
   In = double(I)./double(mir);
   sRef = imcrop(In, selfRefRegion);
   data = In./median(sRef(:));
   Ial=data;
   %[Ial,delta,angle]=regWet(data,data1);  
   align(:,:,channel)=Ial; 
   
end

% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 dataOr=data1; 
% % % % dataFilt= imfilter(dataOr,F_mean);
 numSpots=inputdlg('How many regions do you want to analyze?');
 numSpots=str2num(numSpots{1});
 %numSpots = 2;
 numSpots=numSpots+1;
% % % 
 for n = 1:numSpots
	g = figure;     
    g= figure('Name', 'Select first a region of oxide and then the regions of the background');
    [spotR, spotRect(n,:)] = imcrop(data1, median(double(data1(:)))*[.8, 1.2]); 
	pause(0.05);
 	close(g);
 end
% % % 
  for channel= 1:numIm
   %crop the circle and the annulus
      col=align(:,:,channel);
      spotO=imcrop(col,spotRect(1,:));
      figure; imshow(spotO);
      oxidebluVal(channel)=median(spotO(:));
      for n=2:numSpots
      spotB=imcrop(col,spotRect(numSpots,:));
      figure; imshow(spotB);
      backbluVal(numSpots,channel)=median(spotB(:));
     
      end
 end
% % %==================================================================
% % %uncomment this if you want to measure the value of the
% % %oxideRegion(select oxide region as spot)
% 
%   O=oxidebluVal;
%   filename=('oxideBlu');
%   xlswrite(filename,O);
% 
%   B=backbluVal;
%   filename=('backBlu');
%   xlswrite(filename,B);

