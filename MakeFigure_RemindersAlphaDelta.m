function MakeFigure_RemindersAlphaDelta(varargin)

%% MakeFigure_07_reminders

M = @MemoryModule_Hopfield;
nA = 5;

recalculate = false;
separate_figures = false;

events = [250 450 650];
alpha = [0.5 0.5 0.5];
delta = [0 0 0];

dataFN = 'Data_RemindnersAlphaDelta.mat';

process_varargin(varargin);

%% go

R = [];
if ~recalculate && exist(dataFN, 'file')
    savedData = load(dataFN);
    if isequal(savedData.M,M) && savedData.nA == nA
        R = savedData.R;
    end
end
if isempty(R)
    R{1} = Run1Exp('Memory2use', M, 'nA', nA);
    L{1} = 'baseline';
    for iR = 1:length(events)
        R{iR+1} = Run1Exp('Memory2use', M, 'nA', nA, 'events', {[events(iR), alpha(iR), delta(iR)]});
        L{iR+1} = sprintf('[R=%d, a=%.2f, d=%.2f', events(iR), alpha(iR), delta(iR));
    end
    save(dataFN, 'R','M','nA');
end
%%
c = 'kmbc';
fig2use = figure;
for iR = 1:length(R)
    fig2use = Show3(R{iR}, c(iR), 'fig2use', fig2use);
    ax = findobj('Parent', fig2use, 'Type', 'axes');
    hold(ax, 'on');
end