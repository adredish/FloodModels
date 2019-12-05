function R = EXP_BasicFlood(nA)
if nargin==0, nA = 10; end

rng('shuffle');

nTS = 500;
ACR = nan(1,nA, nTS);

for iA = 1:nA
    fprintf('.');
    A = Agent('nTimeSteps', nTS);
    A.AddEventToList({@A.ImposeFlood, 100, 0.5, 20.0});
    A.AddEventToList({@A.AlleviateMemory, 300, 100, 0.5});
    %A.AddEventToList({@A.RemindFloodAffectH, 300, 100, 1.0});
    ACR(1,iA,:) = A.runTimeline();
    delete(A);
end

R.ACR = ACR;
R.cases = '';
R.title = 'Basic Flood';
R.lines.TS = 100; R.lines.Color='k';


