% Experiments
rng('shuffle');

%% A basic flood

A = Agent('nTimeSteps', 500);
A.ImposeFlood(100,0.5, 1000.0);
A.CycleStore;
clf;
plot(A.getAssetCostNoRecall)
hold on
plot(A.getAssetCost,'r')
ylabel('Asset cost decrease');
legend('without hopfield recall','with hopfield recall');

%% 10 simulated agents
nA = 10;
ACNR = nan(100,500); 
ACWR = nan(100,500);
for iA = 1:nA
    h = waitbar(iA/nA);
    A = Agent('nTimeSteps', 500);
    A.ImposeFlood(100,0.5, 1000.0);
    A.CycleStore;
    ACNR(iA,:) = A.getAssetCostNoRecall;
    ACWR(iA,:) = A.getAssetCost;
end
delete(h);
clf;
hold on
h1 = plot(1:500, nanmean(ACNR), 'b');
h2 = plot(1:500, nanmean(ACWR), 'r');
ylabel('Asset cost decrease');
plot(1:500, ACNR, 'b.', 'MarkerSize', 1);
plot(1:500, ACWR, 'r.', 'MarkerSize', 1);
legend([h1 h2], 'without hopfield recall','with hopfield recall');

%% Salience

A1 = Agent('nTimeSteps', 500);
A1.ImposeFlood(100,0.5, 1000.0);
A1.CycleStore;

A2 = Agent('nTimeSteps', 500);
A2.ImposeFlood(100,0.1, 1000.0);
A2.CycleStore;

clf; hold on
plot(A1.getAssetCostNoRecall,'c'); 
plot(A1.getAssetCost(10),'b')
plot(A2.getAssetCostNoRecall,'m'); 
plot(A2.getAssetCost(10),'r')
ylabel('Asset cost decrease');
legend('without hopfield recall','with hopfield recall', 'without hopfield recall','with hopfield recall');

%% Salience: 10 agents
nA = 10;
S = [0.1 0.5];
nS = length(S);

ACNR = nan(nA,nS,500); 
ACWR = nan(nA,nS,500);

for iA = 1:nA
    h = waitbar(iA/nA);
    for iS = 1:nS
        A = Agent('nTimeSteps', 500);
        A.ImposeFlood(100,S(iS), 1000.0);
        A.CycleStore;
        ACNR(iA,iS,:) = A.getAssetCostNoRecall;
        ACWR(iA,iS,:) = A.getAssetCost(10);
    end
end
delete(h);
     
figure; c = 'brgkcym';
for iS = 1:nS
    subplot(211); hold on; plot(1:500, nanmean(squeeze(ACNR(:,iS,:))), c(iS));
    subplot(212); hold on; plot(1:500, nanmean(squeeze(ACWR(:,iS,:))), c(iS));
end
subplot(211); ylabel('Asset cost decrease'); legend('0.1','0.5'); title('without Hopfield recall');
subplot(212); ylabel('Asset cost decrease'); legend('0.1','0.5'); title('with Hopfield recall');

%% Cost: 10 agents
nA = 10;
C = [500 1000];
nC = length(C);

ACNR = nan(nA,nC,500); 
ACWR = nan(nA,nC,500);

for iA = 1:nA
    h = waitbar(iA/nA);
    for iC = 1:nC
        A = Agent('nTimeSteps', 500);
        A.ImposeFlood(100,0.25, C(iC));
        A.CycleStore;
        ACNR(iA,iC,:) = A.getAssetCostNoRecall;
        ACWR(iA,iC,:) = A.getAssetCost(10);
    end
end
delete(h);
     
figure; c = 'brgkcym';
for iC = 1:nC
    subplot(211); hold on; plot(1:500, nanmean(squeeze(ACNR(:,iC,:))), c(iC));
    subplot(212); hold on; plot(1:500, nanmean(squeeze(ACWR(:,iC,:))), c(iC));
end
subplot(211); ylabel('Asset cost decrease'); legend('500','1000'); title('without Hopfield recall');
subplot(212); ylabel('Asset cost decrease'); legend('500','1000'); title('with Hopfield recall');

%% Remind flood - 1

A = Agent('nTimeSteps', 500);
A.ImposeFlood(100,0.5, 1000.0);
A.CycleStore;
clf; hold on
plot(A.getAssetCostNoRecall,'b')
A.RemindFlood(300,100);
A.RemindFlood(400,100);
plot(A.getAssetCostNoRecall,'r')
line([200 200], ylim); line([400 400], ylim);
ylabel('Asset cost decrease');
legend('without reminder','with reminder');

%% Corrective

A = Agent('nTimeSteps', 500);
A.ImposeFlood(100,0.5, 1000.0);
A.CycleStore;
clf; hold on
plot(A.getAssetCostNoRecall,'b')
A.AlleviateMemory(100, 1.0);
plot(A.getAssetCostNoRecall,'r')
ylabel('Asset cost decrease');
legend('without reminder','with reminder');
