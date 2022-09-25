% ====================================================
% TEST Memory Module
% ====================================================
clear; clc; close all; 

%%
go(@MemoryModule_OuterProduct, 'OP');
%%
go(@MemoryModule_Hopfield, 'Hopfield');
%%
function go(constructor, T)
nU = 500; nP = 10; nB = 10;
figure;

R = SimilarityOfRandomPatterns(constructor, nU, 100);

subplot(3,1,1); 
S = Test(constructor, nU, nP, 0.1);
imagesc(S); colorbar; title(sprintf('%s: BasicTest', T));
caxis([mean(R) 1])

subplot(3,1,2); cla; hold on
N = linspace(0,5,100);
S = PatternSimilarityNoRecall(constructor, nU, nB, N);
h(1) = ShadedErrorbar(N, nanmean(S), nanstderr(S), 'color','k');
S = PureNoiseTest(constructor, nU, nB, N);
h(2) = ShadedErrorbar(N, nanmean(S), nanstderr(S), 'color','b');
S = PatternNoiseTest(constructor, nU, nB, nP, N);
h(3) = ShadedErrorbar(N, nanmean(S), nanstderr(S), 'color','r');
line(xlim, nanmean(R) * [1 1], 'color', 'k', 'LineWidth', 2);
line(xlim, nanmean(R) * [1 1] + nanstderr(R), 'color', 'k', 'LineStyle', ':');
line(xlim, nanmean(R) * [1 1] - nanstderr(R), 'color', 'k', 'LineStyle', ':');
legend(h, 'no recall', '1 P stored', sprintf('%d P stored', nP));

subplot(3,1,3); cla; hold on; clear h
R = Test_Framing(constructor, 'nU', 500, 'nB', 25);
nP = length(R.p1);
h(1) = errorbar(1:nP, nanmean(R.S(:,:,1)), nanstderr(R.S(:,:,1)), 'b');
h(2) = errorbar(1:nP, nanmean(R.S(:,:,2)), nanstderr(R.S(:,:,2)), 'r');
legend('Pattern 1', 'Pattern 2');
ylabel('probability of recall');
xlabel('proportion included');
xL = cell(nP,1); for iL = 1:nP; xL{iL} = sprintf('%.2f', R.p1(iL)/R.nU); end
set(gca, 'XTick', 1:10:nP, 'XTickLabel', xL(1:10:nP));
%%

end
%%
function S = Test(constructor, nU, nP, noise)
% constructor, nU, nP, noise
% noise is size 1
H = constructor(nU);
P = H.MakePatterns(nP, nU);
H.AddPatterns(P);
X = nan(size(P)); P0 = nan(size(P));
for iP = 1:size(P,2)
    P0(:,iP) = H.AddNoise(P(:,iP), noise);
    X(:,iP) = H.Recall(P0(:,iP));
end
S = H.PatternSimilarity(X, P);
end

function S = PatternSimilarityNoRecall(constructor, nU, nB, noise)
% constructor nU nBoot noise(list)
nNoise = length(noise);
H = constructor(nU);
S = nan(nB, nNoise);
for iB = 1:nB
    P = H.MakePatterns(1, nU);
    for iN = 1:nNoise
        X = H.AddNoise(P, noise(iN));
        S(iB, iN) = H.PatternSimilarity(P, X);
    end
end
end


function S = PureNoiseTest(constructor, nU, nB, noise)
% constructor nU nBoot noise(list)
nNoise = length(noise);
H = constructor(nU);
S = nan(nB, nNoise);
for iB = 1:nB
    P = H.MakePatterns(1, nU);
    H.AddOnePattern(P);
    for iN = 1:nNoise
        X = H.Recall(H.AddNoise(P, noise(iN)));
        S(iB, iN) = H.PatternSimilarity(P, X);
    end
end
end

function S = PatternNoiseTest(constructor, nU, nB, nP, noise)
% constructor nU nBoot noise(list)
nNoise = length(noise);
H = constructor(nU);
S = nan(nB, nNoise);
for iB = 1:nB
    P = H.MakePatterns(nP, nU);
    H.AddPatterns(P);
    for iN = 1:nNoise
        X = H.Recall(H.AddNoise(P(:,1), noise(iN)));
        S(iB, iN) = H.PatternSimilarity(P(:,1), X);
    end
end
end

function S = SimilarityOfRandomPatterns(constructor, nU, nP)
% constructor nU nB
H = constructor(nU);
P = H.MakePatterns(nP,nU);
S = H.PatternSimilarity(P);
jnoti = tril(true(nP,nP),-1);
S = S(jnoti);
end