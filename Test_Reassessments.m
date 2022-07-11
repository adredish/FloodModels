%%
clear;
%%
set(0,'DefaultFigureWindowStyle','docked')
nA = 50;
nTS = 1000;
floodTS = 5;
alleviations = [100 250 400];
alleviationAlpha = -0.25;  % negative alleviation is recognition that flood was more expensive than previously thought
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
ShowParm('Rememory', nTS, R, L, floodTS, alleviations);
ShowParm('RememberedCost', nTS, R, L, floodTS, alleviations);