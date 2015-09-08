%%align two wet images one to each other. 
%%The function tries different angles,rotate one of the two images,and for each angle  calculate the
%%translation  of this image repect the other one.The phase
%%correlation function returns the quality value q The angle corresponding to the
%%best q value is selected and the image to align is rotated and translated
%%by the amount calculated by the phase correlation function.

function [Ial,delta,bestAngle]=regWet(d,w)

%%change the range of the angle if you think the rotation could be bigger. 
%%increase the step to speed up the process
angs = -1.5:.1:1.5;
dRotated = zeros(size(w,1), size(w,2),length(angs));
qq = zeros(1,length(angs));
for n = 1:length(angs)
	tempD = imrotate(double(w),angs(n), 'crop');
	tempD(tempD==0) = median(tempD(:));
% ==============================================================
% X,Y alignment with Phase Correlation (no rotation)
    [delta(n,:),q] = phCorrAlign(tempD, double(d));
	qq(n) = q;  
% ==============================================================      
end

%%%Align image
bestIdx = find(qq==max(qq), 1);
bestAngle = angs(bestIdx);
Ial=imrotate(double(w),bestAngle,'crop');
Ial=imtranslate(Ial,-delta(bestIdx,:));
%%%%Check the alignment
%figure; imshow(double(Ial)+double(d), []);
delta=delta(bestIdx,:);