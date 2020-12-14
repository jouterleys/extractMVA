function [stance_start,stance_end] = MVAstance(outputData,visualise)
% MVAstance identifies start and end of stance phases.
% 
% The assumption is made that a force column named 'all' is present and
% that it is the combined force of all segments that the pedar insole has
% been segmented into. Techniques are used similar to finding on and off
% events from vertical ground reaction force data from force platforms.
%
% Inputs:
%   outputData -  from readMVAscan.m
%   visualise -  [0 or 1]: to turn on or off the a plot to visualise the
%   estimated events.
% 
% Outputs:
% stance_start - frame indicies for stance start events.
% stance_end - frame indicies for stance end events.


% Copyright (c) <2020> <Jereme Outerleys> Licensed under the MIT License.
% See LICENSE in the project root for license information.


%% assign force data to use for event detection
ind = find(contains(outputData.colNames,'force'));

% make assumption that late force column index coincides with the "all"
% segment force.
combForce = outputData.dat(:,max(ind));

% combine forces?
% I'm not 100% if the "all" segment (or mask definition) is
% always included in the mva output. One way around this would be to use a
% combined force approach where all the "force" columns are summed. Will
% try without for now.
% find all force columns
% ind = contains(outputData.colNames,'force');
% combine forces
% combForce = sum(outputData.dat(:,ind),2);

%% filter
% run a critcally damped filter to help with some noise.
sampling_frequency = outputData.frameRate; % Hz
cutoff_frequency = 5; % Hz, low pass
filter_passes = 2; % dual pass
combForceFilt = critDampFilter(combForce,sampling_frequency,cutoff_frequency,filter_passes,0);

%% find Stance Phases
% first estimate (20% of max force)
thresh = combForceFilt > max(combForceFilt)*0.2;
%thresh = combForceFilt > 100;
events = diff(thresh);
stance_start = find(events == 1);

% lower threshold for end events
thresh = combForceFilt > 50;
%thresh = combForceFilt > median(combForceFilt(stance_start));
events = diff(thresh);
stance_end = find(events == -1);

if stance_end(1)<stance_start(1)
    stance_end(1)=[];
end

if length(stance_start) > length(stance_end)
    stance_start(end) = [];
end

%% visualise
if visualise == 1
    figRaw = figure('name','forceFilt','Renderer', 'painters', 'Position', [500 200 1200 800]);
    set(figRaw,'DefaultAxesFontName','Times New Roman')
    set(figRaw,'DefaultAxesFontSize',20)
    tiledlayout(2,1, 'TileSpacing', 'compact')
    
    nexttile
    hold on
    plot(combForce,'DisplayName','Raw')
    plot(combForceFilt,'DisplayName','Filtered')
    yline(max(combForceFilt)*0.2,'r','DisplayName','On Thresh')
    yline(median(combForceFilt(stance_start)),'b','DisplayName','Off Thresh')
    scatter(stance_start,combForceFilt(stance_start),'r','DisplayName','On Event')
    scatter(stance_end,combForceFilt(stance_end),'b','DisplayName','Off Event')
    ylabel('Force (N)')
    lg = legend(nexttile(1));
    lg.Location = 'northeastoutside';
    
    nexttile
    hold on
    plot(outputData.dat(:,ind))
    for i = 1:length(stance_start)
        xline(stance_start(i),'--')
    end
    for i = 1:length(stance_start)
        xline(stance_end(i),'--')
    end
    lg = legend(outputData.maskNames{:});
    lg.Location = 'northeastoutside';
    ylabel('Force (N)')
    xlabel('Frame Number')
    set(findobj(gcf,'type','line'),'LineWidth', 1.25);
    linkaxes()
    set(findobj(gcf,'type','axes'),'FontWeight','Bold')

end
