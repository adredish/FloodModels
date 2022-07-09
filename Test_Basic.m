clear;

%%
set(0,'DefaultFigureWindowStyle','docked')
nA = 50;
nTS = 1000;
floodTS = 50;

salience = [0 0.5 1.0 1.5 2.0];
cost = [0 0.25 0.5 0.75 1];

AgentType = @Agent;
%%
R = EXP_RUN('nA', nA, 'nTS', nTS, 'floodTS', floodTS, 'AgentType', AgentType, ...
    'salience', salience, 'cost', cost);
R.salience = salience;
R.cost = cost;
R.floodTS = floodTS;

disp('done');

%%
ShowSalienceCostSet('AssetCost', nTS, R, salience, cost, floodTS);
ShowSalienceCostSet('Rememory', nTS, R, salience, cost, floodTS);
ShowSalienceCostSet('RememberedCost', nTS, R, salience, cost, floodTS);