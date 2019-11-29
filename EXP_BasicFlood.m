function ACR = EXP_BasicFlood(nA)
if nargin==0, nA = 10; end

rng('shuffle');

nTS = 500;
ACR = nan(nA, nTS);

for iA = 1:nA
    fprintf('.');
    A = Agent('nTimeSteps', nTS);
    A.AddEventToList({@A.ImposeFlood, 100, 0.5, 25.0});
    ACR(iA,:) = A.runTimeline();
    delete(A);
end

clf;
plot(1:nTS, nanmean(ACR), 'b', 1:nTS, ACR, 'b.', 'MarkerSize', 1);
ylabel('Asset cost decrease');
line([100 100], ylim, 'color', 'k', 'LineWidth', 0.1);

