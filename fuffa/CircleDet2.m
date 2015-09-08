

function [centers,radii,min,max]= CircleDet(data,spotRect,n,min,max)

if n==1
figure
imshow(data,median(double(data(:)))*[.8 1.2]);

%%%detect the radius of one spot with imdistline
h=imdistline(gca);
api = iptgetapi(h);
fcn = makeConstrainToRectFcn('imline',get(gca,'XLim'),get(gca,'YLim'));
api.setDragConstraintFcn(fcn);
pause(10);
dist = getDistance(h);
dist=dist/2;
min=dist-5;
max=dist+5;
delete(h);
close(gcf);
end 

%%%change the sensitivity if needed 
%[centers, radii] = imfindcircles(data,[min max],'ObjectPolarity','dark', 'Sensitivity',0.95);
%%or: (try both)

[centers, radii] = imfindcircles(data,[min max],'ObjectPolarity','dark','Sensitivity',0.94,'Method','twostage');

%%%draw circles
imshow(rect,median(double(data(:)))*[0.8 1.2]);
h = viscircles(centers,radii);
%rect=rect;
centers=centers;
radii=radii;
min=min;
max=max;