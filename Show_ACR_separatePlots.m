function Show_ACR_separatePlots(R)

[nS, ~, nTS] = size(R.ACR);

m = floor(sqrt(nS));
n = ceil(nS/m);

figure;
if nS>1, c =jet(nS); else, c = 'k'; end
for iS = 1:nS
    subplot(m,n,iS);
    R0 = R; 
    ACR0 = squeeze(R.ACR(iS, :,:));
    R0.ACR = ACR0;
    R0.title = R.cases{iS};
    R0.cases = [];
    
    
    h = plot(1:nTS, -nanmean(ACR0), 'color', c(iS,:), 'LineWidth', 2);
    ShadedErrorbar(1:nTS, -nanmean(ACR0), nanstderr(ACR0), 'color', c(iS,:));
    
    ShowGraphLabels(R0, h);

end

