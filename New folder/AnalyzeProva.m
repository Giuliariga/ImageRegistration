 clear all

%%% choose the kind of analysis you want to run
 flag=inputdlg('Do you want to analyze the spots (enter 0) or calculate the effect of temperature or etching(enter 1)?')
 flag=str2num(flag{1});
 
%%% Load the images

%%% Get the measurement image file info

[stackfile, stackfolder] = uigetfile('*.*', 'Select the TIFF image stack (multicolor)');
tifFile= [stackfolder filesep stackfile];

% %% Get the dried chip image
if flag==0
 [file, folder] = uigetfile('*.*', 'Select the dry chip file (TIFF image stack also)');
 dryFile= [folder filesep file]; 
 dry= imread(dryFile,1);
end
% 
% %% Get the mirror image file info

[file, folder] = uigetfile('*.*', 'Select the mirror file (TIFF image stack also)');
mirFile= [folder filesep file];
 
% %% Align the blue images and use the found values to align the others color
% 
color=1; %(blue)
f = figure('Name', 'Please select a region of bare Si');
im = imread(tifFile, color);
[~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
pause(0.01); % so the window can close
close(f);

nColor=inputdlg('How many colors have you used to acquire the images?');
nColor=str2num(nColor{1});
info=imfinfo(tifFile);
numIm=numel(info)/nColor;

mir= imread(mirFile,color);
I = imread(tifFile,color);
In = double(I)./double(mir);
sRef = imcrop(In, selfRefRegion);
data1 = In./median(sRef(:));
% 
% %===========================================================================================
% %% Align first image of the stack to the dry image
% 
if flag==0
 [Ial1,theta,tx,ty,thetaDry]=regWetDry(dry,I,data1);
 align(:,:,1,1)=Ial1;
 else
 align(:,:,1,1)=data1;
end
% 
% %% Align all the blue images in the stack to the first blue one
 for channel = (color+nColor):nColor:(numIm*nColor)
    I = imread(tifFile, channel);
    In = double(I)./double(mir);
    sRef = imcrop(In, selfRefRegion);
    data = In./median(sRef(:));
     if flag==0
       [Ial,delta(((channel-color)/nColor),:),angle(((channel-color)/nColor),:)]=regWet(Ial1,data);
     else
       [Ial,delta(((channel-color)/nColor),:),angle(((channel-color)/nColor),:)]=regWet(data1,data);
     end
       align(:,:,((channel-color)/nColor)+1,color)=Ial;  
 end 
   
% %% Align all the images(other three colors) using the found values.
% 
for color= 2:nColor
   I  = imread(tifFile, color);
   mir=imread(mirFile,color);
   In = double(I)./double(mir);
   sRef = imcrop(In, selfRefRegion);
   data = In./median(sRef(:));
   if flag==0
    temp=imrotate(data,theta,'crop');
    align(:,:,1,color)=imtranslate(temp,[ty tx]); 
   else
    align(:,:,1,color)=data;
   end
    for channel = (color+nColor):nColor:(numIm*nColor)
      I = imread(tifFile, channel);
      In = double(I)./double(mir);
      sRef = imcrop(In, selfRefRegion);
      data = In./median(sRef(:));
      temp2=imrotate(data,angle(((channel-color)/nColor),:),'crop');
      align(:,:,((channel-color)/nColor)+1,color)=imtranslate(temp2,-delta(((channel-color)/nColor),:));  
    end
end

%% Detect spots 
% 
 for color=1:nColor
     filt=boxcarAv(align(:,:,:,color));
  if color==1
     if flag==0;
        out = inputdlg('How many spots do you wish to analyze?', 'Number of spots', 1,{'1'});
        numSpots=str2num(out{1});
     end
      if flag==1
          out = inputdlg('How many region of the background do you want to analyze?');
          numSpots=str2num(out{1});
          numSpots=numSpots+1; %%regions of the background plus one region of oxide
      end    
    minimum=10;
    maximum=20;
    
     for n = 1:numSpots
         g = figure; 
          if flag==1
             if n==1
                  g=figure('Name','select first a region of the oxide');
             else      
                  g=figure('Name','Select a region of the background');
             end
             Icrop=align(:,:,1,1);
             [spotR, spotRect(n,:)] = imcrop(Icrop,median(double(Icrop(:)))*[.8, 1.2]); 
	         pause(0.05);
 	         close(g);
          end
        if flag==0
          [spotR, spotRect(n,:)] = imcrop(dry, median(double(dry(:)))*[.8, 1.2]); 
          pause(0.05);
          close(g);
          level=graythresh(spotR);
          binary=im2bw(spotR,level);
          [center,rad,minimum,maximum]= CircleDet(binary,n,minimum,maximum);
        end  
     end
  end

 %% Calculate spots and annulus values
 if flag==0
    for channel=1:numIm
%        for n=1:numSpots
%          [annulus.heights(n,channel,color),results.heights(n,channel,color)]=SpotCalProva(dry,filt(:,:,channel),center(n,:),rad(n),spotRect(n,:),n);
%        end
%%  prova passandogli tutti gli spot
         [annulus.heigths(channel,color),results.heights(channel,color)]= spotGrid(dry,filt(:,:,channel),center,rad,spotRect,spotR,channel,thetaDry);
    end
  end
 end

if flag==1 
    for color=1:nColor
       for channel=1:numIm
           col=align(:,:,channel,color);
           spotO=imcrop(col,spotRect(1,:));
           for n=1:numSpots
     spotB=imcrop(col,spotRect(n,:));
     figure; imshow(spotB);
     oxideVal(n,channel,color)=median(spotO(:));
     backVal(n,channel,color)=median(spotB(:));
           end
       end 
    end
end

%% Dispay and save the results.

% if flag==0
% 
% Diff=annulus.heights-results.heights;
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
% 
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
% end