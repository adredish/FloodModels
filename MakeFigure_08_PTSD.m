function MakeFigure_08_PTSD(varargin)

recalculate = false;

M = @MemoryModule_Hopfield;
nA = 5;

nT = 1000;
floodTS = 50;

reminderSteps = [0 50 100 200];
alpha = 0.2;
delta = 0;
process_varargin(varargin);

%% go

R = [];
if ~recalculate && exist('Data_08_PTSD.mat', 'file')
    savedData = load('Data_08_PTSD.mat');
    if isequal(savedData.M,M) && savedData.nA == nA
        R = savedData.R;
        L = savedData.L;
    end
end
if isempty(R)
    
for iR = 1:length(reminderSteps)
    if reminderSteps(iR) > 0
        E = arrayfun(@(x)[x, alpha, delta], (floodTS+(reminderSteps(iR):reminderSteps(iR):nT)), 'UniformOutput', false)';
        L{iR} = 'None';
    else
        E = {};
        L{iR} = sprintf('Every %d steps', reminderSteps(iR));
    end
    
    R{iR} = Run1Exp('Memory2use', M, 'nA', nA, 'events', E);
end
save Data_08_PTSD.mat R L M nA
end
%%
c = 'kmbcr';
fig2use = figure;
for iR = 1:length(R)
    fig2use = Show3(R{iR}, c(iR), 'separate_figures', false, 'linesColor', c(iR), 'fig2use', fig2use);
    ax = findobj('Parent', fig2use, 'Type', 'axes');
    hold(ax, 'on');

%     Show3(R{iR}, c(iR), 'separate_figures', false, 'linesColor', c(iR));
end
