% Experiments
clear; clc; close all
rng('shuffle');

nA = 100;
nTS = 1000;
%% A basic flood
ACR = EXP_BasicFloodwithReminder('nA',nA, 'nTS', nTS);
save FloodData
%% Salience
ACRs = EXP_Salience('nA',nA, 'nTS', nTS);
save FloodData
%%
ACRsR = EXP_Salience('nA',nA, 'nTS', nTS,'includeReminder',true);
save FloodData
%%
ACRsA = EXP_Salience('nA',nA, 'nTS', nTS,'includeAlleviation',true);
save FloodData
%% Costs
ACRc = EXP_Cost('nA', nA, 'nTS', nTS);
save FloodData
%%
ACRcR = EXP_Cost('nA',nA, 'nTS', nTS,'includeReminder',true);
save FloodData
%%
ACRcA = EXP_Cost('nA',nA, 'nTS', nTS,'includeAlleviation',true);
save FloodData

%%------------------------------------------------------------------------
%%-----------------------------------------------------------------------
%% DISPLAY
load FloodData

%%
Show_ACR_separatePlots(ACR);
for iS = 1:4; subplot(2,2,iS); ylim([-10 0]);end
set(gcf, 'units','normalized','outerposition',[0 0 1 1])
print BasicFlood.png -dpng
%%
Show_ACR(ACRs); set(gcf, 'units','normalized','outerposition',[0 0 1 1])
print Salience.png -dpng
%%
Show_ACR(ACRsR); set(gcf, 'units','normalized','outerposition',[0 0 1 1])
print SalienceWithReminder.png -dpng
%%
Show_ACR(ACRsA); set(gcf, 'units','normalized','outerposition',[0 0 1 1])
print SalienceWithAlleviation.png -dpng
%%
Show_ACR(ACRc); set(gcf, 'units','normalized','outerposition',[0 0 1 1])
print Cost.png -dpng
%%
Show_ACR(ACRcR); set(gcf, 'units','normalized','outerposition',[0 0 1 1])
print CostWithReminder.png -dpng
%%
Show_ACR(ACRcA); set(gcf, 'units','normalized','outerposition',[0 0 1 1])
print CostWithAlleviation.png -dpng

%%
%%
%%
%% Media 
ACRm = EXP_Media('nA',nA, 'nTS', nTS, 'salience', 2.0);
save FloodData2
Show_ACR(ACRm); 
set(gcf, 'units','normalized','outerposition',[0 0 1 1])
print MediaReminder.png -dpng

