 clear all
 
 % Get the measurement image file info
[stackfile, stackfolder] = uigetfile('*.*', 'Select the TIFF image stack (multicolor)');
tifFile= [stackfolder filesep stackfile];

%Get the mirror image file info
[file, folder] = uigetfile('*.*', 'Select the mirror file (TIFF image stack also)');
mirFile= [folder filesep file];
% 
% %%get the dried chip image
[file, folder] = uigetfile('*.*', 'Select the dry chip file (TIFF image stack also)');
dryFile= [folder filesep file];

% % %load the first image to get the self-reference region
f = figure('Name', 'Please select a region of bare Si');
im = imread(tifFile, 1);
[~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
pause(0.01); % so the window can close
close(f);

out = inputdlg('Number of images in the stack file');
numIm = str2num(out{1});
% %   
%%Load first image and normalize. Load dry chip image and normalize
mir = imread(mirFile,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%align all the images(all to the dry chip image)
%%%align first image to dry image and then all image to the first

I = imread(tifFile,1);
In = double(I)./double(mir);
sRef = imcrop(In, selfRefRegion);
data1 = In./median(sRef(:));
[dryReg,dryCord]=imcrop(dry,median(double(dry(:)))*[.8, 1.2]); 
[dataReg,dataCord]=imcrop(data1,median(double(data1(:)))*[.8, 1.2]);
Im1rot=rotation(dry,data1);   %%%%align first stack image to dry chip image
[dryReg,dryRect]=imcrop(dry, median(double(dry(:)))*[.8 1.2]);
[dataReg,dataRect]=imcrop(data1, median(double(data1(:)))*[.8 1.2]);


% for channel = 2:numIm
% 	I = imread(tifFile, channel);
%     In = double(I)./double(mir);
%     sRef = imcrop(In, selfRefRegion);
% 	data = In./median(sRef(:));
%     Irot=Registration(data,data1);  %%% align all images to the first one
%     [disp,q]=phCorrAlign(Irot,Im1rot);
%     Ial=imtranslate(Irot,disp); 
%     align(:,:,channel)=Ial;  
% end
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  dataOr=data1; 
%  F_mean = fspecial('average',5); 
% % % % % dataFilt= imfilter(dataOr,F_mean);
%  out = inputdlg('How many spots do you wish to analyze?', 'Number of spots', 1,{'1'});
%  numSpots = str2num(out{1});
% %   
% % %%%two possibilities, maybe giving the whole dry image and detecting all the
% % %%%spots togheter(?)
% 
% % %%  in each image analyze a region of the chip outside the spot 
%  min=10;
%  max=20;
% % 
%  for n = 1:numSpots
% 	g = figure;     
%     [spotR, spotRect(n,:)] = imcrop(dry, median(double(dry(:)))*[.8, 1.2]); 
% 	pause(0.05);
%  	close(g);
% %%Apply threshold
%     level=graythresh(spotR);
%     binary=im2bw(spotR,level);
%     [center(n,:),rad(n),min,max]= CircleDet(binary,spotRect(n,:),n,min,max);
%  end
% % % % 
%  for channel= 1:numIm
%    for n=1:numSpots
% % 	%crop the circle and the annulus
%       col=align(:,:,channel);
%       col= imfilter(col,F_mean);
%       spot=imcrop(col,spotRect(n,:));
%       c = spotRect(n,1);
% 	  r = spotRect(n,2);
% 	  rs = min(spotRect(n,3:4)/2);
% 	  roOuter = rad(n)+rs;
%       [rr, cc] = meshgrid(1:size(spot,1), 1:size(spot,2));
%    
% 	  Rs = (rr - center(n,1)).^2 + (cc - center(n,2)).^2 < (rad(n)).^2;
%       Ran = ( (rr - center(n,1)).^2 + (cc - center(n,2)).^2 > (rad(n)).^2 ) &...
%             ( (rr - center(n,1)).^2 + (cc - center(n,2)).^2 < (roOuter).^2 );
%       
%       Rs = Rs';
%       Ran = Ran';
%    	%%get the average value for each region
%     temp = spot.*Ran;
%     Van = temp( temp ~= 0);
%  	annBlueVal= median(Van);
% % 
% 	temp2 = spot.*Rs;
% 	Vs = temp( temp ~= 0);
%     spotblueval = median(Vs);
%     results.heights(n,channel) =spotblueval;
%     annulus.heights(n,channel)= annBlueVal;
% % % %   
%  end
%  end
% Diff=annulus.heights-results.heights;
% 
% % 
% % %save data
% S=Diff;
% filename=('Diff.xlsx');
% xlswrite(filename,S);
% R=results.heights;
% filename=('Res.xlsx');
% xlswrite(filename,R);
% A=annulus.heights;
% filename=('Ann.xlsx');
% xlswrite(filename,R);
% 
% % 
% % 
% % %plotfit and delete outliers
% xdata= 1:1:length(Diff(1,:));
% %
% for n=1:numSpots
% fitResults = polyfit(xdata,Diff(n,:), 7);
% %Evaluate polynomial
% yplot = polyval(fitResults,xdata);
% dist=abs(yplot-Diff(n,:));
% mi=min(Diff(n,:));
% ma=max(Diff(n,:));
% J=find(dist>(ma-mi)/10);
% ind(n,1:length(J))=J;
% DiffnOutrow=Diff(n,:);
%  
% %%substitution of outliers. 
% %%for mut chip(june exp)
% % % a=DiffnOutrow(25:30);
% % % b=DiffnOutrow(44:49);
% % % c=cat(2,a,b);
% % %  DiffnOutrow(31:43)=mean(c);
% % %%% 
% 
% for j=1:length(J)
%      if J(j)>10 && J(j)<(length(DiffnOutrow)-10)
% DiffnOutrow(J(j))=mean(DiffnOutrow(J(j)-10:J(j)+10));
%      else
%          if J(j)<10 
%          DiffnOutrow(J(j))=mean(DiffnOutrow((J(j)-(J(j)-1)):(J(j)+10)));
%          end
%          if J(j)>length(DiffnOutrow)-10
%           DiffnOutrow(J(j))=mean(DiffnOutrow((J(j)-10:(J(j)+(length(DiffnOutrow)-J(j))))));   
%          end 
%      end
% end
% % 
% figure(n)
% h=plot(DiffnOutrow,'o');
%  name=num2str(n);
% saveas(h,name,'fig');
% saveas(h,name,'tiff');
% % % % %figure(n+6)
% % % % %fitLine1 = plot(xdata,yplot,'DisplayName','7thGrade','Parent')
%  end
% % % % %  
% IND=ind;
% filename=('IndOut.xlsx');
% xlswrite(filename,IND);
