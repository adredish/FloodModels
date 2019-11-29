function Show_ACR_separatePlots(R)

[nS, ~, nTS] = size(R.ACR);

m = floor(sqrt(nS));
n = ceil(nS/m);

figure;
if nS>1, c =jet(nS); else, c = 'k'; end
for iS = 1:nS
    subplot(m,n,iS);
    ACR0 = squeeze(R.ACR(iS, :,:));
    h = plot(1:nTS, -nanmean(ACR0), 'color', c(iS,:), 'LineWidth', 2);
    ShadedErrorbar(1:500, -nanmean(ACR0), nanstderr(ACR0), 'color', c(iS,:));
    for iL = 1:length(R.lines)
        line(R.lines(iL).TS*[1 1], ylim, 'color', R.lines(iL).Color, 'LineStyle', ':', 'LineWidth', 0.1);
    end
    xlabel('Time');
    ylabel('Asset cost decrease');
    legend(h, R.cases{iS});
    title(R.title);    
end

