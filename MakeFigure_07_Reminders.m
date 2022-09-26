%% Figure 
clear; clc; close all; pack

M = @MemoryModule_Hopfield;
%M = @MemoryModule_OuterProduct;

nA = 25;

reminderSet = [250 450 650];
alpha = [0.5 0.5 0.5];
delta = [0 0 0];

%% go
R{1} = Run1Exp('Memory2use', M, 'nA', nA);
L{1} = 'baseline';
for iR = 1:length(reminderSet)
    R{iR+1} = Run1Exp('Memory2use', M, 'nA', nA, 'events', {[reminderSet(iR), alpha(iR), delta(iR)]});
    L{iR+1} = sprintf('reminder @ %d', reminderSet(iR));
end
%%
Show3(R); 
lines([R{1}.events.flood, reminderSet], 'rmmm');

%% ======================================

function Show3(R)
figure
sq = @squeeze; c = 'kmbc';
for iR = 1:length(R)
    R0 = R{iR};
    subplot(311); hold on;  ylabel('Asset Cost');
       z = R0.AssetCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c(iR));
    subplot(312); hold on; ylabel('Memory correlation');
       z = R0.Rememory; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c(iR)); 
    subplot(313); hold on; ylabel('Remembered Cost');
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