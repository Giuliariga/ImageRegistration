%%%%%alignment of first image with dry image

function [Iout,bestAngle,txt,tyt,delta,bestIdx]=reg(d,w,dryC,dataC,data1);
% dryRegion=imadjust(dryReg);
% dataRegion=imadjust(dataReg,[0.9 1],[]);
%rotate
angs = -3:.1:3;
dRotated = zeros(size(d,1), size(d,2),length(angs));
qq = zeros(1,length(angs));
for n = 1:length(angs)
	tempD = imrotate(double(w),angs(n), 'crop');
	tempD(tempD==0) = median(tempD(:));

% ==============================================================
% X,Y alignment with Phase Correlation (no rotation)
	[delta(n,:),q] = phCorrAlign(double(d),tempD);
	qq(n) = q;
% ==============================================================
% Check the alignment

	dTrans = imtranslate(double(w), -1*delta(n,:));
	%figure; imshow(double(dTrans)+double(d), []);
end

bestIdx = find(qq==max(qq), 1);
bestAngle = angs(bestIdx);

tx=delta(bestIdx,1);
ty=delta(bestIdx,2);

Iout=imrotate(data1,bestAngle,'crop');
txt=round((dataC(2)-dryC(2))+tx);
tyt=round((dataC(1)-dryC(1))+ty);
%Ioutcrop=imrotate(data1,bestAngle,'crop');
% [h,w]=size(Iout);
% [v,z]=size(Ioutcrop);
% diffx=(w-z)/2;
% diffy=(h-v)/2;
% txtot=round(tx+(dataC(2)-dryC(2)));%-diffx);
% tytot=round(ty+(dataC(1)-dryC(1)));%-diffy;
 Iout=imtranslate(Iout,[-txt -tyt]);
% Arad=(bestAngle+pi)/180;
% tform=affine2d([cos(Arad) sin(Arad) 0;-sin(Arad) cos(Arad) 0; txtot tytot 1]);
% Iout=imwarp(data1,tform);

 

%%don't think it's correct, need to try

%  txtot=tx+abs(dryC(4)-dataC(4));
