%% Make Figures
% assumes you are starting in FloodModels directory
clear; close all; 

nA = 50;  % number of agents
nT = 1000; % length of simulation (timesteps)
nU = 500;  % 250 martingale units, 250 feature units
M = @MemoryModule_Hopfield;  % M = @MemoryModule_OuterProduct;

%% prep
MemoryModule.SaveBaselineMatrix(M, 100, nU);  % creates random weights distributed appropriately for after storing 100 patterns.
%% Figure 01 - PPT
%% Figure 02 - PPT + memory model
close all hidden; 
MakeFigure_02_TestMemoryModules(@MemoryModule_Hopfield, 'nU', nU);  
FigureLayout('layout', [0.5 1.0])

MakeFigure_02_TestMemoryModules(@MemoryModule_OuterProduct, 'nU', nU);  % both are used in R2R, but only Hopfield used in paper
FigureLayout('layout', [0.5 1.0])

myPrint('F02-MemoryModules-');
disp('done');
%% Figure 03 - basic experiment
close all hidden; 
MakeFigure_03_BasicExperiment('M', M, 'nA', nA, 'separate_figures', false);

myPrint('F03-BasicExp-');
disp('done');

%% Figure 04/05/06 - salience and cost
close all hidden; 
MakeFigure_04_SalienceAndCost('M', M, 'nA', nA, 'separate_figures', false);

myPrint('F04-SxC-');
disp('done');

%% Figure 07
close all hidden; 
% F07
MakeFigure_RemindersAlphaDelta('dataFN', 'Data_07_Reminders.mat', ...
    'M', M, 'nA', nA, 'separate_figures', false, ...
    'events', [250 450 650], 'alpha', [0.5 0.5 0.5], 'delta', [0 0 0]);
myPrint('F07-Reminders-');
disp('done');

%% Figure 08
close all hidden; 
MakeFigure_08_PTSD('M', M, 'nA', nA);
FigureLayout('layout', [1 1], 'scaling', 2);
myPrint('F08-PTSD-');
disp('done');

%% Figure 09
close all hidden; 
MakeFigure_RemindersAlphaDelta('dataFN', 'Data_09_Reassessments.mat', ...
    'M', M, 'nA', nA, 'separate_figures', false, ...
    'events', [250 450 650], 'alpha', [0.1 0.1 0.1], 'delta', [0.25 0.25 0.25]);
myPrint('F09-Reassessments-');
disp('done');
%% Figure 10
close all hidden; 
% F10
MakeFigure_RemindersAlphaDelta('dataFN', 'Data_10_Alleviations.mat', ...
    'M', M, 'nA', nA, 'separate_figures', false, ...
    'events', [250 450 650], 'alpha', [0.1 0.1 0.1], 'delta', [-0.25 -0.25 -0.25]);
myPrint('F10-Alleviations-');
disp('done');

%%
close all hidden
disp('Completed');

%% Support functions
function myPrint(fn)
f = findobj('Type', 'figure');
for iF = 1:length(f)
    fn0 = sprintf('%s-%0d', fn, iF);
    disp(fn0);
    print(f(iF), sprintf('Figures/%s', fn0), '-dsvg','-painters');
    print(f(iF), sprintf('Figures/%s', fn0), '-dpng');
end
end