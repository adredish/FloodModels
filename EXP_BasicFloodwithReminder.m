function R = EXP_BasicFloodwithReminder(varargin)
nA = 25;
process_varargin(varargin);

rng('shuffle');

nTS = 500;
ACR = nan(4,nA, nTS);

for iS = 1:4   
    for iA = 1:nA
        fprintf('.');
        A = Agent('nTimeSteps', nTS);
        A.AddEventToList({@A.ImposeFlood, 100, 1.0, 20.0});
        switch iS
            case 1
            case 2        
                A.AddEventToList({@A.RemindFlood, 300, 100, 2.0});
            case 3
                A.AddEventToList({@A.AlleviateMemory, 200, 100, 0.5});
            case 4
                A.AddEventToList({@A.AlleviateMemory, 200, 100, 0.5});
                A.AddEventToList({@A.RemindFlood, 300, 100, 2.0});
        end
        ACR(iS,iA,:) = A.runTimeline();
        delete(A);
    end
    fprintf('\n');
end

R.ACR = ACR;
R.separatePlots = false;
R.cases = {'basic flood','reminder @300','alleviation @200','both alleviation and reminder'};
R.title = 'Floods';
R.lines(1).TS = 100; R.lines(1).Color='k';
R.lines(2).TS = 200; R.lines(2).Color='r';
R.lines(3).TS = 300; R.lines(3).Color='b';


