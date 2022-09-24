function Show_ACR(R)

[nS, ~, nTS] = size(R.ACR);

figure;
if nS>1, c =jet(nS); else, c = 'k'; end
clf; hold on; 
for iS = 1:nS
    ACR0 = squeeze(R.ACR(iS, :,:));
    h(iS) = plot(1:nTS, -nanmean(ACR0), 'color', c(iS,:), 'LineWidth', 2);
    ShadedErrorbar(1:nTS, -nanmean(ACR0), nanstderr(ACR0), 'color', c(iS,:));
end

ShowGraphLabels(R, h);
