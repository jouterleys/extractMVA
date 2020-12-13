clear all
clc
%function [ outputData ] = readLscanData( fileName )
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
% file name
expression = 'file name:\s*(.*?)\t';
fName = regexp(readData, expression, 'tokens');
outputData.fName = fName{:}{:};

% date/time
expression = 'date/time\s*(.*?)\n';
dateTime = regexp(readData, expression, 'tokens');
outputData.dateTime = dateTime{:}{:};

% sensor type
expression = 'sensor type:\s*(.*?)\n';
sensorType = regexp(readData, expression, 'tokens');
outputData.sensorType = sensorType{:}{:};

% total time [secs]
expression = 'total time [secs\S:(.*?)\t';
totalTime = regexp(readData, expression, 'tokens');
outputData.totalTime = str2double(totalTime{:}{:});

% time per frame [secs]
expression = 'time per frame [secs\S:(.*?)\t';
timePerFrame = regexp(readData, expression, 'tokens');
outputData.timePerFrame = str2double(timePerFrame{:}{:});

% scanning rate [Hz]
expression = 'scanning rate [Hz\S:(.*?)\n';
frameRate = regexp(readData, expression, 'tokens');
outputData.frameRate = str2double(frameRate{:}{:});

% units of pressure
expression = 'pressure values in\s*(.*?)\n';
units = regexp(readData, expression, 'tokens');
outputData.units = units{:}{:};

% mask definitions(segments)
expression = 'mask definition:\s\n(.*?)\n\n';
maskTemp = regexp(readData, expression, 'tokens');
expression = '(\w*):';
maskNames = regexp(maskTemp{:}{:}  , expression, 'tokens');
outputData.maskNames = [maskNames{:}]';

% column names
expression = '\n(time(.*?))\n';
colNames = regexp(readData, expression, 'tokens');
colNames = textscan(colNames{:}{:},'%s','Delimiter', '\t');
outputData.colNames = [colNames{:}];
% number of columns (including time)
outputData.numColumns = length([colNames{:}]);
% number of rows
outputData.numRows = length(outputData.timePerFrame:(1/outputData.frameRate):outputData.totalTime);

% data matrix (first column is time)
expression = '\n(time(.*))';
dat = regexp(readData, expression, 'tokens');
expression = '\n(.*)';
dat = regexp(dat{:}{:}, expression, 'tokens');
dat = textscan(dat{:}{:},'%f','Delimiter', '\t');
dat = reshape(dat{1, 1},outputData.numColumns, outputData.numRows)';
outputData.dat = dat;









