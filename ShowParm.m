function ShowParm(parm, nTS, R, L, floodTS, remindersTS)
c = 'kmbc';
figure; clf; hold on
for iR = 1:length(R)
    X = squeeze(R{iR}.(parm));
    %     X = X./X(:,floodTS);
    h(iR) = ShadedErrorbar(1:nTS, nanmean(X), nanstderr(X), 'color', c(iR));
end
ylim([0 1]);

for iR = 1:length(floodTS)
    line([floodTS(iR) floodTS(iR)], ylim, 'color', 'r');
end
for iR = 1:length(remindersTS)
    line([remindersTS(iR) remindersTS(iR)], ylim, 'color', 'm');
end

legend(h, L);
title(parm);

end
