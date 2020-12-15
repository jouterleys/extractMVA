function outputData = cutMVA(outputData)

events = outputData.events;
segments = outputData.maskNames;
colNames = outputData.colNames;
met = {'force';'max pressure';'mean pressure'};
dat = outputData.dat;
eLengths = max(events(:,2)-events(:,1))
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