function [ outputData ] = readLscanData( fileName )
fileName = 'C:\local_repos\github\mvaExtract\data\xk adidas ub 10.mva';
%READLSCANDATA Reads Pedar data exported in *.lst file format.
%
%   Inputs:
%   fileName: Name of the file to read data from
  
%   Outputs:
%   outputData is a structure with following fields:
%       a. startFrame is the starting frame number.
%       b. endFrame is the ending frame number.
%       c. fName is the file name found inside lst file.
%       d. numRows is the number of rows of sensors.
%       e. numColumns is the number of columns of sensors.
%       f. units is the units of pressure.
%       g. frameRate is the frame rate.
%       h. rowSpacingUnits is the units of row spacing.
%       i. colSpacingUnits is the units of column spacing.
%       j. rowSpacing is spacing (in meters) betweeen the sensors
%          across rows.
%       k. colSpacing is spacing (in meters) betweeen the sensors 
%          across columns.
%       l. comments is the filename of lst file loaded.
%       m. frames is a 3-D matrix, with rows, cols for sensor
%          values and the third dimension for frames.
%       n. timeVect is a vector representing time points for the 
%          frames (in seconds).
%
%
%   Copyright (c) <2020> <Jereme Outerleys>
%   Licensed under the MIT License. See LICENSE in the project
%   root for license information.
%
%   Made for use with the footPress toolbox created by Usman Rashid.
%   https://github.com/GallVp/footPress

readData = fileread(fileName);
% Get original FileName - this is hardcoded as output from pedar
% software and is not used at the moment
expression = 'file name:\s\s(.*?)\t';
fName = regexp(readData, expression, 'tokens');
outputData.fName = fName{:}{:};

% Get original FileName - this is hardcoded as output from pedar
% software and is not used at the moment
expression = 'date/time\s\s(.*?)\n';
dateTime = regexp(readData, expression, 'tokens');
outputData.dateTime = dateTime{:}{:};

% Get original FileName - this is hardcoded as output from pedar
% software and is not used at the moment
expression = 'sensor type:\s\s(.*?)\n';
sensorType = regexp(readData, expression, 'tokens');
outputData.sensorType = sensorType{:}{:};

% Get original FileName - this is hardcoded as output from pedar
% software and is not used at the moment
expression = 'total time [secs\S:(.*?)\t';
totalTime = regexp(readData, expression, 'tokens');
outputData.totalTime = str2double(totalTime{:}{:});

% Get original FileName - this is hardcoded as output from pedar
% software and is not used at the moment
expression = 'time per frame [secs\S:(.*?)\t';
timePerFrame = regexp(readData, expression, 'tokens');
outputData.timePerFrame = str2double(timePerFrame{:}{:});

% Get original FileName - this is hardcoded as output from pedar
% software and is not used at the moment
expression = 'scanning rate [Hz\S:(.*?)\n';
frameRate = regexp(readData, expression, 'tokens');
outputData.frameRate = str2double(frameRate{:}{:});


% Get original FileName - this is hardcoded as output from pedar
% software and is not used at the moment
expression = 'mask definition:\s\n(.*?)\n\n';
maskTemp = regexp(readData, expression, 'tokens');
expression = '(\w*:)';
maskNames = regexp(maskTemp{1, 1}{1, 1}  , expression, 'tokens');
outputData.maskNames = str2double(maskNames{:}{:});
