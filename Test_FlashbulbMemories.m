clear;

%%
set(0,'DefaultFigureWindowStyle','docked')
nA = 50;
nTS = 1000;
floodTS = 50;
reminders = [250 450 650];
reminderAlpha = 0.2;
AgentType = @Agent;
%%
R{1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'reminderTS', [], 'AgentType', AgentType);
L{1} = 'no reminders';
for iR = 1:length(reminders)
    R{iR+1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'reminderTS', reminders(iR), 'reminderAlpha', reminderAlpha, 'AgentType', AgentType);
    L{iR+1} = sprintf('reminder@[%d]', reminders(iR));
end
disp('done');
%%
ShowParm('AssetCost', nTS, R, L, floodTS, reminders);
ShowParm('Rememory', nTS, R, L, floodTS, reminders);
ShowParm('RememberedCost', nTS, R, L, floodTS, reminders);

%%
ShowAgentHistogram('AssetCost', R, L, floodTS, reminders);
ShowAgentHistogram('Rememory', R, L, floodTS, reminders);
ShowAgentHistogram('RememberedCost', R, L, floodTS, reminders);

%%
ShowAgentPlot('AssetCost', R, L, floodTS, reminders);
ShowAgentPlot('Rememory', R, L, floodTS, reminders);
ShowAgentPlot('RememberedCost', R, L, floodTS, reminders);
