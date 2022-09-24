% KahanaTest
clear; clc; close all

nU = 100;
F0 = randn(nU,1);  % memory 0
F0 = F0 / norm(F0);

F1 = randn(nU,1);
F1 = F1 / norm(F1);

M = F0 * F0' + F1 * F1';
R0 = M * F0;
R1 = M * F1;

%%
F2 = repmat(F0, [1 nU]);
F3 = F2;
k = tril(true(nU));
R = rand(nU);
F3(k) = R(k);

%%
nB = 100;
recall = nan(nB,nU); dist = nan(nB, nU);
for iB = 1:nB
for iU = 1:nU
    R = rand(nU);
    F3(k) = R(k);
    R = M * F3(:,iU);
    recall(iB,iU) = mean((R-F0).^2);
    dist(iB,iU) = mean((F3(:,iU) - F0).^2);
end
end

%% 
clf
plot(dist, recall, 'k.')
xlim([0 0.5]); ylim([0 0.05]);
