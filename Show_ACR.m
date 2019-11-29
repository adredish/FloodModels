function Show_ACR(R)

[nS, ~, nTS] = size(R.ACR);

figure;
if nS>1, c =jet(nS); else, c = 'k'; end
clf; hold on; 
for iS = 1:nS
    ACR0 = squeeze(R.ACR(iS, :,:));
    h(iS) = plot(1:nTS, -nanmean(ACR0), 'color', c(iS,:), 'LineWidth', 2);
    ShadedErrorbar(1:500, -nanmean(ACR0), nanstderr(ACR0), 'color', c(iS,:));
end

for iL = 1:length(R.lines)
    line(R.lines(iL).TS*[1 1], ylim, 'color', R.lines(iL).Color, 'LineStyle', ':', 'LineWidth', 0.1);
end

ylabel('Asset cost decrease');
if ~isempty(R.cases)
    legend(h, num2str(R.cases'))
end
title(R.title);
xlabel('Time');
