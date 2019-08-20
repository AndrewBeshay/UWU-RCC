%% Load in the Picture 
I = imread("ImageOne.jpg");
%imshow(I);

%% Filterin out the Boxes in the picture
BW = im2bw(I);
s = regionprops(~BW,'Area','BoundingBox','Centroid');
corners = [];
   for i = 1:numel(s)
   a = find (s(i).Area < 6500 && s(i).Area > 5000 && abs(s(i).BoundingBox(3)-s(i).BoundingBox(4)) < 5);
    if (a == 1)
        corners = [corners;s(i).BoundingBox];
    end
   end 
    
BWoverlay =  imcomplement(BW);
   
   for i = 1:size(corners,1)

    BWoverlay(corners(i,2):(corners(i,2) + corners(i,4)),...
        corners(i,1):(corners(i,1) + corners(i,3)))=0;
   end    
figure(20)
imshow(BWoverlay)

%% Skeletonization 
%  Icomplement = imcomplement(I);
%  BW = im2bw(Icomplement);
  BW = im2bw(BWoverlay);
%% Outlining the Skeletonization 
[Pic] = convertBinImage2RGB(BWoverlay);
% BW2 = bwmorph(BW,'remove');
% BW3 = bwmorph(BW,'skel',Inf);
% imshow(BW3)
 
BW2 = bwmorph(BW,'skel',60);
%BW2 = bwskel(BW,'MinBranchLength',15);
BW2 = bwmorph(BW2,'clean');
out = bwmorph(BW2,'branchpoints');
%out = bwskel(BW,'MinBranchLength',0);
%imshow(out);
% 
Xpoints = [];
Ypoints = [];

for i = 1:size(out,2)
    for j = 1:size(out,1)
        if (find(out(j,i) == true))
            Xpoints = [Xpoints;j];
            Ypoints = [Ypoints;i];    
        end 
    end 
end 

% for i = 1:size(BWoverlay,1)
%     for j = 1:size(BWoverlay,2)
%         if (find(BWoverlay(i,j) == true))
%             Xpoints = [Xpoints;i];
%             Ypoints = [Ypoints;j];    
%         end 
%     end 
% end 

figure(21);
imshow(BWoverlay);
hold on;
plot(Ypoints,Xpoints,'r*');
hold off;
% figure(22);
% imshow(labeloverlay(I,out,'Transparency',0))

%% Finding the Width of the text in the Image
I = rgb2gray(Pic);

% Detect MSER regions.
[mserRegions, mserConnComp] = detectMSERFeatures(I, ... 
    'RegionAreaRange',[6000 120000],'ThresholdDelta',4);

figure(22);
imshow(I)
hold on
plot(mserRegions, 'showPixelList', true,'showEllipses',false)
title('MSER regions')
hold off
%% Part Two of Width Detection

% Use regionprops to measure MSER properties
mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image');

% Compute the aspect ratio using bounding box data.
bbox = vertcat(mserStats.BoundingBox);
w = bbox(:,3);
h = bbox(:,4);
aspectRatio = w./h;

% Threshold the data to determine which regions to remove. These thresholds
% may need to be tuned for other images.
filterIdx = aspectRatio' > 4; 
filterIdx = filterIdx | [mserStats.Eccentricity] > .995 ;
filterIdx = filterIdx | [mserStats.Solidity] < 0.5;
filterIdx = filterIdx | [mserStats.Extent] < 0.2 | [mserStats.Extent] > 0.9;
filterIdx = filterIdx | [mserStats.EulerNumber] < -4;

% Remove regions
mserStats(filterIdx) = [];
mserRegions(filterIdx) = [];

% Show remaining regions
figure(22)
imshow(I)
hold on
plot(mserRegions, 'showPixelList', true,'showEllipses',false)
title('After Removing Non-Text Regions Based On Geometric Properties')
hold off
%% % Get a binary image of the a region, and pad it to avoid boundary effects
% during the stroke width computation.
regionImage = mserStats(1).Image;
regionImage = padarray(regionImage, [1 1]);

% Compute the stroke width image.
distanceImage = bwdist(~regionImage); 
skeletonImage = bwmorph(regionImage, 'thin', inf);

strokeWidthImage = distanceImage;
strokeWidthImage(~skeletonImage) = 0;

% Show the region image alongside the stroke width image. 
figure(23)
subplot(1,2,1)
imagesc(regionImage)
title('Region Image')

subplot(1,2,2)
imagesc(strokeWidthImage)
title('Stroke Width Image')




%% Converting Binary to RGB Image

function [RGB_Image] = convertBinImage2RGB(BinImage)
  RGB_Image = uint8( BinImage(:,:,[1 1 1]) * 255 );
end 
