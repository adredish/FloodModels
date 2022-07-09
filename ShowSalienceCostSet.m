function ShowSalienceCostSet(parm, nTS, R, salience, cost, floodTS)
figure
iP = 1; nS = length(salience); nC = length(cost);
c = MakeColorMap2D(nS, nC);
for iS = 1:nS
    for iC = 1:nC
        subplot(nS+1, nC+1, iP); iP = iP+1;
        X = squeeze(R.(parm)(iS,iC,:,:));
        ShadedErrorbar(1:nTS, nanmean(X), nanstderr(X), 'color', squeeze(c(iS, iC, :)));
        title(sprintf('salience = %.1f; cost = %.2f', salience(iS), cost(iC)));
        ylim([0 1]);
        line([floodTS floodTS], ylim, 'color', 'k');
    end
    % all costs
    subplot(nS+1, nC+1, iP); iP = iP+1;
    for iC = 1:nC
        hold on
        ShadedErrorbar(1:nTS, nanmean(squeeze(R.(parm)(iS,iC,:,:))), nanstderr(squeeze(R.(parm)(iS,iC,:,:))), 'color', squeeze(c(iS, iC, :)));
        title(sprintf('salience = %.1f', salience(iS)));
    end
    ylim([0 1]);
    line([floodTS floodTS], ylim, 'color', 'k');
end
% all saliences
for iC = 1:nC
    subplot(nS+1, nC+1, iP); iP = iP+1;
    for iS = 1:nS
        hold on
        ShadedErrorbar(1:nTS, nanmean(squeeze(R.(parm)(iS,iC,:,:))), nanstderr(squeeze(R.(parm)(iS,iC,:,:))), 'color', squeeze(c(iS, iC, :)));
        title(sprintf('cost = %.1f', cost(iC)));
    end
    ylim([0 1]);
    line([floodTS floodTS], ylim, 'color', 'k');
end
end

%%
function I = MakeColorMap2D(nX, nY)
R = repmat(linspace(1,0,nY), nX,1);
G = repmat(linspace(1,0,nX)',1,nY);
B = repmat(linspace(0,1,nY), nX,1);
I = cat(3,R,G,B);
end
