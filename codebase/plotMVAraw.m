function plotMVAraw(outputData)


segNames = outputData.maskNames;
colNames = outputData.colNames;

ind = find(contains(colNames,'force'));
subplot(3,1,1)
hold on
for i = 1:length(ind)
    plot(outputData.dat(:,1),outputData.dat(:,ind(i)),'DisplayName',segNames{i})
end
ylabel('N')

ind = find(contains(colNames,'max pressure'));
subplot(3,1,2)
hold on
for i = 1:length(ind)
    plot(outputData.dat(:,1),outputData.dat(:,ind(i)),'DisplayName',segNames{i})
end
ylabel('kPA')

ind = find(contains(colNames,'mean pressure'));
subplot(3,1,3)
hold on
for i = 1:length(ind)
    plot(outputData.dat(:,1),outputData.dat(:,ind(i)),'DisplayName',segNames{i})
end
ylabel('kPA')
xlabel('Time(s)')


