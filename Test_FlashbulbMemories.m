%%
clear; clear class agent; close all; clc
set(0,'DefaultFigureWindowStyle','docked')
nA = 50;
nTS = 1000;
floodTS = 50;
reminders = [250 450 650];
AgentType = @Agent;
%%
R{1} = EXP_FlashbulbMemories('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'reminderTS', [],'AgentType', AgentType);
L{1} = 'no reminders';
for iR = 1:length(reminders)
    R{iR+1} = EXP_FlashbulbMemories('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'reminderTS', reminders(iR),'AgentType', AgentType);
    L{iR+1} = sprintf('reminder@[%d]', reminders(iR));
end
disp('done');
%%
ShowParm('AssetCost', nTS, R, L, 100, reminders);
ShowParm('Rememory', nTS, R, L, 100, reminders);
ShowParm('RememberedCost', nTS, R, L, 100, reminders);

%%
% ShowParmTopN('AssetCost', nTS, R, L, 100, reminders, 10);
% ShowParmTopN('Rememory', nTS, R, L, 100, reminders, 10);
% ShowParmTopN('RememberedCost', nTS, R, L, 100, reminders, 10);

%%
ShowAgentHistogram('AssetCost', R, L, 100, reminders);
ShowAgentHistogram('Rememory', R, L, 100, reminders);
ShowAgentHistogram('RememberedCost', R, L, 100, reminders);

%%
ShowAgentPlot('AssetCost', R, L, 100, reminders);
ShowAgentPlot('Rememory', R, L, 100, reminders);
ShowAgentPlot('RememberedCost', R, L, 100, reminders);

%%
function ShowAgentHistogram(parm, R, ~, floodTS, reminders)
figure;
for iR = 1:length(R)
    subplot(2,2,iR);
    X = squeeze(R{iR}.(parm));
    [~,order] = sort(sum(X,2), 'descend');
    imagesc(X(order,:));
    caxis([0 1]);
    colorbar
    title(parm)
    
    line(floodTS * [1 1], ylim, 'color','r', 'LineWidth',2);
    for iL = 1:3
        if iL > iR-1
            line(reminders(iL) * [1 1], ylim, 'color','w', 'LineStyle', ':', 'LineWidth', 2);
        else
            line(reminders(iL) * [1 1], ylim, 'color','m', 'LineWidth', 2);
        end
    end
end
end

function ShowAgentPlot(parm, R, ~, floodTS, reminders)
figure;
for iR = 1:length(R)
    subplot(2,2,iR);
    X = squeeze(R{iR}.(parm));
    plot(1:size(X,2), X', '-', 'color', [1 0 0 0.1]);
    title(parm)
    
    line(floodTS * [1 1], ylim, 'color','r', 'LineWidth',2);
    for iL = 1:3
        if iL > iR-1
            line(reminders(iL) * [1 1], ylim, 'color','w', 'LineStyle', ':', 'LineWidth', 2);
        else
            line(reminders(iL) * [1 1], ylim, 'color','m', 'LineWidth', 2);
        end
    end
end
end

function ShowParm(parm, nTS, R, L, floodTS, remindersTS)
c = 'kmbc';
figure; clf; hold on
for iR = 1:length(R)
    X = squeeze(R{iR}.(parm));
    %     X = X./X(:,floodTS);
    h(iR) = ShadedErrorbar(1:nTS, nanmean(X), nanstderr(X), 'color', c(iR));
end
ylim([0 1]);

line([floodTS floodTS], ylim, 'color', 'r');
for iR = 1:length(remindersTS)
    line([remindersTS(iR) remindersTS(iR)], ylim, 'color', 'm');
end

legend(h, L);
title(parm);

end

function ShowParmTopN(parm, nTS, R, L, floodTS, remindersTS, N)
c = 'kmbc';
figure; clf; hold on

for iR = 1:length(R)
    X = squeeze(R{iR}.(parm));
    [~,order] = sort(sum(X,2), 'descend');
    X = X(order,:);
    X = X(1:N,:);
    
    h(iR) = ShadedErrorbar(1:nTS, nanmean(X), nanstderr(X), 'color', c(iR));
end
ylim([0 1]);

line([floodTS floodTS], ylim, 'color', 'r');
for iR = 1:length(remindersTS)
    line([remindersTS(iR) remindersTS(iR)], ylim, 'color', 'm');
end

legend(h, L);
title(parm);

end

