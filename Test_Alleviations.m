%%
clear;
%%
set(0,'DefaultFigureWindowStyle','docked')
nA = 50;
nTS = 1000;
floodTS = 50;
alleviations = [100 250 400];
alleviationAlpha = 0.25;
AgentType = @Agent;
%%
R{1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'alleviationTS', [], 'alleviationAlpha', alleviationAlpha, 'AgentType', AgentType);
L{1} = 'no alleviations';
for iR = 1:length(alleviations)
    R{iR+1} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'alleviationTS', alleviations(iR), 'alleviationAlpha', alleviationAlpha, 'AgentType', AgentType);
    L{iR+1} = sprintf('alleviation@[%d]', alleviations(iR));
end
disp('done');
%%
ShowParm('AssetCost', nTS, R, L, floodTS, alleviations);
ShowParm('RememberedCost', nTS, R, L, floodTS, alleviations);

%%
ShowAgentHistogram('AssetCost', R, L, floodTS, alleviations);
ShowAgentHistogram('RememberedCost', R, L, floodTS, alleviations);

%%
ShowAgentPlot('AssetCost', R, L, floodTS, alleviations);
ShowAgentPlot('RememberedCost', R, L, floodTS, alleviations);

%% ========================================================================

