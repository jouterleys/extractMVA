function outputData = cutMVA(outputData)
% cutMVA parses data out per stance phase and normalizes.
% 
% The dat matrix is first cut using the events identified by stanceMVA and also
% normalized to the longest stance length for now.
% 
% The dat matrix is then parsed by segment, metric (force, max pressure,
% mean pressure, for now) and then by stance phase.
%
% Inputs:
%   outputData -  from readMVAscan.m
% 
% Outputs:
%   stance - raw dat parsed by stance phase.
%   norm - raw data normalized to a consistent length.
%   segment.metric.stance - metric data for segment cut into stance phases.
%   segment.metric.norm - metric data for segment normalized to a
%   consistent length. Currently the longest stance phase.

% Copyright (c) <2020> <Jereme Outerleys> Licensed under the MIT License.
% See LICENSE in the project root for license information.

events = outputData.events;
segments = outputData.maskNames;
colNames = outputData.colNames;
met = {'force';'max pressure';'mean pressure'};
dat = outputData.dat;
eLengths = max(events(:,2)-events(:,1));
x = (0:1:eLengths-1)';

for k = 1:length(events)
    outputData.stance{k,1} = dat(events(k,1):events(k,2),:);
    outputData.norm{k,1} = [x,tnorm(outputData.stance{k,1}(:,2:end),eLengths)];
end

for i = 1:length(segments)
    for j = 1:length(met)
        ind = find(contains(colNames,met{j}));
        for k = 1:length(events)
            outputData.(segments{i}).(genvarname(met{j})).stance{k,1} = outputData.stance{k,1}(:,ind(i));
            outputData.(segments{i}).(genvarname(met{j})).norm(:,k) = outputData.norm{k,1}(:,ind(i));
        end
    end
end