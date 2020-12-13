function plotMVAraw(outputData)

segNames = outputData.maskNames;
colNames = outputData.colNames;

close all
figRaw = figure('name','mvaRaw','Renderer', 'painters', 'Position', [500 200 1200 800]);
set(figRaw,'DefaultAxesFontName','Times New Roman')
set(figRaw,'DefaultAxesFontSize',20)

tiledlayout(3,1, 'TileSpacing', 'compact')

nexttile
ind = find(contains(colNames,'force'));
hold on
for i = 1:length(ind)
    plot(outputData.dat(:,1),outputData.dat(:,ind(i)),'DisplayName',segNames{i})
end
ylabel('N')
title('Force')

nexttile
ind = find(contains(colNames,'max pressure'));
hold on
for i = 1:length(ind)
    plot(outputData.dat(:,1),outputData.dat(:,ind(i)),'DisplayName',segNames{i})
end
ylabel('kPA')
title('Max Pressure')

nexttile
ind = find(contains(colNames,'mean pressure'));
hold on
for i = 1:length(ind)
    plot(outputData.dat(:,1),outputData.dat(:,ind(i)),'DisplayName',segNames{i})
end
ylabel('kPA')
xlabel('Time(s)')
title('Mean Pressure')

lg = legend(nexttile(2));
lg.Location = 'northeastoutside';
set(findobj(gcf,'type','line'),'LineWidth', 1.5);
set(findobj(gcf,'type','axes'),'FontWeight','Bold')
