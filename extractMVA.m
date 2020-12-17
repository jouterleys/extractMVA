function extractMVA
% extractMVA Base function to pack and process mva files into strides.
%
% To use type extractMVA in your command window and select your mva file.
% 
% Inputs: fileName: full file name (including path) of the file to read
% data from
% 
% Outputs: outputData is a structure that contains all information from
% .mva files and also cut into stance phases and normalized.
    
% Copyright (c) <2020> <Jereme Outerleys> Licensed under the MIT License.
% See LICENSE in the project root for license information.

% Include sub folders
addpath('codebase');

[fn,fpath] = uigetfile ('*.mva');
fprintf('\nLoaded %s ...\n\n',fn);
outputData = readMVA(fullfile(fpath,fn));
plotMVAraw (outputData)
outputData = stanceMVA(outputData,1);
outputData = cutMVA(outputData);
assignin('base','outputData',outputData)