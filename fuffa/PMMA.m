%%%Analyze PMMA chips

%%Get the image file info
[stackfile, stackfolder] = uigetfile('*.*', 'Select the TIFF image stack (multidimensional image)');
 tifFile= [stackfolder filesep stackfile];
% %% % %Get the mirror image file infoicolor)');
 [file, folder] = uigetfile('*.*', 'Select the mirror file (TIFF image stack also)');
 mirFile= [folder filesep file];

mir=imread(mirFile,1);
data=imread(tifFile,1);
data1=double(data)./double(mir);


%figure; imshow(data,median(double(data(:)))*[0.8 1.2]);
%%=========================================================================
%%select region
%==========================================================================
out=inputdlg('how many regions do you whish to analyze?');
out=str2num(out{1});
for i=1:out
   [region,regionR]=imcrop(data1,median(double(data1(:)))*[0.8 1.2]);
   av(i)= median(region(:));
end

filename=('PmmaRed.xlsx');
xlswrite(filename,av);


