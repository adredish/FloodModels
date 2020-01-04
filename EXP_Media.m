function R = EXP_Media(varargin)

nA = 25;
nTS = 500;
salience = 1.0;
process_varargin(varargin);

rng('shuffle');

ACR = nan(3, nA, nTS);

tic
% no reminder
fprintf('No reminder [%d tests] ', nA);
for iA = 1:nA
    fprintf('.');
    A = Agent('nTimeSteps', nTS);
    A.AddEventToList({@A.ImposeFlood, 100, 1.0, 1.0});
    ACR(1, iA,:) = A.runTimeline();
    delete(A);
end
fprintf('\n');

% reminder
fprintf('Raw flood at 300 [%d tests] ', nA);
for iA = 1:nA
    fprintf('.');
    A = Agent('nTimeSteps', nTS);
    A.AddEventToList({@A.ImposeFlood, 300, 1.0, 1.0});
    ACR(2, iA,:) = A.runTimeline();
    delete(A);
end
fprintf('\n');


% reminder
fprintf('Media reminder [%d tests] ', nA);
for iA = 1:nA
    fprintf('.');
    A = Agent('nTimeSteps', nTS);
    A.AddEventToList({@A.ImposeFlood, 100, 1.0, 1.0});
    A.AddEventToList({@A.MemoryOfMemory, 300, 100, salience});
    ACR(3, iA,:) = A.runTimeline();
    delete(A);
end
fprintf('\n');

R.ACR = ACR;
R.separatePlots = false;
R.cases = [];
R.title = 'Media reminder';
R.lines(1).TS = 100; R.lines(1).Color='k'; R.lines(1).Name = 'Flood';
R.lines(2).TS = 300; R.lines(2).Color='b'; R.lines(2).Name = 'MediaEvent';
