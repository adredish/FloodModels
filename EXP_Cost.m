function R = EXP_Cost(varargin)

nA = 25;
costs = [0 1 5 10 20];
process_varargin(varargin);

nS = length(costs);

rng('shuffle');

nTS = 500;
ACR = nan(nS, nA, nTS);

tic
for iS = 1:nS
    fprintf('%d/%d (%s/%s): costs = %3.1f; [%d tests] ', ...
        iS, nS, duration(0,0,toc, 'Format', 'mm:ss'), duration(0,0,nS * toc/(iS-1), 'Format', 'mm:ss'), ...
        costs(iS), nA);
    for iA = 1:nA
        fprintf('.');
        A = Agent('nTimeSteps', nTS);
        A.AddEventToList({@A.ImposeFlood, 100, 0.5, costs(iS)});
        ACR(iS, iA,:) = A.runTimeline();
        delete(A);
    end
    fprintf('\n');
end

R.ACR = ACR;
R.separatePlots = false;
R.cases = costs;
R.title = 'Costs of flood';
R.lines.TS = 100; R.lines.Color='k';
