function [ outputData ] = readMVA( fileName )
% readMVA Reads summarized Pedar data exported in *.mva file format.
% 
% Inputs: fileName: full file name (including path) of the file to read
% data from
% 
% Outputs: outputData is a structure with following fields:
% a. fName is the .sol file name found inside mva file.
% b. saved name is mva filename.
% c. date/time is the date and time found inside mva file.
% d. sensor type found inside mva file.
% e. total time is total duration of collected data [sec].
% f. time per frame of data collected.
% g. frameRate or scanning rate is the sampling frequency of the sensors[Hz].
% h. units are the pressure units reported.
% i. maskNames are the segment names the foot was divided into.
% j. colNames are the names of the columns as found in the mva file.
% k. numColumns is the total number of columns including time. Should be
% the number of segments times the number of metrics reported for each
% (i.e. force, max pressure, mean pressure, +-% of mean), plus 1 for time.
% l. numRows is the total number of rows of data. assumped to be length of
% data collected times the frame rate.
% m. dat is a 2D matrix containing all
% the numerical data for the metrics reported (i.e. force, max pressure,
% mean pressure, +-% of mean)

% Heavily inspired by the awesome footpress toolbox by Usman Rashid. See
% https://github.com/GallVp/footPress

% Copyright (c) <2020> <Jereme Outerleys> Licensed under the MIT License.
% See LICENSE in the project root for license information.

readData = fileread(fileName);

% file name
expression = 'file name:\s*(.*?)\t';
fName = regexp(readData, expression, 'tokens');
outputData.fName = fName{:}{:};

% saved name
[~,mvaName,mvaExt] = fileparts(fileName);
outputData.mvaName = [mvaName,mvaExt];

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








