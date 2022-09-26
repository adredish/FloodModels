function ShowParm(parm, T, nTS, R, L, floodTS, eventsTS, varargin)
flagSeparateFigures = false;
process_varargin(varargin);
c = 'kmbc';

if ~flagSeparateFigures, figure; end
h = [];
for iR = 1:length(R)
    if flagSeparateFigures, figure; else hold on; end
    X = squeeze(R{iR}.(parm));
    X = X./X(:,floodTS);
    h(end+1) = ShadedErrorbar(1:nTS, nanmean(X), nanstderr(X), 'color', c(iR));

    ylim([-0.1 1]);

    for iF = 1:length(floodTS)
    line([floodTS(iF) floodTS(iF)], ylim, 'color', 'r');
    end
    for iX = 1:max(iR-1, length(eventsTS))
        line([eventsTS(iX) eventsTS(iX)], ylim, 'color', 'm');
    end

    if flagSeparateFigures
        LGD = legend(h, L(iR));
        set(LGD, 'FontSize', 18);
    end
        xlabel('Time');
        ylabel(parm);
        title(sprintf('%s: %s', T, parm));

set(gca, 'XTick', sort([floodTS, eventsTS nTS]), 'YTick', ylim, ...
    'FontSize', 24');

if ~flagSeparateFigures
    LGD = legend(h, L);
    set(LGD, 'FontSize', 18);
end

end

