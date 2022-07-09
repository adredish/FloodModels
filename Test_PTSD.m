clear;

%%
set(0,'DefaultFigureWindowStyle','docked')
nA = 50;
nTS = 500;
floodTS = 50;
reminderDelta = [50 100 200];
reminderAlpha = 0.25;
AgentType = @Agent;
%%
R{1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'AgentType', AgentType);
L{1} = 'no reminders';
for iR = 1:length(reminderDelta)
    R{iR+1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, ...
        'reminderTS', floodTS + reminderDelta(iR):reminderDelta(iR):nTS, 'reminderAlpha', reminderAlpha, 'AgentType', AgentType);
    L{iR+1} = sprintf('reminders every %d steps', reminderDelta(iR));
end
disp('done');

%%
ShowParm('AssetCost', nTS, R, L, floodTS, []);
ShowParm('Rememory', nTS, R, L, floodTS, []);
ShowParm('RememberedCost', nTS, R, L, floodTS, []);
