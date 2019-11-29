function R = EXP_Reminder(varargin)

nA = 25;
process_varargin(varargin);

rng('shuffle');

nTS = 500;
ACR = nan(1, nA, nTS);

tic
for iA = 1:nA
    fprintf('.');
    A = Agent('nTimeSteps', nTS);
    A.AddEventToList({@A.ImposeFlood, 100, 0.5, 20});
    A.AddEventToList({@A.Remin
        ACR(iS, iA,:) = A.runTimeline();
        delete(A);
    end
    fprintf('\n');
end

R.ACR = ACR;
R.cases = costs;
R.title = 'Costs of flood';
R.lines.TS = 100; R.lines.Color='k';