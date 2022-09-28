function MakeFigure_08_PTSD(varargin)

recalculate = true;

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
    if reminderSteps > 0
        events = arrayfun(@(x)[x, alpha, delta], (floodTS+reminderSteps(iR)):reminderSteps(iR):nT, 'UniformOutput', false);
        L{iR} = 'None';
    else
        events = {};
        L{iR} = sprintf('Every %d steps', reminderSteps(iR));
    end
    
    R{iR} = Run1Exp('Memory2use', M, 'nA', nA, 'events', events);
end
save Data_08_PTSD.mat R L M nA
end
%%
Show3(R,L); 
lines(R{1}.events.flood, 'r');

%% ======================================

function Show3(R,L)
figure
sq = @squeeze; c = 'kmbc';
nR = length(R);
for iR = 1:nR
    R0 = R{iR};
    
    subplot(nR,4,4*(iR-1)+1); text(1,1,L{iR}); axis off
    subplot(nR,4,4*(iR-1)+2); hold on;  ylabel('Asset Cost');
       z = R0.AssetCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c(iR));
    subplot(nR,4,4*(iR-1)+3); hold on; ylabel('Memory correlation');
       z = R0.Rememory; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c(iR)); 
    subplot(nR,4,4*(iR-1)+4); hold on; ylabel('Remembered Cost');
       z = R0.RememberedCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c(iR)); 
end
end

function lines(TS, c)
if nargin == 1, c = repmat('r', size(TS)); end
ax = findobj(gcf, 'Type', 'axes');
for iA = 1:length(ax)
    axes(ax(iA));
    line(xlim, [0 0], 'color', c(1));
    for iT = 1:length(TS)
        line([1 1] * TS(iT), ylim, 'color', c(iT));
    end
end
end

end