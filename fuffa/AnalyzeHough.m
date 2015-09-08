%  clear all

%%%% Get the measurement image file info
% [stackfile, stackfolder] = uigetfile('*.*', 'Select the TIFF image stack (multicolor)');
% tifFile= [stackfolder filesep stackfile];
% % % % % % % 
% % % %%%% Get the dried chip image
%  [file, folder] = uigetfile('*.*', 'Select the dry chip file (TIFF image stack also)');
%  dryFile= [folder filesep file]; 
% %%%
% %%%%Get the mirror image file info
%  [file, folder] = uigetfile('*.*', 'Select the mirror file (TIFF image stack also)');
%  mirFile= [folder filesep file];
% %%% =========================================================================
% mynumber = inputdlg('Enter 0 if ImageStack is multicolor, 1 otherwise');
% mynumber=str2num(mynumber{1});
% 
% %  switch mynumber
% % case 0
% %         out = inputdlg('Choose the color to analyze(1=blue,2=green,3=orange,4=red)');
% %         color = str2num(out{1});
% %         [align]=multicolor(tifFile,mirFile,dryFile,color);
% % case 1
%        
% %%%=================================================================================
% % % % % % %load the first image to get the self-reference region
% f = figure('Name', 'Please select a region of bare Si');
% im = imread(tifFile, 1);
% [~, selfRefRegion] = imcrop(im, median(double(im(:)))*[.8 1.2]);
% pause(0.01); % so the window can close
% close(f);
% % % % 
% out = inputdlg('Number of images in the stack file');
% numIm = str2num(out{1});
% % 
% mir= imread(mirFile,1);
% dry= imread(dryFile,1);
% I = imread(tifFile,1);
% % % %%========================================================================== 
% % % % % %%%align all the images(all to the dry chip image)
% % % 
% In = double(I)./double(mir);
% sRef = imcrop(In, selfRefRegion);
% data1 = In./median(sRef(:));


h=figure('Name','Select a region with the oxide edge');
[dryReg,dryCord]=imcrop(dry,median(double(dry(:)))*[.8, 1.2]); 
g=figure('Name','Select the same region');
[wR,wC]=imcrop(I,median(double(I(:)))*[.8 1.2]);
[dataReg,dataCord]=imcrop(I,[wC(1) wC(2) dryCord(3) dryCord(4)]);
close(g); 
close(h);
[Ial1,theta]=houghl(dryReg,dataReg,dryCord,dataCord,data1);


p=figure('Name', 'Select a distinguable point'); 
imshow(Ial1,median(double(Ial1(:)))*[.8, 1.2]);
h=impoint(gca);
pause(0.01);
pos=getPosition(h);
close(p);
close(gcf);
k=figure('Name', 'Select the same point'); imshow(dry,median(double(dry(:)))*[.8, 1.2]);
g=impoint(gca);
pause(0.01);
posDry=getPosition(g);
close(k);
close(gcf);

tx=posDry(1)-pos(1);
ty=posDry(2)-pos(2);
Ial=imtranslate(Ial1,[ty tx]);
figure(3);imshow(dry,median(double(dry(:)))*[.8, 1.2]);
figure(4);imshow(Ial,median(double(Ial(:)))*[.8, 1.2]);
% % % % 
% % % % %
% align(:,:,1)=Ial1;
% 
% for channel = 2:numIm
%     Ic = imread(tifFile,channel);
%     Ic = double(Ic)./double(mir);
%     sRef = imcrop(Ic, selfRefRegion);
%     data = Ic./median(sRef(:));
%     Ial=regWet(Ial1,data);
%     align(:,:,channel)=Ial;  
% end
%end
%%%========================================================================
%%boxcar averaging
% filt=boxcar(align);
% %%%========================================================================
 dataOr=data1; 
 out = inputdlg('How many spots do you wish to analyze?', 'Number of spots', 1,{'1'});
 minimum=10;
 maximum=20;
 numSpots=str2num(out{1});
 
 for n = 1:numSpots
  g = figure;     
  [spotR, spotRect(n,:)] = imcrop(dry, median(double(dry(:)))*[.8, 1.2]); 
  pause(0.05);
  close(g);
  level=graythresh(spotR);
  binary=im2bw(spotR,level);
  [center(n,:),rad(n),minimum,maximum]= CircleDet(binary,n,minimum,maximum);
 end

  for channel= 1:numIm
    for n=1:numSpots
%%	 crop the circle and the annulus
     col=filt(:,:,channel);
     spot=imcrop(col,spotRect(n,:));
     c = spotRect(n,1);
  	 r = spotRect(n,2);
	 roOuter(n)=rad(n)*2;
    
    [rr, cc] = meshgrid(1:size(spot,1), 1:size(spot,2));
    
  	Rs = (rr - center(n,1)).^2 + (cc - center(n,2)).^2 < (rad(n)).^2;
    Ran = ( (rr - center(n,1)).^2 + (cc - center(n,2)).^2 > (rad(n)).^2 ) &...
            ( (rr - center(n,1)).^2 + (cc - center(n,2)).^2 < (roOuter(n)).^2 );
      
     Rs = Rs';
     Ran = Ran';

     temp = spot.*Ran;
     Van = temp( temp ~= 0);
   	 annBlueVal= median(Van);

   	 temp= spot.*Rs;
  	 Vs = temp( temp ~= 0);
     spotblueval = median(Vs);
     results.heights(n,channel) =spotblueval;
     annulus.heights(n,channel)= annBlueVal;
  
    end
end
% 
Diff=annulus.heights-results.heights;
% % % 
% % 
% % % % %save data
% % S=Diff;
% % filename=('DiffBlue1.xlsx');
% % xlswrite(filename,S);
% % R=results.heights;
% % filename=('ResBlue1.xlsx');
% % xlswrite(filename,R);
% % A=annulus.heights;
% % filename=('AnnBlue1.xlsx');
% % xlswrite(filename,R);
% 
% 
% %==========================================================================
% %==========================================================================
% %==========================================================================
% % % % %plotfit and delete outliers
 %xdata= 1:1:length(Diff(1,:));
% % % %
 for n=1:numSpots
% % % % fitResults = polyfit(xdata,Diff(n,:), 7);
% % % % %Evaluate polynomial
% % % % yplot = polyval(fitResults,xdata);
% % % % dist=abs(yplot-Diff(n,:));
% % % % mi=min(Diff(n,:));
% % % % ma=max(Diff(n,:));
% % % % J=find(dist>(ma-mi)/10);
% % % % ind(n,1:length(J))=J;
% %DiffnOutrow=Diff(n,:);
% % %  
% % % %%substitution of outliers. 
% % % %%for mut chip(june exp)
% % % % % a=DiffnOutrow(25:30);
% % % % % b=DiffnOutrow(44:49);
% % % % % c=cat(2,a,b);
% % % % %  DiffnOutrow(31:43)=mean(c);
% % % % %%% 
% % % 
% % % % for j=1:length(J)
% % % %      if J(j)>10 && J(j)<(length(DiffnOutrow)-10)
% % % % DiffnOutrow(J(j))=mean(DiffnOutrow(J(j)-10:J(j)+10));
% % % %      else
% % % %          if J(j)<10 
% % % %          DiffnOutrow(J(j))=mean(DiffnOutrow((J(j)-(J(j)-1)):(J(j)+10)));
% % % %          end
% % % %          if J(j)>length(DiffnOutrow)-10
% % % %           DiffnOutrow(J(j))=mean(DiffnOutrow((J(j)-10:(J(j)+(length(DiffnOutrow)-J(j))))));   
% % % %          end 
% % % %      end
% % % % end
% % % % 
  figure(n+6)
  h=subplot(3,1,1);
  plot(results.heights(n,:),'o');
  g=subplot(3,1,2);
  plot(annulus.heights(n,:),'o');
  u=subplot(3,1,3);
  plot(Diff(n,:),'o');
  name=num2str(n);
  %saveas(h,name,'fig');
  saveas(h,name,'tiff');
%  
% % % % % % %figure(n+6)
% % % % % % %fitLine1 = plot(xdata,yplot,'DisplayName','7thGrade','Parent')
 end
% % % % % %  
% % % IND=ind;
% % % filename=('IndOut.xlsx');
% % % xlswrite(filename,IND);
