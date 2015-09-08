%%%This function detect the spots overe a cropped region of the dry chip
%%%image, cntaining only one spot. The user helped by the imdistline tool
%%%calculate the radius of the spot and give to the program a range for the
%%spots radius (suggested: detected radius +-2). The circle detection is
%%provided by the function imfindcircles, based on hough transform.
%%The function returns the radius and the center of the spot.

function [centers,radii,minn,maxx]= CircleDet(data,n,minn,maxx)

if n==1
figure(5);
imshow(data,median(double(data(:)))*[.8 1.2]);

%%%detect the radius of one spot with imdistline
h=imdistline(gca);
position = wait(h);
asw = inputdlg('Maximum and minumum radius');
num=str2num(asw{1});
minn=num(1);
maxx=num(2);
delete(h);
close(gcf);
end 

%%%change the sensitivity if needed 

[centers, radii] = imfindcircles(data,[minn maxx],'ObjectPolarity','dark','Sensitivity',0.92,'Method','twostage');

%%%draw circles
figure(n+5);imshow(data,median(double(data(:)))*[0.8 1.2]);
h = viscircles(centers,radii);
centers=centers;
radii=radii;
minn=minn;
maxx=maxx;