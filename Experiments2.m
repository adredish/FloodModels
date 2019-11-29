% Experiments
clear; clc
rng('shuffle');
%%
nA = 5;

%% A basic flood
ACR = EXP_BasicFloodwithReminder('nA',nA);
Show_ACR_separatePlots(ACR);
for iS = 1:4; subplot(2,2,iS); ylim([-10 0]);end

%% Salience
ACRs = EXP_Salience('nA',nA);
Show_ACR(ACRs);

%% Costs
ACRc = EXP_Cost('nA', nA);
Show_ACR(ACRc);

%%
save FloodData ACR ACRs ACRc