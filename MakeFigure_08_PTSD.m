%% Figure 
clear; clc; close all; pack

M = @MemoryModule_Hopfield;
%M = @MemoryModule_OuterProduct;

nA = 5;

nT = 1000;
floodTS = 50;
reminders = [0 50 100 200];
alpha = 0.1;
delta = 0;

%% go
for iR = 1:length(reminders)
    if reminders > 0
        events = arrayfun(@(x)[x, alpha, delta], (floodTS+reminders(iR)):reminders(iR):nT, 'UniformOutput', false);
        L{iR} = 'None';
    else
        events = {};
        L{iR} = sprintf('Every %d steps', reminders(iR));
    end
    
    R{iR} = Run1Exp('Memory2use', M, 'nA', nA, 'events', events);
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