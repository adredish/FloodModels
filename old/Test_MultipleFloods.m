clear;

%%
set(0,'DefaultFigureWindowStyle','docked')
nA = 50;
nTS = 1000;
floodTS = [50 250 450 650];
AgentType = @Agent;
%%
for iR = 1:length(floodTS)
    R{iR} = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS(1:iR),'AgentType', AgentType);
    L{iR} = sprintf('floods@[+%d]', floodTS(iR));
end
disp('done');
%%
ShowParm('AssetCost', nTS, R, L, floodTS, []);
ShowParm('Rememory', nTS, R, L, floodTS, []);
ShowParm('RememberedCost', nTS, R, L, floodTS, []);
