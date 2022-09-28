function MakeFigure_02_TestMemoryModules(constructor, varargin)
% MakeFigure_02_TestMemoryModules(constructor)
separate_figures = false;

nU = 500; nP = 10; nB = 10;
process_varargin(varargin);

if ~separate_figures
    figure;
end

R = SimilarityOfRandomPatterns(constructor, nU, 100);

H = constructor(nU);
T = H.myName;

if separate_figures, figure; else subplot(3,1,1); end
S = Test(constructor, nU, nP, 0.1);
imagesc(S); C = colorbar; title(T, 'interpreter', 'none');
caxis([0 1]); 
ylabel(C, 'Pattern similarity'); set(C, 'ytick', [0 1]);
xlabel('Patterns'); ylabel('Patterns'); xticks([]); yticks([]);
axis square;
if separate_figures, FigureLayout('layout', [0.5 0.5]); end

if separate_figures, figure; else subplot(3,1,2); end
cla; hold on
switch H.myName
    case 'MM_OuterProduct', N = linspace(0,5,100);
    case 'Hopfield', N = linspace(0,2,100);
    otherwise
        error('Unknown memory module');
end

S = PatternSimilarityNoRecall(constructor, nU, nB, N);
h(1) = ShadedErrorbar(N, nanmean(S), nanstderr(S), 'color','k');
S = PureNoiseTest(constructor, nU, nB, N);
h(2) = ShadedErrorbar(N, nanmean(S), nanstderr(S), 'color','b');
S = PatternNoiseTest(constructor, nU, nB, nP, N);
h(3) = ShadedErrorbar(N, nanmean(S), nanstderr(S), 'color','r');
line(xlim, [0 0], 'color', 'k', 'LineWidth', 2);
legend(h, 'no recall', '1 P stored', sprintf('%d P stored', nP));
yticks([0 1]); ylabel('Pattern similarity');
if separate_figures, FigureLayout('layout', [0.5 0.5]); end

switch H.myName
    case 'MM_OuterProduct',xticks(0:5); xlabel('Noise added (eta * randn())'); 
    case 'Hopfield', xticks([0 0.5 1 1.5]); xticklabels({'0','0.5','1', 'all'}); xlabel('Noise Added (proportion of bits flipped)');
    otherwise
        error('Unknown memory module');
end

if separate_figures, figure; else subplot(3,1,3); end
cla; hold on; clear h
R = Test_Framing(constructor, 'nU', 500, 'nB', 25);
nP = length(R.p1);
h(1) = errorbar(1:nP, nanmean(R.S(:,:,1)), nanstderr(R.S(:,:,1)), 'b');
h(2) = errorbar(1:nP, nanmean(R.S(:,:,2)), nanstderr(R.S(:,:,2)), 'r');
line(xlim, [0 0], 'color', 'k', 'LineWidth', 2);
legend(h,'Pattern 1', 'Pattern 2');
ylabel('p(recall)');
xlabel('proportion included');
xL = cell(nP,1); for iL = 1:nP; xL{iL} = sprintf('%.2f:%.2f', R.p1(iL)/R.nU, R.p2(iL)/R.nU); end
set(gca, 'XTick', [0, nP/2 nP], ...
    'XTickLabel', arrayfun(@(x,y)sprintf('%.1f:%.1f',x,y), [R.p1(1)/R.nU 0 0], [0 0 R.p2(end)/nU], 'UniformOutput', false));
yticks([0 1]);
if separate_figures, FigureLayout('layout', [0.5 0.5]); end

if ~separate_figures, FigureLayout('layout', [0.5 1]); end

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