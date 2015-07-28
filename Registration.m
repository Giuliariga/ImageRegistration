function recovered=Registration(original,distorted);

ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);

[featuresOriginal,   validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
[featuresDistorted, validPtsDistorted]  = extractFeatures(distorted, ptsDistorted);

indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

% figure;
% showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted);
% title('Putatively matched points (including outliers)');

[tform,inlierDistorted,inlierOriginal]=estimateGeometricTransform(matchedDistorted, matchedOriginal, 'similarity');

Tinv=tform.invert.T;

ss=Tinv(2,1);
sc=Tinv(1,1);
scale_recovered=sqrt(ss*ss + sc*sc);
theta_recovered=atan2(ss,sc)*180/pi;
outputView=imref2d(size(original));
recovered=imwarp(distorted,tform,'OutputView',outputView);
