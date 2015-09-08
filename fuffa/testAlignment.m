
% Script for testing dry and wet IRIS image alignment

% ==============================================================
% load the images
dryBlue = imread('images/Drychip_2_MMStack.ome.tif',1);
wet1 = imread('images/Stack.tif',1);

% ==============================================================
% get smaller cropped regions.
% The alignment works by looking at the bare Si regions, so
% include those
% These regions were identified manually at first.

rect1 = [467.51 613.51 96.98 95.98];
rect2 = [532.5100 674.5100 110.9800 89.9800];
% make the second region the same size at the first
rect2 = [rect2(1:2) rect1(3:4)];
[d, rect] = imcrop(dryBlue,rect1);
[w, rect2] = imcrop(wet1, rect2);

% ==============================================================
% X,Y alignment with Phase Correlation (no rotation)
[delta,q] = phCorrAlign(double(d), double(w));

% ==============================================================
% Check the alignment

dTrans = imtranslate(double(d), -1*delta);
figure; imshow(double(dTrans)+double(w), []);
