function R = EXP_Salience(varargin)

nA = 25;
saliences = [0.0 0.1 0.2 0.5 1.0];
process_varargin(varargin);

nS = length(saliences);

rng('shuffle');

nTS = 500;
ACR = nan(nS, nA, nTS);

tic
for iS = 1:nS
    fprintf('%d/%d (%s/%s): saliences = %3.1f; [%d tests] ', ...
        iS, nS, duration(0,0,toc, 'Format', 'mm:ss'), duration(0,0,nS * toc/(iS-1), 'Format', 'mm:ss'), ...
        saliences(iS), nA);
    for iA = 1:nA
        fprintf('.');
        A = Agent('nTimeSteps', nTS);
        A.AddEventToList({@A.ImposeFlood, 100, saliences(iS), 5.0});
        %A.AddEventToList({@A.RemindFlood, 300, 100});
        %A.AddEventToList({@A.AlleviateMemory, 300, 100, 0.5});
        ACR(iS, iA,:) = A.runTimeline();
        delete(A);
    end
    fprintf('\n');
end

R.ACR = ACR;
R.separatePlots = false;
R.cases = saliences;
R.title = 'Salience of flood';
R.lines.TS = 100; R.lines.Color='k';
