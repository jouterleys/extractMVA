function outputData = cutMVA(outputData,visualise)
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
    outputData.norm{k,1} = [x,tnorm(outputData.stance{k,1}(:,2:end),eLengths,'linear')];
end

for i = 1:length(segments)
    for j = 1:length(met)
        ind = find(contains(colNames,met{j}));
        for k = 1:length(events)
            outputData.(segments{i}).(genvarname(met{j})).stance{k,1} = outputData.stance{k,1}(:,ind(i));
            outputData.(segments{i}).(genvarname(met{j})).norm(:,k) = outputData.norm{k,1}(:,ind(i));
        end
        outputData.(segments{i}).(genvarname(met{j})).mean = tnorm(mean(outputData.(segments{i}).(genvarname(met{j})).norm,2),101,'linear');
    end
end

if visualise == 1
    figRaw = figure('name','meanWaveforms','Renderer', 'painters', 'Position', [0 0 800 800]);
    set(figRaw,'DefaultAxesFontName','Times New Roman')
    set(figRaw,'DefaultAxesFontSize',20)
    for j = 1:length(met)
        subplot(length(met),1,j)
        hold on
        for i = 1:length(segments)
            xVec = 0:1:length(outputData.(segments{i}).(genvarname(met{j})).mean)-1;
            plot(xVec,outputData.(segments{i}).(genvarname(met{j})).mean,'DisplayName',segments{i})
            maxlim(i) = max(outputData.(segments{i}).(genvarname(met{j})).mean);
        end
        maxlim = (round( max(maxlim) / 100 )+1)*100;
        ylim([0 maxlim])
        title(met{j})
        if contains(met{j},'force')
            ylabel('N')
        elseif contains(met{j},'pressure')
            ylabel(outputData.units)
        end
        if j==length(met)
            xlabel("% Stance")
        end
    end
    legend('Location','northeast');
    set(findobj(gcf,'type','line'),'LineWidth', 1.5);
    set(findobj(gcf,'type','axes'),'FontWeight','Bold')
end
    
    
