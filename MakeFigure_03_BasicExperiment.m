%% Figure 3
clear; clc; close all; pack

M = @MemoryModule_Hopfield;
%M = @MemoryModule_OuterProduct;

nA = 5;

%% baseline
R = Run1Exp('Memory2use', M, 'nA', nA);
Show3(R); 
lines(R.events.flood);

%% reminder @ 250
R = Run1Exp('Memory2use', M, 'nA', nA, 'events', {[250 1 0]});  

Show3(R);
lines([R.events.flood, cellfun(@(x)x(1), R.events.events)], ['r' repmat('m', length(R.events.events))]);

%% reassessment at 250
R = Run1Exp('Memory2use', M, 'nA', nA, 'events', {[250 0.1 0.5]});  

Show3(R);
lines([R.events.flood, cellfun(@(x)x(1), R.events.events)], ['r' repmat('m', length(R.events.events))]);

%% alleviation at 250
R = Run1Exp('Memory2use', M, 'nA', nA, 'events', {[250 0.1 -0.5]});  

Show3(R);
lines([R.events.flood, cellfun(@(x)x(1), R.events.events)], ['r' repmat('m', length(R.events.events))]);

%% ======================================

function Show3(R)
figure
sq = @squeeze;
subplot(311); z = R.AssetCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z))); title('Asset Cost');
subplot(312); z = R.Rememory; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z))); title('Memory correlation');
subplot(313); z = R.RememberedCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z))); title('Remembered Cost');
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