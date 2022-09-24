clear;

%%
nA = 50;
nTS = 1000;
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

%% Massed vs spaced
RMS{1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'AgentType', AgentType);
LMS{1} = 'no reminders';
RMS{2} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'AgentType', AgentType, ...
    'reminderTS', floodTS + [5 10 15], 'reminderAlpha', reminderAlpha);
LMS{2} = 'massed reminders';
RMS{3} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'AgentType', AgentType, ...
    'reminderTS', floodTS + [50 100 150], 'reminderAlpha', reminderAlpha);
LMS{3} = 'spaced reminders';
RMS{4} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'AgentType', AgentType, ...
    'reminderTS', floodTS + [200 400 600], 'reminderAlpha', reminderAlpha);
LMS{4} = 'far spaced reminders';


%%
set(0,'DefaultFigureWindowStyle','docked')
ShowParm('AssetCost', 'PTSD', nTS, R, L, floodTS, []);
ShowParm('Rememory', 'PTSD', nTS, R, L, floodTS, []);
ShowParm('RememberedCost', 'PTSD', nTS, R, L, floodTS, []);
