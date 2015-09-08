
function [Ial,dTheta,thetaDry]=hougl(dryReg,dataReg,dryCord,dataCord,data1)

dataRegOr=dataReg;
dryRegOr=dryReg;
dryRegOr=dryReg;
dataReg=imadjust(dataReg);
BW= edge(dataReg,'canny');

% f=figure('Name','data BW'); imshow(BW);
dryReg=imadjust(dryReg);
BWr=edge(dryReg,'canny');
% c=figure('Name','dry BW'); imshow(BWr);

[H,theta,rho] = hough(BW);
P= houghpeaks(H,5,'threshold',ceil(0.7*max(H(:))));

[Hr,thetar,rhor] = hough(BWr);
Pr = houghpeaks(Hr,5,'threshold',ceil(0.7*max(Hr(:))));

linesData= houghlines(BW,theta,rho,P,'FillGap',15,'Minlength',15);
linesDatar= houghlines(BWr,thetar,rhor,Pr,'FillGap',15,'Minlength',15);

%%=========================================================================
%%=====Data lines
figure(1); imshow(dataReg), hold on
max_len = 0;

for k = 1:length(linesData)
   xy = [linesData(k).point1; linesData(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(linesData(k).point1 - linesData(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');


%%=========================================================================
%%====Dry lines
figure(2);imshow(dryReg), hold on
max_len = 0;

for k = 1:length(linesDatar)
   xyr = [linesDatar(k).point1; linesDatar(k).point2];
   plot(xyr(:,1),xyr(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
  plot(xyr(1,1),xyr(1,2),'x','LineWidth',2,'Color','yellow');
  plot(xyr(2,1),xyr(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   lenr = norm(linesDatar(k).point1 - linesDatar(k).point2);
   if ( lenr > max_len)
      max_lenr = lenr;
      xy_longr = xyr;
   end
end

%% highlight the longest line segment
%%
plot(xy_longr(:,1),xy_longr(:,2),'LineWidth',2,'Color','red');
dTheta=linesData.theta-linesDatar.theta;
Ial=imrotate(data1,dTheta,'crop');
thetaDry=linesDatar.theta;
%dataRot=imrotate(dataReg,dTheta,'crop');

% figure(7)
% imshow(dataRot);
% dataRot(dataRot==0) = median(dataRot(:));
% [delta,q] = phCorrAlign(double(dryReg),dataRot);
% dTrans = imtranslate(dataRot,delta);
% figure(8);
% imshow(dTrans);
% tx=delta(1);
% ty=delta(2);
% txtot=round(tx+(dryCord(2)-dataCord(2)));
% tytot=round(ty+(dryCord(1)-dataCord(1)));
% data1Rot=imrotate(data1,dTheta,'crop');
% data1Rot(data1Rot==0) = median(data1Rot(:));
% Ial=imtranslate(data1Rot,[txtot,tytot]);



