% Auto-generated by cameraCalibrator app on 25-Jul-2019
%-------------------------------------------------------


% Define images to process
imageFileNames = {'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal1.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal2.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal3.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal5.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal6.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal8.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal10.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal11.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal12.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\Cal13.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\table__07_25_17_38_21.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\table__07_25_17_38_30.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\table__07_25_17_38_39.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\table__07_25_17_38_49.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\table__07_25_17_38_53.jpg',...
    'D:\Kevinly Santoso\Documents\UNI\y4s2\MTRN4230\Assignments\Assignment 2\RealCalibration\table__07_25_17_39_02.jpg',...
    };
% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 25;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
%h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
%h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')
