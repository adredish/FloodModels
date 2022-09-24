%%
clear; clc; close all
%%
set(0,'DefaultFigureWindowStyle','docked')
nA = 5; %50;
nTS = 500; % 1000;
floodTS = 50;
eventsTS = [100 250 400];
costDeltas = repmat(-0.25, size(eventsTS));
AgentType = @Agent;
%%
R{1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'eventsTS', [], 'reminderAlphas', [], 'costDeltas', [], 'AgentType', AgentType);
L{1} = 'no alleviations';
for iR = 1:length(eventsTS)
    R{iR+1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS,  'eventsTS', eventsTS(iR), 'reminderAlphas', Agent.baselineAlpha, 'costDeltas', costDeltas(iR), 'AgentType', AgentType);
    L{iR+1} = sprintf('alleviation@[%.0f]', eventsTS(iR));
end
disp('done');
%%
ShowParm('AssetCost', 'Alleviations', nTS, R, L, floodTS, eventsTS);
ShowParm('RememberedCost', 'Alleviations', nTS, R, L, floodTS, eventsTS);
ShowParm('Rememory', 'Alleviations', nTS, R, L, floodTS, eventsTS);

%%
ShowAgentHistogram('AssetCost', R, L, floodTS, alleviations);
ShowAgentHistogram('RememberedCost', R, L, floodTS, alleviations);

%%
ShowAgentPlot('AssetCost', R, L, floodTS, alleviations);
ShowAgentPlot('RememberedCost', R, L, floodTS, alleviations);

%% ========================================================================

