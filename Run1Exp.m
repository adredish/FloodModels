function R = Run1Exp(varargin)

% run one experiment

nA = 25;
nU = 500;
nT = 1000;
salience = 1; % [0 1 2 5 10];
cost = 0.75; % [0 1 5 10 20];
floodTS = 50;

eventsTS = [];
reminderAlphas = [];
costDeltas = [];

Memory2use = @MemoryModule_Hopfield; %@MemoryModule_OuterProduct;  % @MemoryModule_Hopfield
process_varargin(varargin);

%---------------------------------------------
% randomize seed
rng('shuffle');

assert(length(eventsTS) == length(reminderAlphas));
assert(length(eventsTS) == length(costDeltas));

%---------------------------------------------
% prep R
nS = length(salience);  R.salience = salience;
nC = length(cost); R.cost = cost;

R.events.flood = floodTS;
R.events.events = eventsTS;
R.events.reminderAlphas = reminderAlphas;
R.events.costDeltas = costDeltas;

AssetCost = nan(nS, nC, nA, nT);
RememberedCost = nan(nS, nC, nA, nT);
Rememory = nan(nS, nC, nA, nT);

%--------------------------------------------
% GO
T = nan(nS*nC); iT = 1;
for iS = 1:nS
    for iC = 1:nC        
        tic;
        fprintf('s=%.1f; c = %.2f: ', salience(iS), cost(iC));
        
        for iA = 1:nA
            if (nA < 100), fprintf('.'); elseif (mod(iA,10)==1), fprintf('!'); end
                       
            % run one agent
            A = Agent(Memory2use, nU, nT);
            R.MemoryType = A.M.myName;
            A.M.FLAG_keepTrackOfPatterns = false;
            
            if any(floodTS)
                for iR = 1:length(floodTS)
                    A.AddEventToList({@A.ImposeFlood, floodTS(iR), salience(iS), cost(iC)});
                end
            end
            if any(eventsTS)
                for iR = 1:length(eventsTS)
                    A.AddEventToList({@A.RemindFlood, eventsTS(iR), floodTS, reminderAlphas(iR), costDeltas(iR)});
                end
            end
            
            [AssetCost(iS,iC,iA,:), RememberedCost(iS,iC,iA,:), Rememory(iS,iC,iA,:)] = A.runTimeline('flagTestRecall', floodTS(1));
            
            delete(A);
        end
        
        % close up from this test
        T(iT) = toc;
        fprintf(': %.2f s (%.0f s remaining)\n', T(iT), nanmean(T(iT)) * (nS*nC - iT));
        iT = iT+1;
    end
end

R.AssetCost = AssetCost;
R.Rememory = Rememory;
R.RememberedCost = RememberedCost;


end
