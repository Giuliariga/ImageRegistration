clear all

%% Load the images

%% Get the measurement image file info

[stackfile, stackfolder] = uigetfile('*.*', 'Select the TIFF image stack (multicolor)');
tifFile= [stackfolder filesep stackfile];

%% Get the dried chip image

[file, folder] = uigetfile('*.*', 'Select the dry chip file (TIFF image stack also)');
dryFile= [folder filesep file]; 

%% Get the mirror image file info

[file, folder] = uigetfile('*.*', 'Select the mirror file (TIFF image stack also)');
mirFile= [folder filesep file];

%% 
exp=inputdlg('Do you want to analyze the spots (enter 0) or calculate the effect of temperature or etching(enter 1)?')
exp=str2num(exp{1});

%% Align the blue images and use the found values to align the others color

color=1; %(blue)
f = figure('Name', 'Please select a region of bare Si');
im = imread(tifFile, color);
[~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
pause(0.01); % so the window can close
close(f);

info=imfinfo(tifFile);
numIm=numel(info)/4;

mir= imread(mirFile,color);
dry= imread(dryFile,1);
I = imread(tifFile,color);
In = double(I)./double(mir);
sRef = imcrop(In, selfRefRegion);
data1 = In./median(sRef(:));
% 
%===========================================================================================
%% Align first image of the stack to the dry image

Ial1=regWetDry(dry,I,data1);
align(:,:,1,1)=Ial1;

%% Align all the blue image in the stack to the first one

for channel = (color+4):4:(numIm*4)
   I = imread(tifFile, channel);
   In = double(I)./double(mir);
   sRef = imcrop(In, selfRefRegion);
   data = In./median(sRef(:));
   [Ial,delta(((channel-color)/4),:),angle(((channel-color)/4),:)]=regWet(Ial1,data);
   align(:,:,((channel-color)/4)+1,color)=Ial;  
end

%% Align all the images(other three color) using the found values.

for color= 2:4
   I  = imread(tifFile, color);
   In = double(I)./double(mir);
   sRef = imcrop(In, selfRefRegion);
   data = In./median(sRef(:));
   
    for channel = (color+4):4:(numIm*4)
      I = imread(tifFile, channel);
      In = double(I)./double(mir);
      sRef = imcrop(In, selfRefRegion);
      data = In./median(sRef(:));
      temp=imrotate(data,angle(((channel-color)/4),:),'crop');
      align(:,:,((channel-color)/4)+1,color)=imtranslate(temp,-delta(((channel-color)/4),:));  
    end
end

%% Detect spots 

for color=1:4
 filt=boxcar(align(:,:,:,color));
  if color==1
     if exp==0;
        out = inputdlg('How many spots do you wish to analyze?', 'Number of spots', 1,{'1'});
        numSpots=str2num(out{1});
     end
      if exp==1
          out = inputdlg('How many region of the background do you want to analyze?');
          numSpots=str2num(out{1});
      end    
    minimum=10;
    maximum=20;
    
     for n = 1:numSpots
         g = figure;     
          if exp==1
             if n==1
                  g=figure('Name','select first a region of the oxide');
             else      
                  g=figure('Name','Select the region of the background');
             end
             [spotR, spotRect(n,:)] = imcrop(data1, median(double(data1(:)))*[.8, 1.2]); 
	         pause(0.05);
 	         close(g);
          end
        if exp==0
          [spotR, spotRect(n,:)] = imcrop(dry, median(double(dry(:)))*[.8, 1.2]); 
          pause(0.05);
          close(g);
          level=graythresh(spotR);
          binary=im2bw(spotR,level);
          [center(n,:),rad(n),minimum,maximum]= CircleDet(binary,n,minimum,maximum);
       end  
     end
  end
 
 %% Calculate spots and annulus values
  if exp==0
    for channel=1:numIm
       for n=1:numSpots
         [annulus.heights(n,channel,color),results.heights(n,channel,color)]=SpotCal(dry,filt(:,:,channel),center(n,:),rad(n),spotRect(n,:));
       end
    end
  end
 end

if exp==1 
    for color=1:4
       for channel=1:numIm
           for n=1:numSpots
     col=align(:,:,channel,color);
     spotO=imcrop(col,spotRect(1,:));
     spotB=imcrop(col,spotRect(n,:));
     figure; imshow(spotB);
     oxideVal(n,channel,color)=median(spotO(:));
     backVal(n,channel,color)=median(spotB(:));
           end
       end 
    end
end

%% Dispay and save the results.

%if exp==0

%Diff=annulus.heights-results.heights;
% range=inputdlg('What is your temperature range? (min max)');
% range=str2num(range{1});
% low=range(1);
% high=range(2);
% step=inputdlg('What is the temperature step?');
% step=str2num(step{1});
% Temperature=low:step:high;
% % 
% for color=1:4
%     switch color
%       case 1 
%         c='Blue';
%       case 2 
%         c='Green';
%       case 3
%         c='Orange';
%       case 4
%         c='Red';
%     end
%     
%   S=Diff(:,:,color);
%   name=strcat(c,'Diff.xlsx');
%   xlswrite(name,S);
%   R=results.heights(:,:,color);
%   name=strcat(c,'Spots.xlsx');
%   xlswrite(name,R);
%   A=annulus.heights(:,:,color);
%   name=strcat(c,'Annulus.xlsx');
%   xlswrite(name,A);

%     for n=1:numSpots
%       figure(n)
%       h=subplot(3,1,1); 
%       plot(Temperature,results.heights(n,:,color),'o');ylabel('Spot');
%       subplot(3,1,2);
%       plot(Temperature,annulus.heights(n,:,color),'o');ylabel('Background ');
%       subplot(3,1,3);
%       plot(Temperature,Diff(n,:,color),'o');ylabel('Diff');xlabel('Temperature');
%       name=strcat(c,num2str(n));
%       saveas(h,name,'fig');
%      saveas(h,name,'tiff');
%    end
% end
% 
%  figure(n+1) 
%  g=subplot(3,1,1); 
%  plot(delta(:,1),'o'); ylabel('tx');
%  subplot(3,1,2);
%  plot(delta(:,2),'o');ylabel('ty');
%  subplot(3,1,3)
%  plot(angle);ylabel('angle');xlabel('Images');
%  name=strcat('alignment6');
%  saveas(g,name,'tiff');
%  saveas(g,name,'fig');
%end