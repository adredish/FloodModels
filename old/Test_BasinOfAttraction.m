% Basin of Attraction test

set(0,'DefaultFigureWindowStyle','docked')
%set(0,'DefaultFigureWindowStyle','normal')
close all
figure
%%
% Basin of Attraction test
% outer product CAM

nU = 100;
M = MemoryModule(nU);
P = M.MakePatterns(1,nU);
M.AddOnePattern(P);
M.AddPatterns(M.MakePatterns(3,nU));

% random data
nBoot = 100;
simRand = nan(nBoot,1);
for iB = 1:nBoot
    P0 = M.MakePatterns(1,nU);
    simRand(iB) = M.PatternSimilarity(P, P0);
end

nBoot = 100;
nNoise = 100;
noise = linspace(0,5,nNoise);
sim0 = nan(nBoot, nNoise);
simRecall = nan(nBoot, nNoise);
for iB = 1:nBoot
for iN = 1:nNoise
    P0 = M.AddNoise(P, noise(iN));
    R = M.Recall(P0);
    sim0(iB,iN) = M.PatternSimilarity(P, P0);
    simRecall(iB,iN) = M.PatternSimilarity(P, R);
end
end

subplot(211); cla;
plot(... % noise, sim0, 'b.', noise, simRecall, 'r.', ...
    noise, nanmean(simRecall), 'r-', ...
    noise, nanmean(sim0), 'b-')
line(xlim, [1 1] * nanmean(simRand), 'color', 'k', 'LineWidth', 2);
line(xlim, [1 1] * nanmean(simRand) + nanstderr(simRand), 'color', 'k', 'LineStyle', ':');
line(xlim, [1 1] * nanmean(simRand) - nanstderr(simRand), 'color', 'k', 'LineStyle', ':');

title('Outer Product');
disp('done');
%% Hopfield CAM
clear; clc

alpha = 0.25;

nU = 100;
M = Hopfield(nU);
P = M.MakePattern(1,nU);
M.AddOnePattern(P, alpha);
M.AddPatterns(M.MakePattern(3,nU), alpha);

% random data
nBoot = 100;
simRand = nan(nBoot,1);
for iB = 1:nBoot
    P0 = M.MakePattern(1,nU);
    simRand(iB) = M.PatternSimilarity(P, P0);
end

nBoot = 100;
nNoise = 100;
noise = linspace(0,1,nNoise);
sim0 = nan(nBoot, nNoise);
simRecall = nan(nBoot, nNoise);
for iB = 1:nBoot
for iN = 1:nNoise
    P0 = M.AddNoise(P, noise(iN));
    R = M.Recall(P0);
    sim0(iB,iN) = M.PatternSimilarity(P, P0);
    simRecall(iB,iN) = M.PatternSimilarity(P, R);
end
end

subplot(212)
plot(... % noise, sim0, 'b.', noise, simRecall, 'r.', ...
    noise, nanmean(simRecall), 'r-', ...
    noise, nanmean(sim0), 'b-')
line(xlim, [1 1] * nanmean(simRand), 'color', 'k', 'LineWidth', 2);
line(xlim, [1 1] * nanmean(simRand) + nanstderr(simRand), 'color', 'k', 'LineStyle', ':');
line(xlim, [1 1] * nanmean(simRand) - nanstderr(simRand), 'color', 'k', 'LineStyle', ':');

title('Hopfield');
disp('done');
    