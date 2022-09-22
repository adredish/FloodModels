function ShowSalienceCostSet(parm, T, nTS, R, salience, cost, floodTS)
figure
iP = 1; nS = length(salience); nC = length(cost);
c = MakeColorMap2D(nS, nC);
for iS = 1:nS
    for iC = 1:nC
        subplot(nS+1, nC+1, iP); iP = iP+1;
        X = squeeze(R.(parm)(iS,iC,:,:));
        h= ShadedErrorbar(1:nTS, nanmean(X), nanstderr(X), 'color', squeeze(c(iS, iC, :)));
        CleanPlot()
        legend(h,sprintf('s=%.1f\nc=%.2f', salience(iS), cost(iC)));
    end
    % all costs
    subplot(nS+1, nC+1, iP); iP = iP+1;
    for iC = 1:nC
        hold on
        ShadedErrorbar(1:nTS, nanmean(squeeze(R.(parm)(iS,iC,:,:))), nanstderr(squeeze(R.(parm)(iS,iC,:,:))), 'color', squeeze(c(iS, iC, :)));
    end
    CleanPlot()
end
% all saliences
for iC = 1:nC
    subplot(nS+1, nC+1, iP); iP = iP+1;
    for iS = 1:nS
        hold on
        ShadedErrorbar(1:nTS, nanmean(squeeze(R.(parm)(iS,iC,:,:))), nanstderr(squeeze(R.(parm)(iS,iC,:,:))), 'color', squeeze(c(iS, iC, :)));
    end
    CleanPlot()
end

h = axes(gcf, 'visible', 'off');
ylabel(h, 'Cost', Visible=true);
xlabel(h, 'Time, Flood @ timestep 50', Visible=true);

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(findobj('Type', 'axes', 'parent', gcf), 'FontSize', 18);
set(findobj('Type', 'legend'), 'FontSize', 12, 'location', 'northeast'); 
%%
function I = MakeColorMap2D(nX, nY)
red = repmat(linspace(1,0,nY), nX,1);
grn = repmat(linspace(1,0,nX)',1,nY);
blu = repmat(linspace(0,1,nY), nX,1);
I = cat(3,red,grn,blu);
end

function CleanPlot()
set(gca, 'XTick', [0 1000], 'YTick', [0 1]);
ylim([0 1]);
line([floodTS floodTS], ylim, 'color', 'k');
% title(sprintf('%s: %s', T, parm));

% set(gca, 'XTick', [floodTS nTS], 'YTick', ylim, ...
%     'FontSize', 24');
% set(findobj('Type', 'legend'), 'FontSize', 18, 'location', 'northeast'); 
end

end